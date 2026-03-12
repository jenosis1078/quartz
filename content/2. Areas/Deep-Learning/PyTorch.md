---
type: learning
area: Deep-Learning
tags: [topic/deep-learning, type/learning]
---

# PyTorch

## 개념 요약

**PyTorch**는 Meta AI(구 Facebook AI Research)가 개발한 오픈소스 딥러닝 프레임워크다.
Python 기반으로 설계되어 직관적인 API를 제공하며, 연구와 프로덕션 모두에서 널리 사용된다.
현재 최신 안정 버전은 **2.10.0** (2026년 1월 21일 출시)이다.

---

## 핵심 특징

### 1. 동적 계산 그래프 (Dynamic Computation Graph)

연산이 실행될 때 그래프가 즉시 생성된다. 조건문·반복문을 자연스럽게 사용할 수 있어 디버깅이 용이하다.

```python
import torch

x = torch.tensor([2.0], requires_grad=True)

# 동적으로 그래프가 생성됨 — 실행 시점에 분기 가능
if x.item() > 0:
    y = x ** 2
else:
    y = x * 3

y.backward()
print(x.grad)  # tensor([4.])
```

### 2. Autograd (자동 미분)

`requires_grad=True`로 선언된 텐서에 대해 역전파 그래디언트를 자동으로 계산한다.

```python
import torch

x = torch.tensor([3.0], requires_grad=True)
y = x ** 3 + 2 * x          # y = x³ + 2x
y.backward()
print(x.grad)                # dy/dx = 3x² + 2 → tensor([29.])
```

### 3. NumPy 호환 API

PyTorch 텐서는 NumPy 배열과 거의 동일한 인터페이스를 제공한다.

```python
import torch
import numpy as np

arr = np.array([1.0, 2.0, 3.0])
t   = torch.from_numpy(arr)       # NumPy → Tensor (메모리 공유)
arr2 = t.numpy()                  # Tensor → NumPy

print(t + 1)                      # tensor([2., 3., 4.], dtype=torch.float64)
```

---

## torch.compile (2.x 핵심 기능)

`torch.compile()`은 PyTorch 2.0에서 도입된 JIT 컴파일러로, 모델을 커널 수준까지 최적화한다.

### 처리 흐름

```
Python 모델 코드
      ↓
TorchDynamo       ← Python 바이트코드를 추적해 FX Graph 추출
      ↓
AOT Autograd      ← 순전파 + 역전파 그래프를 미리 컴파일
      ↓
TorchInductor     ← 최적화된 CUDA / CPU 커널 생성 (Triton 기반)
      ↓
실행 가속
```

### 사용법

```python
import torch
import torch.nn as nn

model = nn.Linear(128, 64)
compiled_model = torch.compile(model)   # 한 줄로 컴파일

x = torch.randn(32, 128)
out = compiled_model(x)                 # 첫 실행 시 컴파일, 이후 캐시 사용
```

### 2.10 업데이트
- Python 3.14 정식 지원 (3.14t 프리스레드 빌드 실험적 지원)
- `use_deterministic_mode` 준수 → 재현 가능한 학습 가능
- TorchInductor 커널 런치 오버헤드 감소 (Combo-Kernels Fusion)
- 새로운 `DebugMode`로 수치 발산 추적 지원

---

## 수식

손실 함수 기반 파라미터 업데이트 (경사하강법):

$$\theta_{t+1} = \theta_t - \eta \nabla_\theta \mathcal{L}(\theta_t)$$

자동 미분 (연쇄 법칙):

$$\frac{\partial L}{\partial x} = \frac{\partial L}{\partial y} \cdot \frac{\partial y}{\partial x}$$

---

## 버전 히스토리 (2.5 ~ 2.10)

| 버전   | 출시일         | 주요 변경 사항                                              |
|--------|----------------|-------------------------------------------------------------|
| 2.5.0  | 2024-10-17     | FlexAttention GA, torch.compile 안정화, CUDA 12.4 지원      |
| 2.6.0  | 2025-01-30     | FP8 학습 개선, AOT Autograd 최적화, Python 3.13 지원        |
| 2.7.0  | 2025-04-23     | torch.compile 성능 향상, 분산학습 개선, TorchAO 통합        |
| 2.8.0  | 2025-07-30     | 포스트 트레이닝 워크플로우 개선, ROCm 최적화                |
| 2.9.0  | 2025-10-15     | 분산 강화학습 지원 강화, 수치 디버깅 도구 추가              |
| 2.10.0 | 2026-01-21     | Python 3.14 지원, Combo-Kernels Fusion, DebugMode, CUDA 13  |

---

## 핵심 구성요소

| 모듈              | 역할                                              |
|-------------------|---------------------------------------------------|
| `torch`           | 텐서 연산, 난수 생성, 기본 수학 함수              |
| `torch.nn`        | 레이어, 손실 함수, 모델 컨테이너 (`Module`)       |
| `torch.optim`     | SGD, Adam 등 옵티마이저                           |
| `torch.autograd`  | 자동 미분 엔진                                    |
| `torch.utils.data`| Dataset, DataLoader (배치/셔플/병렬 로딩)         |
| `torch.compile`   | JIT 컴파일러 (TorchDynamo + TorchInductor)        |
| `torch.distributed`| 분산 학습 (DDP, FSDP)                            |
| `torchvision`     | 이미지 데이터셋, 전처리, 사전학습 모델            |
| `torchaudio`      | 오디오 처리 및 모델                               |

