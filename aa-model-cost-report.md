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

## Subscription-Adjusted Costs

Effective cost of running AA evaluations via subscription vs pay-per-token. Substitution multiplier = API-equivalent monthly value ÷ subscription price. Sources: openai.com/pricing, help.openai.com, fritz.ai/chatgpt-pricing, cloudzero.com/blog/claude-api-pricing, aionx.co, tokenmix.ai, cursor.com/pricing.

### Plan Details & Verified Substitution Multipliers

| Plan | Price | Models Included | Monthly API-Equivalent | Multiplier |
|---|---|---|---|---|
| ChatGPT Plus | $20/mo | GPT-5.5, GPT-5.4 mini, Deep Research (10/mo), Sora | ~$102.50 (5K msgs + fringe) | **~5.1×** |
| ChatGPT Pro | $200/mo | GPT-5.5 Pro, o3-pro, 250 Deep Research/mo, 1M ctx | ~$2,400 (100K msgs + features) | **~12×** |
| Claude Pro | $20/mo | Sonnet 4.6 only (NO Opus) | ~$32.50 (3K Sonnet msgs) | **~1.6×** |
| Claude Max 5× | $100/mo | Sonnet 4.6 + Opus 4.7 unlocked | ~$195 (15K Opus msgs) | **~2.0×** |
| Claude Max 20× | $200/mo | Sonnet 4.6 + Opus 4.7, zero-latency priority | ~$780 (60K Opus msgs) | **~3.9×** |

### Effective Cost Per Model Under Available Plans

Sub Cost/Perf = (API Cost ÷ Multiplier) ÷ Coding Index. Empty cells = model not available on that plan.

| Model | API Cost/Perf | Plus $20 (5.1×) | Pro $200 (12×) | Pro $20 (1.6×) | Max 5× $100 (2.0×) | Max 20× $200 (3.9×) |
|---|---|---|---|---|---|---|
| GPT-5.5 (xhigh) | $34.56 | **$6.78** | **$2.88** | — | — | — |
| GPT-5.4 mini (xhigh) | $22.48 | **$4.41** | **$1.87** | — | — | — |
| Claude 4.5 Haiku (Reas.) | $13.28 | — | — | $8.30 | **$6.64** | $3.41 |
| Claude Sonnet 4.6 (Adap, Max) | $72.32 | — | — | **$45.20** | $36.16 | $18.55 |
| Claude Opus 4.5 (Reasoning) | $62.11 | — | — | — | **$31.05** | $15.93 |
| Claude Opus 4.8 (Adap, Max) | $70.75 | — | — | — | **$35.38** | $18.14 |
| Claude Fable 5 | $81.41 | — | — | — | $40.70 | **$20.88** |

> **Key insight:** ChatGPT Pro $200/mo at 12× makes GPT-5.5 ($2.88/pt) cheaper per coding point than DeepSeek V4 Pro ($3.79/pt) — the first time a proprietary frontier model beats it on cost/performance under subscription. Claude Max 20× brings Fable 5 from $81.41 → $20.88/pt, competitive with GPT-5.5 API pricing ($34.56/pt).

---

## Key Takeaways

**Under subscription plans (verified multipliers):**
- **ChatGPT Plus (5.1×):** GPT-5.5 drops $34.56/pt → $6.78/pt — now competitive with MiMo-V2.5-Pro ($2.18/pt) and DeepSeek V4 Pro ($3.79/pt)
- **ChatGPT Pro $200 (12×):** GPT-5.5 hits $2.88/pt — beats DeepSeek V4 Pro ($3.79/pt) on cost/performance for the first time among proprietary frontier models. GPT-5.4 mini at $1.87/pt rivals MiMo-V2.5-Pro ($2.18/pt)
- **Claude Pro (1.6×):** Weakest multiplier of all plans. Pro only includes Sonnet 4.6 (+ Haiku). Sonnet 4.6 drops $72.32 → $45.20/pt — still worst value in the entire dataset even after sub discount. Haiku drops $13.28 → $8.30/pt
- **Claude Max 5× (2.0×):** Unlocks Opus. Opus 4.5 goes $62.11 → $31.05/pt, Opus 4.8 $70.75 → $35.38/pt — still 9× more expensive per point than DeepSeek V4 Pro
- **Claude Max 20× (3.9×):** Fable 5 drops $81.41 → $20.88/pt — competitive with API GPT-5.5 ($34.56/pt) but still 5.5× DeepSeek V4 Pro

**Worst value (highest cost per coding point):**
- API: Claude Fable 5 at $81.41/pt — 10× more expensive per coding point than next best Anthropic
- Sub-adjusted: Sonnet 4.6 on Pro ($45.20/pt) still worst; Fable 5 on Max 20× ($20.88/pt) improves but remains expensive

**Best value (lowest cost per coding point):**
- gpt-oss-20B ($1.04/pt) — dirt cheap open model
- DeepSeek V4 Flash ($2.03/pt) — best value frontier-ish model
- GPT-5.4 mini on Pro $200 ($1.87/pt) — best value proprietary model under subscription
- GPT-5.5 on Pro $200 ($2.88/pt) — beats DeepSeek V4 Pro ($3.79/pt) for the first time

**Standouts:**
- DeepSeek V4 Pro achieves Coding Index 47.5 at $179.81 eval cost — still 22× cheaper per coding point than Claude Opus 4.8 at similar capability level, even after sub adjustments
- ChatGPT Pro $200 (12×) is the only plan where proprietary models beat DeepSeek and open-weight on cost/performance
- Claude Pro (1.6×) offers the worst subscription value — you pay nearly API rates for capped Sonnet access. Opus requires Max at $100-200/mo
- Subscriptions help Anthropic models most in absolute dollars (Fable 5: $81.41 → $20.88) but ratios remain unfavorable vs API-first competitors

---

## Raw Data Sources

Cost data extracted from `artificialanalysis.ai/models/{slug}` page meta descriptions matching pattern: *"In total, it cost $X to evaluate [model] on the Intelligence Index"*

Coding Index data from `benchlm.ai/benchmarks/aaCodingIndex` (129 models, Jun 18 2026) and `modelgrep.com/best/coding` (updated Jun 2026).
