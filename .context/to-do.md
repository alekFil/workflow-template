# To-Do: workflow-template

> Обновляется командой "синхронизируем" после каждой реализации.
> Цель: зрелый шаблон рабочего процесса с CC, готовый к развёртыванию за 5 минут.

---

## В работе

(нет активных задач)

## Следующее

### Приоритет 1: OSS-публикация (ADR-014) — закрыт

Все части реализованы: удаление `template/.markdownlint.json`, перевод всех слоёв на английский, слэш-команды в обоих слоях (ADR-015, ADR-016 archived, ADR-017, ADR-018), **README полный rewrite** (закрыт 2026-08-31, commit 19d42b9). Демо — в «После MVP» (не блокирует публикацию).

### Приоритет 2: Управление decisions.md

- [x] Расширить `cc-architect-sync.md`: добавить шаг проверки ADR со статусом "Заменено" и предложения архивировать в `.context/history/decisions/` (ADR-026, реализовано в рамках дисциплины ADR)
- [x] То же для `template/.claude/skills/meta/cc-architect-sync.md` (ADR-026)
- [x] Создать `.context/history/decisions/` — теперь директория с реальным содержимым (ADR-026)
- [ ] Тест: проверить что развёртывание через install.sh работает end-to-end

### Приоритет 3: Полнота шаблона

- [x] Добавить `.claudeignore` в `template/` (исключить `.context/history/` из контекста CC) — отпало (ADR-027: status-архив удалён; в `history/` остаётся только `decisions/`, его CC должен читать)
- [x] Добавить `template/.claude/skills/project/` — каталог для проектных скиллов (ADR-023: `rules/` с README и примером)
- [ ] Проверить что `template/.gitignore` корректно разворачивается через `install.sh`

### Приоритет 4: Дисциплина команд — устранить `/dev` → авто-commit

- [x] Уточнить в `.claude/commands/dev.md` (оба слоя): по завершении — только отчёт (замещено ADR-031 в рамках Skill boundaries)
- [x] Проверить симметрично `.claude/commands/architect.md` и другие команды на зоны сползания (замещено ADR-031, ревизия провела: единственное явное нарушение — dev.md; `cc-code-polish.md` уже реализует правило)

### Приоритет 5: Hook-based enforcement (Уровень 1 + Уровень 3)

Идея: перейти от soft-enforcement (правило в тексте скилла + дисциплина модели) к hard-enforcement через CC hooks для критичных инвариантов. `skill boundaries` (ADR-031) целиком автоматизировать не получается — hooks не знают «в каком скилле мы сейчас», — но state-based инварианты и запреты грубых действий закрываются чисто.

**Порядок работы важен: сначала документировать модель, потом реализовывать.**

- [ ] **Документировать модель enforcement:** какие правила подлежат hard-hook (state-инварианты + грубые действия), какие остаются soft (текст скилла + дисциплина), критерии отнесения. Возможно — новый ADR или раздел в CLAUDE.md.
- [ ] **Реализовать Уровень 1 (инвариант-хуки):**
  - `PostToolUse` на `git commit`: блок, если на `main`/`dev` в diff есть `.context/plan.md` (нарушение ADR-030)
  - `Stop` hook: warn, если `.context/plan.md` untracked/modified на feature-ветке (напоминание ADR-032)
- [ ] **Реализовать Уровень 3 (hard-block опасных действий):**
  - `PreToolUse` matcher на `Bash git push` → deny
  - `PreToolUse` matcher на `Bash git commit` при branch=`main`/`dev` → deny
  - `PreToolUse` matcher на `git commit --amend`, `git rebase -i`, `git reset --hard` → deny
  - `PreToolUse` matcher на Write/Edit `.context/plan.md` при branch=`main`/`dev` → deny
- [ ] **Синхронизация в шаблонный слой:** `template/.claude/settings.json` с теми же hooks (плейсхолдерная структура при необходимости).
- [ ] **Уровень 2 (prompt-injection reminders) — отложить как experiment** после того как Уровень 1+3 в деле.

