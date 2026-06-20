# Artificial Analysis — Model Cost vs Coding Performance

**Date:** 2026-06-20
**Data Source:** [artificialanalysis.ai](https://artificialanalysis.ai) model pages, [benchlm.ai](https://benchlm.ai/benchmarks/aaCodingIndex), [modelgrep.com](https://modelgrep.com/best/coding)
**Metrics:**
- **Cost (USD):** Total cost to run all AA Intelligence Index v4.1 evaluations for the model
- **Coding Index:** AA Coding Index score (0–100, higher = better coding ability)
- **Cost/Performance:** Cost ÷ Coding Index (higher = worse value)

---

> **Models surpassing Coding Index ~45 reach Opus 4.5-level intelligence — critical mass for effective autonomous coding work.** Below this threshold, models require significant supervision and prompt engineering. Above it, they can handle complex multi-step coding tasks reliably. DeepSeek V4 Pro (47.5), MiMo-V2.5-Pro (45.5), GPT-5.4 mini (51.5), and all frontier models above index 45 are in this tier.

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

Effective cost of running AA evaluations via subscription vs pay-per-token. Substitution multiplier = API-equivalent monthly value ÷ subscription price. Sources: 3 independent research agents × 10+ analysts (fritz.ai, aipricing.guru, stacktrim.com, semianalysis, claude-meter.com, cloudzero.com, tokenmix.ai, codynyx.dev, productcompass.pm, bswen.com, novakit.ai).

> **⚠️ Multiplier varies enormously by workload (0.08× to 197×).** Casual chat ($4-9/mo API) makes subscriptions 2-10× more expensive. Maxed-out agentic coding makes subscriptions 35-197× cheaper than API. AA benchmark evals are short single-turn prompts (no context accumulation) — closest to "power user" token count per request (~1,500 in + 500 out) at high volume. Benchmark-appropriate multipliers used below.

### Effective Cost Per Model Under Available Plans

Sub Cost/Perf = (API Cost ÷ Multiplier) ÷ Coding Index.

| Model | API C/P | Plus $20 (5×) | Pro $200 (15×) | Pro $20 (3×) | Max 5× $100 (5×) | Max 20× $200 (10×) |
|---|---|---|---|---|---|---|
| GPT-5.5 (xhigh) | $34.56 | **$6.91** | **$2.30** | — | — | — |
| GPT-5.4 mini (xhigh) | $22.48 | **$4.50** | **$1.50** | — | — | — |
| Claude 4.5 Haiku (Reas.) | $13.28 | — | — | $4.43 | **$2.66** | $1.33 |
| Claude Sonnet 4.6 (Adap, Max) | $72.32 | — | — | **$24.11** | $14.47 | $7.23 |
| Claude Opus 4.5 (Reasoning) | $62.11 | — | — | $20.70 | **$12.42** | $6.21 |
| Claude Opus 4.8 (Adap, Max) | $70.75 | — | — | $23.58 | **$14.15** | $7.07 |
| Claude Fable 5 | $81.41 | — | — | $27.14 | $16.28 | **$8.14** |

> **Key insight:** ChatGPT Pro $200 at 15× puts GPT-5.5 at $2.30/pt — beats DeepSeek V4 Pro ($3.79/pt). Claude Max 20× at 10× puts Fable 5 at $8.14/pt (10× improvement over API) but still 2× DeepSeek V4 Pro. Claude Pro at 3× is weakest — tight limits negate most sub value for benchmark workloads. Note: agentic workloads (SemiAnalysis: 40-70×; Claude Meter: 99-198×) would shift all these numbers 4-20× lower, making subscriptions dramatically cheaper than API.

---

## Key Takeaways

**Critical: multipliers vary 0.08×–197× by workload. These use benchmark-appropriate estimates (short evals, high volume). Agentic/coding-agent workloads see 4–20× MORE savings.**

**Under subscription plans (benchmark-appropriate multipliers, 3-agent verification):**
- **ChatGPT Plus (5×):** GPT-5.5 $34.56 → $6.91/pt — competitive with MiMo-V2.5-Pro ($2.18/pt) but still 1.8× DeepSeek V4 Pro ($3.79/pt)
- **ChatGPT Pro $200 (15×):** GPT-5.5 hits $2.30/pt — **beats DeepSeek V4 Pro ($3.79/pt) for first time by a proprietary model.** GPT-5.4 mini at $1.50/pt rivals MiMo-V2.5-Pro ($2.18/pt)
- **Claude Pro (3×):** Weakest multiplier. Opus IS available (budget-limited, verified) but tight caps limit value. Sonnet drops $72.32 → $24.11/pt — still worst in dataset even with sub. Haiku $13.28 → $4.43/pt
- **Claude Max 5× (5×):** Full Opus. Opus 4.5 $62.11 → $12.42/pt, Opus 4.8 $70.75 → $14.15/pt — still 3.7× DeepSeek V4 Pro
- **Claude Max 20× (10×):** Fable 5 $81.41 → $8.14/pt — 10× improvement over API. Haiku $13.28 → $1.33/pt competitive with gpt-oss-20B ($1.04/pt)

**Worst value:**
- API: Claude Fable 5 at $81.41/pt (10× next worst Anthropic)
- Sub-adjusted: Sonnet 4.6 on Pro ($24.11/pt) still worst; Opus 4.8 on Pro ($23.58/pt) close second

**Best value:**
- gpt-oss-20B ($1.04/pt) — dirt cheap open
- GPT-5.4 mini on Pro $200 ($1.50/pt) — best proprietary under sub
- GPT-5.5 on Pro $200 ($2.30/pt) — beats DeepSeek V4 Pro ($3.79/pt)
- Haiku on Max 20× ($1.33/pt) — rivals cheapest open models

**Standouts:**
- ChatGPT Pro $200 is the ONLY plan where proprietary models beat DeepSeek on cost/performance
- Claude Pro at 3× is weakest sub value — tight rolling limits ($45 Opus/5hr) cap benchmark throughput. Opus access confirmed but budget-limited
- Agentic workloads (SemiAnalysis: 40-70×; Claude Meter: 99-198×) change everything — subs become 4-20× cheaper than the benchmark estimates above. True multiplier depends entirely on your usage pattern

---

## Raw Data Sources

Cost data extracted from `artificialanalysis.ai/models/{slug}` page meta descriptions matching pattern: *"In total, it cost $X to evaluate [model] on the Intelligence Index"*

Coding Index data from `benchlm.ai/benchmarks/aaCodingIndex` (129 models, Jun 18 2026) and `modelgrep.com/best/coding` (updated Jun 2026).
