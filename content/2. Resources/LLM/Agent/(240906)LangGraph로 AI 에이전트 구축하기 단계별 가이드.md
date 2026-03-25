---
type: article
title: "How to Build AI Agents with LangGraph: A Step-by-Step Guide"
author: "Lore Van Oudenhove"
url: "https://medium.com/@lorevanoudenhove/how-to-build-ai-agents-with-langgraph-a-step-by-step-guide-5d84d9c7e832"
source: "Medium"
date: 2024-09-06
created: 2026-03-25
date_read: 2026-03-25
tags: [type/article, source/medium, topic/llm, topic/ai-agent, topic/langgraph, status/done]
---

# LangGraph로 AI 에이전트 구축하기: 단계별 가이드

> 저자: Lore Van Oudenhove (기업가, 데이터 과학자, AI 애호가)
> 출처: Medium

## 요약

LangChain에 순환 구조(cycle)를 추가한 LangGraph로 상태 유지형 AI 에이전트를 8단계 코드 실습으로 구현하는 가이드.

## 핵심 포인트

- LangGraph = LangChain + 순환 구조
	- 에이전트가 목표 달성까지 반복 가능 (START → assistant ⇄ tools → END)
- 3요소: State(공유 상태), Node(처리 단계), Edge(흐름 제어)
	- MemorySaver로 대화 흐름 유지
- `tools_condition`으로 tool 호출 여부를 자동 판단
	- LLM이 답을 알면 종료, 모르면 tool 실행

## 인사이트

"순환"이 에이전트를 가능하게 한다. 기존 체인은 A→B→C로 한 번 지나가면 끝이지만, 에이전트는 목표를 달성할 때까지 반복해야 한다. LangGraph의 가치는 이 루프를 코드 몇 줄로 구현한다는 점에 있다.

---

## LangGraph란?

LangGraph는 LangChain을 기반으로 구축된 라이브러리로, **순환 연산(cycle)** 기능을 추가하여 복잡한 에이전트형 동작을 구현할 수 있다.

![[1_57VJ-0AO8RaJHhRxNegnAg.webp]]

| | LangChain | LangGraph |
|--|--|--|
| 구조 | DAG (방향 비순환 그래프) | DAG + **순환 구조** |
| 특징 | 선형 워크플로우 | 복잡한 에이전트 동작, 상태 유지 루프 |
| 용도 | 단순 체인 | 다중 액터, 상태 유지형 에이전트 |

### 3가지 핵심 개념

- **State (상태)**: 계산이 진행됨에 따라 유지·업데이트되는 컨텍스트/메모리. 그래프의 각 단계는 이전 단계 정보에 접근 가능
- **Node (노드)**: 그래프의 구성 요소. 개별 계산 단계 또는 기능 (입력 처리, 의사 결정, 외부 시스템 상호작용 등)
- **Edge (엣지)**: 노드들을 연결하여 인산 흐름을 정의. 조건 로직 지원 → 현재 상태에 따라 다음 노드 결정

## 실습: 태양광 패널 에너지 절감액 계산 AI 에이전트

**시나리오**: 태양광 패널 판매업체의 고객 지원 에이전트
- 사용자의 월별 전기 요금을 수집
- 태양광 패널 도입 시 절감액 계산 및 견적 제공
- 잠재 고객 확보 도구로 활용

### 그래프 구조

```
__start__
    ↓
assistant ←────────────┐
    ↓ (조건부 엣지)      │
tools ──────────────────┘   __end__
    (tool 실행 후         ↗
     assistant로 복귀)
```

## 8단계 구현

![[langgraph-agent-architecture.svg]]

### 1단계: 라이브러리 임포트

```python
from langchain_core.tools import tool
from langchain_community.tools.tavily_search import TavilySearchResults
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import Runnable
from langchain_aws import ChatBedrock
import boto3
from typing import Annotated
from typing_extensions import TypedDict
from langgraph.graph.message import AnyMessage, add_messages
from langchain_core.messages import ToolMessage
from langchain_core.runnables import RunnableLambda
from langgraph.prebuilt import ToolNode
from langgraph.prebuilt import tools_condition
```

### 2단계: 도구 정의 (`compute_savings`)

월별 전기 요금 → 태양광 절감액 계산 도구

```python
@tool
def compute_savings(monthly_cost: float) -> float:
    """Tool to compute the potential savings when switching to solar energy."""
    def calculate_solar_savings(monthly_cost):
        # 가정값
        cost_per_kWh = 0.28
        cost_per_watt = 1.50
        sunlight_hours_per_day = 3.5
        panel_wattage = 350
        system_lifetime_years = 10

        monthly_consumption_kWh = monthly_cost / cost_per_kWh
        daily_energy_production = monthly_consumption_kWh / 30
        system_size_kW = daily_energy_production / sunlight_hours_per_day
        number_of_panels = system_size_kW * 1000 / panel_wattage
        installation_cost = system_size_kW * 1000 * cost_per_watt
        annual_savings = monthly_cost * 12
        net_savings = annual_savings * system_lifetime_years - installation_cost

        return {
            "number_of_panels": round(number_of_panels),
            "installation_cost": round(installation_cost, 2),
            "net_savings_10_years": round(net_savings, 2)
        }
    return calculate_solar_savings(monthly_cost)
```

