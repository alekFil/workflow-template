---
title: "Подсказка окружения Python: uv"
status: next
priority: 11
created: 2026-11-27
---

# Подсказка окружения Python: uv

На Ubuntu без пакета `python3.12-venv` команда `python3 -m venv .venv` падает:
нет `ensurepip`. Для установки пакета нужен `sudo`. `uv venv` создает окружение без
`sudo`.

Нужно: пример `{RUNTIME_SETUP}` в `template/WORKFLOW.md` и подсказки для
Python-проектов предлагают `uv venv` и `uv pip install`.
