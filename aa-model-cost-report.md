# Artificial Analysis — Model Cost vs Coding Performance Report

**Date:** 2026-06-20
**Data Source:** [artificialanalysis.ai](https://artificialanalysis.ai) model pages, [benchlm.ai](https://benchlm.ai/benchmarks/aaCodingIndex), [modelgrep.com](https://modelgrep.com/best/coding)
**Metrics:**
- **Cost (USD):** Total cost to run all AA Intelligence Index v4.1 evaluations for the model
- **Coding Index:** AA Coding Index score (0–100, higher = better coding ability)
- **Cost/Performance:** Cost ÷ Coding Index (higher = worse value)

---

## Sorted by Cost/Performance (Ascending — Best to Worst Value)

| # | Model | Cost (USD) | Coding Index | Cost/Perf | Value |
|---|---|---|---|---|---|
| 1 | gpt-oss-20B (high) | $19.22 | 18.5 | $1.04 | Best |
| 2 | DeepSeek V4 Flash (Reasoning, Max Effort) | $78.42 | 38.7 | $2.03 | ↑ |
| 3 | **MiMo-V2.5-Pro** | $99.10 | 45.5 | $2.18 | ↑ |
| 4 | gpt-oss-120b (high) | $96.28 | 28.6 | $3.37 | ↑ |
| 5 | **DeepSeek V4 Pro (Reasoning, Max Effort)** | $179.81 | 47.5 | $3.79 | ↑ |
| 6 | MiniMax-M3 | $235.23 | 43.4 | $5.42 | ↑ |
| 7 | Grok 4.3 (high) | $395.17 | 42.3 | $9.34 | ↑ |
| 8 | Nemotron 3 Ultra 550B A55B (Reasoning) | $443.63 | 37.5 | $11.83 | ↑ |
| 9 | **Gemini 3.1 Pro Preview** | $859.81 | 68.8 | $12.50 | ↑ |
| 10 | **GLM-5.2 (max)** | $868.84 | 68.8 | $12.63 | ↑ |
| 11 | Claude 4.5 Haiku (Reasoning) | $583.03 | 43.9 | $13.28 | ↑ |
| 12 | GLM-5.1 (Reasoning) | $674.00 | 43.4 | $15.53 | ↑ |
| 13 | **Kimi K2.6** | $838.58 | 47.1 | $17.80 | ↑ |
| 14 | **GPT-5.4 mini (xhigh)** | $1,157.55 | 51.5 | $22.48 | ↑ |
| 15 | Gemini 3.5 Flash (high) | $1,141.63 | 45.0 | $25.37 | ↑ |
| 16 | **Qwen3.7 Max** | $1,336.15 | 50.1 | $26.67 | ↑ |
| 17 | Mistral Medium 3.5 | $1,000.95 | 35.4 | $28.28 | ↑ |
| 18 | **GPT-5.5 (xhigh)** | $2,588.36 | 74.9 | $34.56 | ↑ |
| 19 | **Claude Opus 4.5 (Reasoning)** | $2,968.69 | 47.8 | $62.11 | ↑ |
| 20 | **Claude Opus 4.8 (Adaptive, Max Effort)** | $4,011.58 | 56.7 | $70.75 | ↑ |
| 21 | **Claude Sonnet 4.6 (Adaptive, Max Effort)** | $3,355.85 | 46.4 | $72.32 | ↑ |
| 22 | **Claude Fable 5** | $6,227.74 | 76.5 | $81.41 | Worst |

### Missing Data

| # | Model | Cost (USD) | Coding Index |
|---|---|---|---|
| 27 | Nova 2.0 Pro Preview (medium) | $466.55 | — |
| 28 | K2 Think V2 | — | — |
| 29 | Qwen3.5 397B A17B | — | 37.4 |

---

## Subscription-Adjusted Costs ($20/mo Plans)

Estimated substitution multipliers (API value per $1 spent): **ChatGPT Plus ~2×**, **Claude Pro ~2–3×** (heavy Opus users). Effective cost = API cost ÷ substitution factor. Shows what benchmark would cost if run via subscription instead of pay-per-token.

| Model | API Cost | Sub Plan | Sub Factor | Sub Cost | Coding Index | Sub Cost/Perf |
|---|---|---|---|---|---|---|
| GPT-5.5 (xhigh) | $2,588.36 | Plus ($20/mo) | 2× | $1,294.18 | 74.9 | $17.28 |
| GPT-5.4 mini (xhigh) | $1,157.55 | Plus ($20/mo) | 2× | $578.78 | 51.5 | $11.24 |
| Claude Fable 5 | $6,227.74 | Pro ($20/mo) | 2× | $3,113.87 | 76.5 | $40.70 |
| Claude Opus 4.8 (Adaptive, Max) | $4,011.58 | Pro ($20/mo) | 3× | $1,337.19 | 56.7 | $23.58 |
| Claude Sonnet 4.6 (Adaptive, Max) | $3,355.85 | Pro ($20/mo) | 2× | $1,677.93 | 46.4 | $36.16 |
| Claude Opus 4.5 (Reasoning) | $2,968.69 | Pro ($20/mo) | 3× | $989.56 | 47.8 | $20.70 |
| Claude 4.5 Haiku (Reasoning) | $583.03 | Pro ($20/mo) | 2× | $291.52 | 43.9 | $6.64 |

> **Note:** Substitution factor varies by usage pattern. 2× = typical moderate user (sub costs ~2× API equivalent). 3× = heavy Opus user where sub beats API. Source: aipricing.guru, stacktrim.com, pine.ai, bswen.com analyses.

---

## Key Takeaways

**Under subscription plans ($20/mo):**
- ChatGPT Plus (~2× substitution): GPT-5.5 drops from $34.56/pt to $17.28/pt — competitive with DeepSeek V4 Pro ($3.79/pt) but still 4.6× more per point
- Claude Pro with heavy Opus usage (~3×): Opus 4.8 goes from $70.75/pt → $23.58/pt, Opus 4.5 from $62.11/pt → $20.70/pt — closes gap with GPT-5.5 ($17.28/pt)
- Claude Pro with moderate Sonnet usage (~2×): Fable 5 stays expensive at $40.70/pt, Sonnet 4.6 at $36.16/pt — still worst value even with sub discount
- Claude 4.5 Haiku under Pro ($6.64/pt) becomes competitive with MiMo-V2.5-Pro ($2.18/pt) and GPT-5.4 mini ($11.24/pt)

**Worst value (highest cost per coding point) — API pricing:**
- Claude Fable 5 at $81.41/pt — 10× more expensive per coding point than the next best Anthropic model
- Anthropic models dominate the bottom 4 slots (Fable 5, Sonnet 4.6, Opus 4.8, Opus 4.5 Reasoning)

**Worst value — subscription-adjusted:**
- Claude Fable 5 still worst at $40.70/pt (Pro, 2×)
- Sonnet 4.6 ($36.16/pt) and Opus 4.8 ($23.58/pt) improve but remain expensive vs API-first competitors

**Best value (lowest cost per coding point among paid models):**
- gpt-oss-20B ($1.04/pt) — dirt cheap open model
- DeepSeek V4 Flash ($2.03/pt) — best value frontier-ish model
- MiMo-V2.5-Pro ($2.18/pt) — strong open-weight contender
- DeepSeek V4 Pro ($3.79/pt) — excellent value for near-frontier intelligence

**Standouts:**
- DeepSeek V4 Pro achieves Coding Index 47.5 at only $179.81 total eval cost — 22× cheaper per coding point than Claude Opus 4.8 at similar capability level
- Gemini 3.1 Pro Preview matches GLM-5.2 at Coding Index 68.8 but costs slightly less per point ($12.50 vs $12.63)
- Among proprietary frontier models, GPT-5.5 (xhigh) offers best API value at $34.56/pt; with Plus sub it drops to $17.28/pt, competitive but still 4.6× DeepSeek V4 Pro
- Subscriptions help Anthropic models most (3× for Opus heavy users) but don't close the gap with open-weight / DeepSeek alternatives

---

## Raw Data Sources

Cost data extracted from `artificialanalysis.ai/models/{slug}` page meta descriptions matching pattern: *"In total, it cost $X to evaluate [model] on the Intelligence Index"*

Coding Index data from `benchlm.ai/benchmarks/aaCodingIndex` (129 models, Jun 18 2026) and `modelgrep.com/best/coding` (updated Jun 2026).
