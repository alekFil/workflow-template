## Task: Адаптировать workflow-template для локальной модели через LiteLLM + vLLM

### Context

Команда работает в корпоративном контуре без доступа к Anthropic API.
На внутреннем сервере (H100, 47 GB VRAM) развёрнута Qwen3-30B через vLLM
с OpenAI-совместимым API: `http://vllm.ml.bank.local/`.

Цель — сохранить workflow целиком (скилы, /architect, /dev, /close, /commit)
заменив только транспортный слой: CC → LiteLLM (прокси) → vLLM.

LiteLLM разворачивается на том же хосте, что и vLLM.
Разработчик настраивает CC через два env-переменных.

Depends on: —

### Что реализовать

1. Создать ветку `feature/local-model` от `oss`
2. Создать `infra/litellm/config.yaml` — маппинг `claude-*` → `qwen3` + vLLM endpoint
3. Создать `infra/litellm/docker-compose.yml` — LiteLLM как docker-сервис
4. Создать `infra/litellm/.env.example` — шаблон переменных окружения
5. Написать `SETUP-LOCAL.md` — гайд DevOps: развернуть LiteLLM на сервере
6. Написать `SETUP-DEV.md` — гайд разработчика: настроить CC за 2 шага
7. Обновить `README.md` — добавить секцию "Local model" со ссылками на оба гайда

### Схема

```text
[Машина разработчика]          [Корпоративный сервер]
CC
  ANTHROPIC_BASE_URL=http://litellm.ml.bank.local:4000
  ANTHROPIC_API_KEY=<LITELLM_MASTER_KEY>
        │
        ▼
LiteLLM :4000  (docker, тот же хост что vLLM)
  Anthropic API format → OpenAI API format
        │
        ▼
vLLM :8000  →  Qwen3-30B
  http://vllm.ml.bank.local/v1
```

### Files

Создать:
- `infra/litellm/config.yaml`
- `infra/litellm/docker-compose.yml`
- `infra/litellm/.env.example`
- `SETUP-LOCAL.md`
- `SETUP-DEV.md`

Редактировать:
- `README.md` — добавить секцию "Local model" после "Quick start"

### infra/litellm/config.yaml — целевое содержимое

```yaml
model_list:
  - model_name: claude-sonnet-4-6
    litellm_params:
      model: openai/qwen3-30b
      api_base: ${VLLM_API_BASE}
      api_key: ${VLLM_API_KEY}
  - model_name: claude-opus-4-7
    litellm_params:
      model: openai/qwen3-30b
      api_base: ${VLLM_API_BASE}
      api_key: ${VLLM_API_KEY}
  - model_name: claude-haiku-4-5
    litellm_params:
      model: openai/qwen3-30b
      api_base: ${VLLM_API_BASE}
      api_key: ${VLLM_API_KEY}

litellm_settings:
  drop_params: true

general_settings:
  master_key: ${LITELLM_MASTER_KEY}
```

### infra/litellm/.env.example — целевое содержимое

```bash
LITELLM_MASTER_KEY=sk-internal-changeme
VLLM_API_BASE=http://vllm.ml.bank.local/v1
VLLM_API_KEY=dummy
```

### Constraints

- `template/` не трогать — он остаётся универсальным (не привязан к инфре)
- Адаптацию скилов под Qwen3 — не делать сейчас (Phase 2, после теста)
- В docker-compose использовать официальный образ `ghcr.io/berriai/litellm`
- Все чувствительные значения — только через `.env`, не хардкодить в yaml
- `SETUP-LOCAL.md` и `SETUP-DEV.md` писать на русском (язык команды)
- README.md — секция "Local model" только добавляется, существующие секции не трогать

### Verification

```bash
# Структура файлов
ls infra/litellm/config.yaml infra/litellm/docker-compose.yml infra/litellm/.env.example

# Гайды присутствуют
ls SETUP-LOCAL.md SETUP-DEV.md

# README обновлён
grep -n "Local model" README.md

# Маппинг в конфиге
grep -n "claude-sonnet-4-6" infra/litellm/config.yaml
grep -n "qwen3-30b" infra/litellm/config.yaml

# Env-переменные не захардкожены
grep -rn "sk-internal" infra/litellm/config.yaml  # должен вернуть пусто
```

### Changes along the way

(нет)