---

## Готово

- [x] Репозиторий создан
- [x] Рабочий процесс с Claude Code настроен
- [x] Разделение мейнтейнерского и шаблонного слоёв (ADR-001)
- [x] Перенос `index.md` из `docs/` в `.claude/` (ADR-002)
- [x] Создана структура `template/` со всеми шаблонными файлами
- [x] Мейнтейнерская документация заполнена реальным содержимым
- [x] Реализован `scripts/init-project.sh` (минимальная версия)
- [x] Добавлен `scripts/install.sh` — curl-установка для пользователей (ADR-005)
- [x] Добавлен `.markdownlint.json` (мейнтейнерский и шаблонный слои)
- [x] Упрощены ключевые фразы активации Архитектора (`обсудим задачу` → `обсудим`)
- [x] Удалён `scripts/init-project.sh`, SETUP.md обновлён (ADR-007)
- [x] Переименована `docs/` → `.context/` в обоих слоях, ссылки обновлены (ADR-006)
- [x] Предпубликационный аудит: `cc-export-chat` удалён, `.gitignore` дополнен, `install.sh` создаёт `dev`-ветку (ADR-009)
- [x] `template-mini` отклонён — поддерживать два параллельных шаблона нецелесообразно (ADR-010)
- [x] Cookiecutter отклонён — продукт workflow-слой, не project starter (ADR-003 → ADR-014)
- [x] `.context/notes/` исключена из git в обоих слоях, описана в WORKFLOW.md (ADR-011)
- [x] Явная языковая настройка: 3 плейсхолдера в `template/CLAUDE.md`, вопрос [one/multi] в `install.sh`, Language-секция в обоих `CLAUDE.md` (ADR-020)
- [x] Команда `/polish` — пайплайн вычистки сгенерированного кода в обоих слоях (ADR-023)
- [x] Режим `/polish --all` — полный прогон по проекту, project-rules only, `.polishignore` опционально; наполнены мейнтейнерские правила `markdown-conventions` и `no-placeholder-leaks` (ADR-024)
- [x] Дисциплина ADR — двухуровневая модель, чек-лист, архивация; переклассификация 25 существующих ADR; синхронизировано в шаблонный слой (ADR-026)
- [x] Убрать file-архив status.md — перезапись + git-указатель; удалены 14 архивных файлов; `/report` упрощён в обоих слоях (ADR-027)
- [x] Разделить логическую карту (CLAUDE.md → «Components») и физическое дерево (status.md); плейсхолдер `{PROJECT_STRUCTURE}` → `{PROJECT_LAYOUT}` (ADR-028)
- [x] Three-way split артефактов: notes (private, AI-user) / discussions (team) / history/retros (archived retros); 4 AI-файла перенесены в notes/, retro — в history/retros/2026-06-21.md; `/retro` обновлён (ADR-029)
- [x] `plan.md` как task-local: жизненный цикл (создаётся `/architect`, удаляется `/close`), классификация артефактов по scope (project-wide / task-local / private) в CLAUDE.md обоих слоёв (ADR-030)
- [x] Skill boundaries: команда не исполняет соседний скилл автоматически; секция в CLAUDE.md обоих слоёв, усиленный запрет в dev.md (ADR-031)
- [x] Commit plan.md после /architect: two-point defense — подсказка в /architect + untracked-check в /commit (ADR-032)
- [x] Переписать `README.md`: двухслойность, установка через template/, ключевые концепции, entry-point для нового пользователя — P1 blocker OSS-публикации закрыт

---

## После MVP (технический долг)

- [ ] Тест: проверить curl-команду для uninstall.sh в SETUP.md
- [ ] Changelog для отслеживания версий шаблона
- [ ] Снять демо: одна сессия от `/architect` до `/commit`. Формат (GIF / скринкаст / ASCII) и инструмент записи — открыты. Отложено до стабилизации модели.
