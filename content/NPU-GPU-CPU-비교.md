---
tags:
  - hardware
  - LLM
  - NPU
  - GPU
  - CPU
  - AI-Inference
created: 2026-03-12
updated: 2026-03-12
source: Claude Code 작성
---

# NPU vs GPU vs CPU 비교 (LLM 관점)

## TOPS란?

**TOPS (Tera Operations Per Second)** — 초당 1조 번의 연산 수행 능력.
AI의 기본 연산 단위는 **MAC (Multiply-Accumulate)**: 곱셈 + 덧셈.

> ⚠️ **주의: 정밀도에 따라 TOPS가 달라진다**

| 정밀도 | TOPS (예시) |
|--------|------------|
| FP32   | 10 TOPS    |
| FP16   | 20 TOPS    |
| INT8   | 40 TOPS    |
| INT4   | 80 TOPS    |

제조사들이 **INT4 기준 TOPS**를 발표해 숫자를 크게 보이게 만드는 경우가 많음.
Intel Meteor Lake NPU 기준 실제 11 TOPS (INT8), GPU는 18 TOPS, CPU는 5 TOPS.

---

## 하드웨어별 LLM 역할 비교

|  | CPU | GPU | NPU |
|--|-----|-----|-----|
| **연산 방식** | 범용 직렬 | 병렬 행렬 연산 | 고정 신경망 연산 |
| **LLM 적합성** | 범용, 안정적 | 가장 적합 | 제한적 지원 |
| **소프트웨어** | Ollama, llama.cpp | CUDA / ROCm / Metal | OpenVINO, IPEX-LLM |
| **정밀도** | FP32 / FP16 / INT8 | FP16 / INT8 | INT8 / INT4 |
| **유연성** | 최고 | 높음 | 낮음 (고정 모델만) |

---

## LLM 추론의 병목: 메모리 대역폭

LLM 추론은 **연산량보다 메모리 대역폭이 병목**.

- 7B 모델 추론 시: 파라미터 이동 = 7B × 2bytes (FP16) = **14GB**
- 매 토큰마다 전체 파라미터를 읽어야 함
- NPU가 연산이 빨라도 메모리 대기 시간은 동일

> 최신 연구(2025): 소형 LLM(1B)의 경우 iPhone 15 Pro에서 CPU가 GPU보다 빠른 사례 존재 (CPU: 17 tok/s vs GPU: 12.8 tok/s). GPU 메모리 전송 오버헤드 때문.

---

## NPU가 LLM에 적합하지 않은 이유

### NPU 설계 목적
- 고정된 소형 모델 (얼굴인식, 음성인식, 번역)
- **정적(static) 모델만 지원** — OpenVINO NPU는 동적 텐서 미지원

### LLM의 특성
- 동적 시퀀스 길이
- 대용량 KV Cache
- 복잡한 Attention (동적 텐서 필수)

---

## 2026 최신 동향: GPU-NPU 하이브리드

최신 연구(ISCA 2025, Hybe)에서 **GPU + NPU 하이브리드** 시스템이 등장:

| 단계 | 담당 하드웨어 | 이유 |
|------|--------------|------|
| Prefill (프롬프트 처리) | GPU | 연산량 집중, GEMM 연산 유리 |
| Decode (토큰 생성) | NPU | 메모리 대역폭 효율, GEMV 유리 |

- Hybe: H100 GPU + Samsung 4nm NPU 조합
- Llama-3 기준 H100 단독 대비 **3.9× 에너지 효율** 개선
- AMD Ryzen AI 300 시리즈: NPU(TTFT) + iGPU(토큰 생성) 하이브리드 지원

---

## Ollama 하드웨어 지원 현황 (2026년 3월 기준)

| 가속기 | Ollama 지원 |
|--------|------------|
| NVIDIA GPU (CUDA) | ✅ 완전 지원 |
| AMD GPU (ROCm) | ✅ 완전 지원 |
| Apple Metal (M 시리즈) | ✅ 완전 지원 |
| Vulkan | ✅ 지원 |
| Intel Arc GPU | ⚠️ 실험적 지원 |
| Intel NPU | ❌ 미지원 |
| Qualcomm Snapdragon X NPU | ⚠️ 별도 엔진 필요 |

> Ollama는 공식적으로 NPU를 지원하지 않음. Snapdragon X 계열은 Qualcomm 전용 NPU 엔진으로 별도 구성 필요.

---

## NPU가 유리한 경우

✅ 소형 모델 (1~3B): `phi3:mini`, `gemma2:2b`
✅ INT4 양자화 모델
✅ 저전력이 중요한 경우 (노트북 배터리)
✅ Prefill 단계 가속 (하이브리드 구성 시)
✅ 서버급 NPU (RBLN-CA12): GPU 대비 35~70% 전력 절감, 유사 처리량

❌ 7B+ 큰 모델
❌ 긴 컨텍스트 (RAG, 긴 문서)
❌ 동적 시퀀스가 많은 워크로드

---

## NPU 활용 방법 (Intel NPU — Ollama 미지원)
```powershell
pip install --pre --upgrade ipex-llm[cpp]
```

---

## RAM이 LLM에서 가장 중요한 이유

| RAM 용량 | 실행 가능 모델 |
|---------|--------------|
| 8GB     | 7B 이하       |
| 16GB    | 13B 이하      |
| 32GB    | 14B 쾌적, 최대 ~30B |
| 64GB    | 70B 가능      |

**메모리 대역폭도 중요**: 높을수록 토큰 생성 속도 향상.
빠른 RAM (DDR5-5400)은 동일 CPU에서 약 8% 토큰 생성 속도 향상 효과.

---

## 관련 노트

- [[AI-News]]
- [[Deep-Learning]]

---

> 이 내용은 Claude Code로 작성되었습니다. 무단 배포는 금지입니다.
