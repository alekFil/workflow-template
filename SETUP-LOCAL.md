# SETUP-LOCAL.md — Развёртывание LiteLLM на корпоративном сервере

Этот гайд — для DevOps/администратора сервера.
Предполагается, что vLLM с Qwen3-30B уже запущен и доступен по адресу `http://vllm.ml.bank.local/v1`.

## Требования

- Docker + Docker Compose на том же хосте, что и vLLM
- Порт `4000` доступен внутри корпоративной сети

## Развёртывание

### 1. Скопируй конфигурацию

```bash
cp infra/litellm/.env.example infra/litellm/.env
```

### 2. Заполни `.env`

```bash
# infra/litellm/.env
LITELLM_MASTER_KEY=sk-internal-ваш-ключ   # придумайте и сообщите команде
VLLM_API_BASE=http://vllm.ml.bank.local/v1
VLLM_API_KEY=dummy                          # vLLM не требует реального ключа
```

`LITELLM_MASTER_KEY` — внутренний ключ команды. Он заменяет Anthropic API key
на машинах разработчиков. Придумайте произвольную строку формата `sk-...`.

### 3. Запусти LiteLLM

```bash
cd infra/litellm
docker compose up -d
```

### 4. Проверь

```bash
curl http://localhost:4000/health
# ожидаемый ответ: {"status": "healthy"}

curl http://localhost:4000/v1/models \
  -H "Authorization: Bearer sk-internal-ваш-ключ"
# ожидаемый ответ: список моделей (claude-sonnet-4-6 и др.)
```

## Обновление

```bash
cd infra/litellm
docker compose pull && docker compose up -d
```

## Логи

```bash
docker logs litellm -f
```

## Остановка

```bash
cd infra/litellm
docker compose down
```
