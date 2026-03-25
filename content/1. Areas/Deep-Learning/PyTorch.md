---
type: note
tags: [topic/deep-learning, type/learning]
status: done
created: 2026-03-12
---

# PyTorch

> Meta(Facebook AI Research)가 개발한 Python 기반 오픈소스 딥러닝 프레임워크.

## 핵심 특징

### 동적 계산 그래프 (Define-by-Run)
실행 시점에 그래프가 즉시 생성 → Python 디버거로 직관적 디버깅.
```python
x = torch.tensor([1.0, 2.0], requires_grad=True)
y = x * 2
y.sum().backward()
print(x.grad)  # tensor([2., 2.])
```

정적 그래프(TensorFlow 1.x)와 달리 매 forward pass마다 새 그래프를 생성한다.

### 자동 미분 (Autograd)
requires_grad=True 텐서의 연산을 추적 → .backward() 호출 시 전체 기울기 자동 계산.
```python
loss = criterion(output, target)
loss.backward()
optimizer.step()
```

### NumPy 호환 API
```python
tensor = torch.from_numpy(np.array([1, 2, 3]))  # NumPy → Tensor
arr    = tensor.numpy()                           # Tensor → NumPy
```

---

## 버전 히스토리

| 버전 | 릴리스 | 주요 변경 |
|------|--------|-----------|
| **2.10.0** | 2026-01-21 | 최신 안정 버전 (Python 3.10+ 필수) |
| 2.9.0 | 2025-10-15 | 안정화 업데이트 |
| 2.8.0 | 2025-08-06 | 성능 개선 |
| 2.7.0 | 2025-04-23 | FlexAttention x86 CPU, Blackwell GPU, Mega Cache |
| 2.6.0 | 2025-01-29 | torch.compile Python 3.13 지원, set_stance 추가 |
| 2.5.0 | 2024-10-17 | FlexAttention 첫 도입 |

---

## torch.compile (2.x 핵심)

모델을 컴파일하여 eager 모드 대비 속도 향상.
```python
model = torch.compile(model)  # 한 줄 추가만으로 최적화
```

내부 흐름:
Python 코드
└── TorchDynamo  : 바이트코드 분석 → FX 그래프 캡처
└── TorchInductor : FX 그래프 → Triton 커널(GPU) / C++(CPU)

주요 기능:
- **set_stance** (2.6): 재컴파일 시 동작 전략 지정
- **Mega Cache** (2.7): 컴파일 결과 저장 → 다른 머신에서 재사용
- **FlexAttention** (2.5~): LLM 추론용 Attention 변형을 유연하게 구현

---

## 핵심 구성요소
torch              → 핵심 텐서 연산
torch.nn           → 신경망 레이어, 손실함수
torch.optim        → 옵티마이저 (Adam, SGD, AdamW)
torch.utils.data   → Dataset, DataLoader
torch.compile      → 모델 컴파일·최적화
torchvision        → 이미지 처리
torchaudio         → 오디오 처리

---

## 최소 학습 루프 패턴
```python
import torch
import torch.nn as nn

class Net(nn.Module):
    def __init__(self):
        super().__init__()
        self.fc = nn.Linear(784, 10)
    def forward(self, x):
        return self.fc(x)

model     = Net()
optimizer = torch.optim.Adam(model.parameters(), lr=1e-3)
criterion = nn.CrossEntropyLoss()

for x, y in dataloader:
    optimizer.zero_grad()
    loss = criterion(model(x), y)
    loss.backward()
    optimizer.step()
```

---

## 활용 분야

| 분야 | 활용 예시 |
|------|-----------|
| 컴퓨터 비전 | 이미지 분류, 객체 탐지, 세그멘테이션 |
| 자연어 처리 | LLM, 번역, 감성 분석 |
| 생성 AI | GAN, Diffusion Model, VAE |
| 강화학습 | 게임 AI, 로봇 제어 |
| 로컬 LLM | HuggingFace Transformers 백엔드 |

---

## TensorFlow 비교

| 항목 | PyTorch | TensorFlow |
|------|---------|------------|
| 개발사 | Meta | Google |
| 그래프 | 동적 (즉시 실행) | 정적 → 동적(2.x) |
| 디버깅 | 쉬움 (Python 디버거) | 복잡 |
| 연구 선호도 | ⭐ 압도적 우세 | 상대적 낮음 |
| 프로덕션 | TorchServe | TF Serving |
| 모바일 | PyTorch Mobile | TFLite |

---

## 설치
```bash
# CPU
pip install torch torchvision torchaudio

# CUDA 12.1
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# CUDA 12.8 (Blackwell 포함)
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
```

> ⚠️ Python 3.10 이상 필수 / Conda 배포 2.6부터 중단 → pip 사용

---

## LangChain에서의 역할
HuggingFacePipeline → transformers → PyTorch → 모델 추론
직접 사용 아님 — HuggingFace Transformers 백엔드로 간접 사용
transformers 5.x는 PyTorch 2.4+ 필요

---

## 관련 노트



---

> 이 내용은 Claude Code로 작성되었습니다. 무단 배포는 금지입니다.
