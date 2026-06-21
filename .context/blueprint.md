# analytics-workflow-template — Blueprint

> Живой технический референс. Отражает фактическую реализацию analytics-ветки.
> Обновляется командой `/sync`.

---

## 1. Обзор

`analytics-workflow-template` — шаблонный репозиторий рабочего процесса для аналитических проектов
на Claude Code. Постоянная параллельная ветка (`analytics`) репозитория `workflow-template`.

Ключевое отличие от `workflow-template` (ветка `main`):

| Аспект | `main` (разработка) | `analytics` (аналитика) |
| --- | --- | --- |
| Артефакт задачи | Код + тесты | Ноутбук + запись в `findings.md` |
| Главный риск | Документация расходится с кодом | Вывод перестаёт подтверждаться на новых данных |
| Синхронизирующий скилл | `cc-architect-sync` | `cc-finding-sync` |
| Модель ветвления | `main`/`dev`/`feature/*` | `main`/`experiment/*` |
| Выход для стейкхолдера | Деплой | Отчёт / презентация |

**Ключевые принципы:**

- Два независимых слоя в одном репо: мейнтейнерский и шаблонный (ADR-001)
- Ветки `main` и `analytics` никогда не сливаются — два независимых продукта (ADR-021)
- В аналитике вывод может оказаться неверным на новых данных — это нормально, для этого есть
  `findings.md` со статусами и скилл `cc-finding-sync`

---

## 2. Ключевые решения

| ADR | Суть |
| --- | --- |
| ADR-021 | `analytics` — постоянная параллельная ветка, никогда не мержится в `main` |
| ADR-022 | Упрощённая модель ветвления в шаблоне: `main` + `experiment/*`, без `dev` |
| ADR-023 | Три выходных скилла: `/report` (MD), `/present jupyter`, `/present html` |

Полная история решений (ADR-001–020) — унаследована от `workflow-template/main`.

---

## 3. Компоненты

### 3.1 Мейнтейнерский слой (корень)

- `CLAUDE.md` — инструкции CC для работы с этим репо; идентифицирует ветку как analytics-variant
- `CONTRIBUTION.md` — руководство мейнтейнера; правила синхронизации analytics-скиллов
- `SETUP.md` — инструкция по развёртыванию (Python/uv, аналитика-специфичные шаги)
- `.claude/index.md` — навигатор CC для мейнтейнерского контекста
- `.claude/commands/` — слэш-команды мейнтейнера
- `.claude/skills/meta/` — мета-скиллы мейнтейнера (общие; analytics-специфичные только в template)
- `.context/` — рабочая документация мейнтейнера
- `scripts/install.sh` — curl-установка аналитического шаблона
- `scripts/uninstall.sh` — удаление ассистента из проекта

### 3.2 Шаблонный слой (`template/`)

Разворачивается в корень нового аналитического проекта при инициализации.

Отличия от шаблона `main`-ветки:

- `template/.context/` добавлены: `methodology.md`, `findings.md` — центральные для аналитики
- `template/data/README.md` — провенанс данных (сами данные не в git)
- `template/notebooks/` — директория ноутбуков с конвенциями именования
- `template/src/analysis_utils.py` — готовые к использованию статистические функции
- `template/outputs/` — экспортированные отчёты и презентации
- `template/pyproject.toml` — Python/uv окружение
- Analytics-скиллы в `template/.claude/skills/meta/`:
  `cc-record-finding`, `cc-finding-sync`, `cc-report`, `cc-present`

### 3.3 Инициализация нового проекта

`scripts/install.sh` — адаптирован под аналитику (Python/uv next steps, data/.gitignore).

---

## 4. Потоки использования

### 4.1 Развёртывание нового аналитического проекта

```text
mkdir my-analysis && cd my-analysis
git init
curl -fsSL .../analytics/scripts/install.sh | bash
→ uv sync → jupyter lab → CC fills placeholders
```

### 4.2 Мейнтейнинг шаблона

```text
сессия CC в analytics-ветке
→ `/next` → `/architect` → `/dev` → `/commit`
(без /close — analytics не мержится в main)
```

### 4.3 Синхронизация из рабочих проектов

```text
рабочий аналитический проект → улучшение скилла
→ сессия в analytics-ветке → перенести вручную → `/commit`
```

---

## 5. Зависимости между компонентами

```text
CLAUDE.md ← .claude/commands/ (слэш-команды)
CLAUDE.md ← .claude/index.md (навигация)
template/CLAUDE.md ← template/.claude/commands/
template/CLAUDE.md ← template/.claude/skills/meta/
scripts/install.sh → template/ (скачивает analytics-ветку; подставляет плейсхолдеры)
scripts/uninstall.sh → .claude/, .context/, findings.md, methodology.md, data/, notebooks/, src/, outputs/
```

---

## 6. Что реализовано

- Ветка `analytics` создана от `main` (ADR-021)
- Мейнтейнерский слой адаптирован: CLAUDE.md, CONTRIBUTION.md, SETUP.md, .context/, .claude/index.md
- Решения ADR-021/022/023 зафиксированы

## 7. Что не реализовано (Tasks 2–6)

- `template/CLAUDE.md`, `template/WORKFLOW.md` — аналитическая адаптация (Task 2)
- `template/.context/methodology.md`, `findings.md` — новые файлы (Task 3)
- Analytics-скиллы в template (Task 4)
- `template/data/`, `notebooks/`, `src/`, `outputs/`, `pyproject.toml` (Task 5)
- `scripts/install.sh` — адаптация под аналитику (Task 6)
