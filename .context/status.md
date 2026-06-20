# Статус реализации workflow-template

Дата: 2026-06-20 12:00 (ветка `oss`)

---

## Что реализовано

**Мейнтейнерский слой (на русском, ключевые фразы):**

- `CLAUDE.md` — инструкции CC: роли, ключевые фразы, конвенции (ADR-008, ADR-009)
- `CONTRIBUTION.md` — руководство мейнтейнера (ADR-009)
- `SETUP.md` — инструкция по развёртыванию на английском; curl и клон; раздел «Удаление» (ADR-013, ADR-014)
- `README.md` — описание репо для GitHub на английском (ADR-014)
- `.gitignore` — добавлены `.claude/settings.local.json`, `.claude/chat_history/`, `.env`, `.context/notes/*.md`
- `.markdownlint.json` — конфигурация проверки Markdown (только мейнтейнерский слой)
- `.claude/index.md` — навигатор CC (русский, ключевые фразы)
- `.claude/skills/meta/` — четыре мета-скилла на русском: cc-commit, cc-close-task, cc-status-report, cc-architect-sync
- `.context/blueprint.md`, `.context/plan.md`, `.context/to-do.md`, `.context/decisions.md` — заполнены, на русском
- `.context/discussions/` — три обсуждения: curl-установка, mini-версия, локальный LLM-агент
- `.context/notes/` — личные заметки владельца (исключены из git, ADR-011)
- `scripts/install.sh` — curl-установка на английском: tar.gz, плейсхолдеры, .gitignore с маркером, видимость ассистента, опциональные коммит и dev-ветка (ADR-005, ADR-007, ADR-012, ADR-013, ADR-014)
- `scripts/uninstall.sh` — удаление ассистента на английском: перечисляет файлы, очищает .gitignore и .git/info/exclude (ADR-013, ADR-014)

**Шаблонный слой (`template/`) — переведён на английский, слэш-команды (ADR-014, ADR-015, ADR-016):**

- `template/CLAUDE.md` — на английском; слэш-команды `/organize`, `/architect`, `/next`, `/record`, `/dev`, `/close`, `/status`, `/sync`, `/commit`; инструкция «Respond in the user's language»
- `template/WORKFLOW.md` — шпаргалка рабочего процесса на английском
- `template/.gitignore` — базовый .gitignore для нового проекта
- `template/.claude/index.md` — навигатор CC на английском
- `template/.claude/skills/meta/` — четыре мета-скилла на английском (cc-commit, cc-close-task, cc-status-report, cc-architect-sync)
- `template/.context/blueprint.md`, `plan.md`, `to-do.md`, `status.md`, `decisions.md` — на английском, с плейсхолдерами
- `template/.context/notes/` — пустая директория (`.gitkeep`; `.gitignore` исключает `*.md`, ADR-011)
- `template/.markdownlint.json` — **удалён** (ADR-015)

---

## Структура проекта

```text
workflow-template/
├── CLAUDE.md
├── CONTRIBUTION.md
├── SETUP.md
├── LICENSE
├── README.md
├── .gitignore
├── .markdownlint.json
├── .claude/
│   ├── index.md
│   ├── settings.local.json       ← в .gitignore
│   └── skills/meta/
│       ├── cc-commit.md
│       ├── cc-close-task.md
│       ├── cc-status-report.md
│       └── cc-architect-sync.md
├── .context/
│   ├── blueprint.md
│   ├── plan.md
│   ├── to-do.md
│   ├── status.md
│   ├── decisions.md
│   ├── history/         (008 архивов)
│   ├── discussions/     (3 обсуждения)
│   └── notes/           ← в .gitignore
├── scripts/
│   ├── install.sh
│   └── uninstall.sh
└── template/
    ├── CLAUDE.md
    ├── WORKFLOW.md
    ├── .gitignore
    ├── .claude/
    │   ├── index.md
    │   └── skills/meta/ (4 скилла на английском)
    └── .context/
        ├── blueprint.md
        ├── plan.md
        ├── to-do.md
        ├── status.md
        ├── decisions.md
        ├── history/
        ├── discussions/
        └── notes/
```

---

## Ключевые технические решения

- **ADR-001**: Два слоя — мейнтейнерский (корень) и шаблонный (`template/`)
- **ADR-002**: `index.md` в `.claude/`, не в `docs/`
- **ADR-003**: Cookiecutter — Отклонено, заменено ADR-014
- **ADR-004**: Аудит `decisions.md` встроен в `cc-architect-sync`, не отдельным скиллом
- **ADR-005**: `install.sh` для curl-установки
- **ADR-006**: `docs/` переименована в `.context/` в обоих слоях
- **ADR-007**: `scripts/init-project.sh` удалён; `install.sh` — единственный способ установки
- **ADR-008**: Раздел «Управление контекстом» удалён из обоих `CLAUDE.md`
- **ADR-009**: Предпубликационный аудит — 6 исправлений
- **ADR-010**: Отказ от `template-mini`
- **ADR-011**: `.context/notes/` — личные заметки, исключены из git в обоих слоях
- **ADR-012**: `install.sh` — безопасный `.gitignore`, управление видимостью ассистента
- **ADR-013**: `install.sh` — опциональные коммит и dev-ветка; `uninstall.sh`; `SETUP.md` — раздел «Удаление»
- **ADR-014**: OSS-публикация — перевод шаблонного слоя и публичных файлов на английский
- **ADR-015**: Удалён `template/.markdownlint.json` из шаблонного слоя
- **ADR-016**: Ветка `oss`; «Respond in the user's language»; слэш-команды в шаблоне реализованы вместе с переводом

---

## Зависимости между компонентами

```text
CLAUDE.md ← .claude/skills/meta/ (ключевые фразы → скиллы)
CLAUDE.md ← .claude/index.md (навигация)
template/CLAUDE.md ← template/.claude/skills/meta/ (слэш-команды)
template/CLAUDE.md ← template/.claude/index.md
scripts/install.sh → template/ (скачивает как tar.gz; единственный способ для пользователей)
scripts/uninstall.sh → .claude/, .context/, CLAUDE.md, WORKFLOW.md, .gitignore, .git/info/exclude
```

---

## Что не реализовано из запланированного

- **Мейнтейнерский слой — слэш-команды** (Приоритет 0): `CLAUDE.md`, `.claude/index.md`, `.claude/skills/meta/*.md`, `CONTRIBUTION.md` на мейнтейнерском слое всё ещё используют ключевые фразы вместо слэш-команд
- **Демо** (Приоритет 1): снять скринкаст одной сессии от `/architect` до `/commit` — не начато
- **README** (Приоритет 1): переписать с позиции нового пользователя, объяснить двухслойную структуру — не начато
- **Управление decisions.md (ADR-004)** (Приоритет 2): `cc-architect-sync` не расширен, история ADR не архивируется
- **Полнота шаблона** (Приоритет 3): нет `.claudeignore` в `template/`, нет `template/.claude/skills/project/`
- **Тест install.sh end-to-end**: технический долг, не начато

---

## Вопросы и неопределённости

- Мейнтейнерский слой — обновлять ли на слэш-команды? Слой остаётся внутренним (русский, ключевые фразы работают), но ADR-016 зафиксировал имена команд. Решение не принято.
- Демо: формат (GIF / скринкаст / ASCII), инструмент записи — не выбраны
- `uninstall.sh` доступен через curl, но URL для `curl | bash` в `SETUP.md` не проверен — нужен тест
- Обсуждение 2026-06-18: идея локального LLM-агента (Pydantic AI + vLLM + Qwen3-30B) как альтернативы CC — где будет жить, не решено