---

## 구현 (코드) — 최소 학습 루프 패턴

```python
import torch
import torch.nn as nn
from torch.utils.data import DataLoader, TensorDataset

# 1. 데이터 준비
X = torch.randn(1000, 20)
y = torch.randn(1000, 1)
loader = DataLoader(TensorDataset(X, y), batch_size=32, shuffle=True)

# 2. 모델 정의
model = nn.Sequential(
    nn.Linear(20, 64),
    nn.ReLU(),
    nn.Linear(64, 1)
)

# 3. 손실 함수 & 옵티마이저
criterion = nn.MSELoss()
optimizer = torch.optim.Adam(model.parameters(), lr=1e-3)

# 4. 학습 루프
for epoch in range(10):
    for X_batch, y_batch in loader:
        optimizer.zero_grad()           # 그래디언트 초기화
        pred = model(X_batch)           # 순전파
        loss = criterion(pred, y_batch) # 손실 계산
        loss.backward()                 # 역전파
        optimizer.step()               # 파라미터 업데이트
    print(f"Epoch {epoch+1} | Loss: {loss.item():.4f}")
```

---

## 직관적 설명

PyTorch의 핵심 철학은 **"파이썬스럽게(Pythonic)"** 동작하는 것이다.

- **TensorFlow 1.x**가 계산 그래프를 먼저 정의하고 나중에 실행하는 **"Define-and-Run"** 방식이라면,
  PyTorch는 코드가 실행되는 순간 그래프가 만들어지는 **"Define-by-Run"** 방식이다.
- 이로 인해 `print()`, `if/else`, `for loop`를 그대로 사용할 수 있어 디버깅이 쉽다.
- `torch.compile()`은 이 유연성을 유지하면서 정적 컴파일의 성능까지 얻는 방식이다.

---

## 활용 분야

| 분야              | 활용 예시                                        |
|-------------------|--------------------------------------------------|
| 컴퓨터 비전       | 이미지 분류, 객체 탐지, 세그멘테이션             |
| 자연어 처리       | LLM 파인튜닝, 텍스트 분류, 번역                  |
| 강화학습          | PPO, GRPO 기반 포스트 트레이닝                   |
| 생성 모델         | Diffusion Model, VAE, GAN                        |
| 음성 처리         | STT, TTS, 화자 인식                              |
| 과학 계산         | 물리 시뮬레이션, 단백질 구조 예측 (AlphaFold)    |

---

## TensorFlow vs PyTorch 비교

| 항목              | PyTorch                          | TensorFlow / Keras               |
|-------------------|----------------------------------|----------------------------------|
| 계산 그래프       | 동적 (Define-by-Run)             | 정적 기본 (Define-and-Run)       |
| 디버깅            | 파이썬 디버거 그대로 사용 가능   | `tf.function` 내부는 어려움      |
| 연구 점유율       | 높음 (논문 구현 다수)            | 상대적으로 낮아지는 추세         |
| 프로덕션 배포     | TorchServe, ONNX                 | TFServing, TFLite, TF.js 풍부    |
| 모바일/엣지       | ExecuTorch                       | TFLite, TF.js                    |
| 분산 학습         | DDP, FSDP (PyTorch Native)       | Mirrored/TPU Strategy            |
| 컴파일 최적화     | `torch.compile` (2.x~)           | `tf.function`, XLA               |

---

## 설치 명령어

```bash
# CPU 전용
pip install torch torchvision torchaudio

# CUDA 12.1
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# CUDA 12.8 (최신 권장)
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
```

---

## 로컬 환경 정보

### C:\Dev\deeplearning\

| 항목         | 버전                   |
|--------------|------------------------|
| Python       | 3.12.9                 |
| PyTorch      | 2.10.0+cpu             |
| 비고         | CPU 전용 로컬 실습 환경 |

```python
import torch
print(torch.__version__)   # 2.10.0+cpu
print(torch.cuda.is_available())  # False
```

---

## LangChain에서의 역할

### C:\Dev\Teddy\langchain-kr\

| 항목         | 버전                   |
|--------------|------------------------|
| Python       | (langchain-kr 환경)    |
| PyTorch      | 2.6.0+cpu              |
| 사용 방식    | HuggingFace 백엔드로 간접 사용 |

LangChain 파이프라인에서 PyTorch를 **직접 호출하지 않는다**.
대신 `HuggingFaceEmbeddings`, `HuggingFacePipeline` 등이 내부적으로 PyTorch를 백엔드로 사용한다.

```python
from langchain_huggingface import HuggingFaceEmbeddings

# 내부적으로 PyTorch 텐서 연산이 실행됨
embeddings = HuggingFaceEmbeddings(model_name="BAAI/bge-m3")
vector = embeddings.embed_query("안녕하세요")
```

---

## 참고 논문 / 자료

- [PyTorch 공식 문서](https://pytorch.org/docs/stable/index.html)
- [PyTorch 2.10 릴리스 블로그](https://pytorch.org/blog/pytorch-2-10-release-blog/)
- Paszke et al. (2019). *PyTorch: An Imperative Style, High-Performance Deep Learning Library.* NeurIPS.
- [torch.compile 공식 튜토리얼](https://pytorch.org/tutorials/intermediate/torch_compile_tutorial.html)

---

## 관련 노트

- [[00_Home|📋 홈 대시보드]]
- [[2. Areas/Deep-Learning/index|딥러닝 영역 인덱스]]
