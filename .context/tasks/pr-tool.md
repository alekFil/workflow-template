---
title: "/close: 4 способа открыть pull request – gh, glab, push options, ссылка"
status: next
priority: 14
created: 2026-11-28
---

# /close: 4 способа открыть pull request

В `MERGE_MODE=pr` скилл `/close` знает только `gh`. Владельцы работают
по-разному: с `gh`, с `glab`, без CLI на GitLab и без CLI на GitHub. Новый ключ
`PR_TOOL` в `.claude/workflow.conf` задает способ.

| `PR_TOOL` | Хостинг | Что делает `/close` после push ветки | Повторный `/close` |
| --- | --- | --- | --- |
| `gh` | GitHub | `gh pr create --base <target> --fill` | `gh pr view --json url` |
| `glab` | GitLab | `glab mr create --target-branch <target> --fill --yes` | `glab mr view` |
| `push` | GitLab | push с `-o merge_request.create -o merge_request.target=<target>` | тот же push обновляет merge request |
| `link` | любой | показывает ссылку из вывода push или ссылку на сравнение веток | та же ссылка |

- `push` – способ владельца в GitLab-проекте, проверен на практике.
- GitHub не создает pull request из push. Без `gh` автоматически только REST
  API с токеном. Не делаем: секрет в процессе ради одного вызова. `link` –
  владелец открывает ссылку сам.
- Установщик спрашивает `PR_TOOL`, только если выбран `MERGE_MODE=pr`. Значение
  по умолчанию – по URL `origin` и установленным CLI: `github.com` → `gh` или
  `link`, `gitlab` в URL → `glab` или `push`, иначе `link`. Self-hosted GitLab
  с другим доменом владелец выбирает сам.
- Contribution-профиль: pull request в `UPSTREAM_REPO` из форка. `gh`:
  `--repo`. Для `glab` и `push` (`merge_request.target_project`) проверить, что
  merge request из форка в upstream работает.
- Оба слоя: скилл `close`, `install.sh`, `workflow.conf`, `WORKFLOW.md`.

Не проверено: `glab`, `link`, `push` из форка. Проверить до закрытия задачи
или пометить в справке как непроверенное.
