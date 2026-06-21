# SETUP-DEV.md — Настройка Claude Code для локальной модели

Этот гайд — для разработчика.
Предполагается, что LiteLLM уже развёрнут на сервере (см. `SETUP-LOCAL.md`).

## Что происходит

Ты настраиваешь Claude Code так, чтобы он отправлял запросы не в Anthropic,
а на внутренний прокси LiteLLM. Тот перенаправляет их на Qwen3-30B через vLLM.
Workflow (скилы, `/architect`, `/dev`, `/close`, `/commit`) работает без изменений.

## Настройка

### 1. Получи `LITELLM_MASTER_KEY`

Попроси у DevOps/администратора сервера внутренний ключ команды.
Он выглядит как `sk-internal-...`.

### 2. Добавь переменные окружения

В `~/.bashrc` или `~/.zshrc`:

```bash
export ANTHROPIC_BASE_URL=http://litellm.ml.bank.local:4000
export ANTHROPIC_API_KEY=sk-internal-ваш-ключ
```

Перезапусти терминал или выполни:

```bash
source ~/.bashrc   # или source ~/.zshrc
```

### 3. Проверь

```bash
claude --version
claude -p "ответь одним словом: привет"
```

Если ответ пришёл — всё работает.

## Откат (вернуться к Anthropic)

Удали обе переменные из `~/.bashrc` / `~/.zshrc` и перезапусти терминал.
Или временно для текущей сессии:

```bash
unset ANTHROPIC_BASE_URL
unset ANTHROPIC_API_KEY
export ANTHROPIC_API_KEY=ваш-настоящий-ключ
```

## Известные ограничения

- Extended thinking (`/think`) не поддерживается Qwen3 — команда не упадёт, параметр просто игнорируется
- Качество ответов может отличаться от Claude — особенно на сложных архитектурных задачах
- Если модель ведёт себя непредсказуемо — сообщи в команду, скорректируем скилы