### 3단계: 오류 처리 설정

```python
def handle_tool_error(state) -> dict:
    """도구 실행 중 오류 발생 시 에러 메시지 반환"""
    error = state.get("error")
    tool_calls = state["messages"][-1].tool_calls
    return {
        "messages": [
            ToolMessage(
                content=f"Error: {repr(error)}\n please fix your mistakes.",
                tool_call_id=tc["id"],
            )
            for tc in tool_calls
        ]
    }

def create_tool_node_with_fallback(tools: list) -> dict:
    """폴백 오류 처리가 있는 툴 노드 생성"""
    return ToolNode(tools).with_fallbacks(
        [RunnableLambda(handle_tool_error)],
        exception_key="error"
    )
```

### 4단계: State 및 Assistant 클래스 정의

```python
class State(TypedDict):
    messages: Annotated[list[AnyMessage], add_messages]

class Assistant:
    def __init__(self, runnable: Runnable):
        self.runnable = runnable

    def __call__(self, state: State):
        while True:
            result = self.runnable.invoke(state)
            # 유효한 출력이 없으면 재프롬프트
            if not result.tool_calls and (
                not result.content
                or isinstance(result.content, list)
                and not result.content[0].get("text")
            ):
                messages = state["messages"] + [("user", "Respond with a real output.")]
                state = {**state, "messages": messages}
            else:
                break
        return {"messages": result}
```

**핵심**: Assistant는 유효한 응답이 나올 때까지 LLM을 반복 호출한다.

### 5단계: AWS Bedrock으로 LLM 설정

```python
def get_bedrock_client(region):
    return boto3.client("bedrock-runtime", region_name=region)

def create_bedrock_llm(client):
    return ChatBedrock(
        model_id='anthropic.claude-3-sonnet-20240229-v1:0',
        client=client,
        model_kwargs={'temperature': 0}
    )

llm = create_bedrock_llm(get_bedrock_client(region='us-east-1'))
```

> AWS 자격증명(AWS CLI 또는 환경 변수) 설정 필수

### 6단계: 워크플로우 정의 (프롬프트 템플릿)

```python
primary_assistant_prompt = ChatPromptTemplate.from_messages([
    (
        "system",
        '''You are a helpful customer support assistant for Solar Panels Belgium.
You should get the following information from them:
- monthly electricity cost
If you are not able to discern this info, ask them to clarify! Do not attempt to wildly guess.
After you are able to discern all the information, call the relevant tool.''',
    ),
    ("placeholder", "{messages}"),
])

# 도구 바인딩
part_1_tools = [compute_savings]
part_1_assistant_runnable = primary_assistant_prompt | llm.bind_tools(part_1_tools)
```

### 7단계: 그래프 구조 구축

```python
builder = StateGraph(State)

# 노드 추가
builder.add_node("assistant", Assistant(part_1_assistant_runnable))
builder.add_node("tools", create_tool_node_with_fallback(part_1_tools))

# 엣지 정의
builder.add_edge(START, "assistant")          # 시작 → 어시스턴트
builder.add_conditional_edges("assistant", tools_condition)  # 어시스턴트 → 도구 or 종료
builder.add_edge("tools", "assistant")        # 도구 실행 후 → 어시스턴트로 복귀

# MemorySaver로 다단계 대화 상태 유지
memory = MemorySaver()
graph = builder.compile(checkpointer=memory)
```

![[1_PodIyQcMp9wApph_wXg-Ug.webp]]

### 8단계: 에이전트 실행

```python
import uuid

tutorial_questions = [
    'hey',
    'can you calculate my energy saving',
    'my monthly cost is $100, what will i save'
]

thread_id = str(uuid.uuid4())
config = {"configurable": {"thread_id": thread_id}}

for question in tutorial_questions:
    events = graph.stream(
        {"messages": ("user", question)}, config, stream_mode="values"
    )
    for event in events:
        _print_event(event, _printed)
```

## 핵심 아키텍처 요약

```
사용자 입력
    ↓
State (메시지 히스토리 유지)
    ↓
Assistant Node (LLM + 프롬프트)
    ↓ tools_condition
도구 호출 필요? ──Yes──→ Tool Node (compute_savings 실행)
    │                          ↓
    No                   결과를 State에 추가
    ↓                          ↓
__end__              Assistant Node로 복귀
```

## 시사점

- LangGraph의 핵심은 **순환 구조** - 에이전트가 목표 달성까지 반복 실행 가능
- **MemorySaver**로 다단계 대화에서 컨텍스트 유지
- `tools_condition`: 도구 호출 필요 여부를 자동 판단하는 조건부 엣지
- Assistant 클래스의 `while True` 루프: 유효한 응답이 나올 때까지 재시도
- 실제 프로덕션에서는 가정값(kWh 단가, 일조시간 등)을 사용자에게 직접 수집하면 더 정확

## 관련 노트

- [[AI-에이전트-프레임워크-비교-LangGraph-CrewAI-Swarm]]
- [[AI-에이전트-워크플로우-설계-패턴-개요]]
- [[AI-에이전트란-무엇인가-소개와-구축-가이드]]

---

> 이 노트는 Claude Code로 작성되었습니다. 무단 배포를 금지합니다.
