## Task: Исправить install.sh — заменить ветку oss на main

### Context

После мерджа ветки `oss` в `main` и удаления `oss` скрипт `scripts/install.sh`
перестал скачивать шаблон: URL и путь внутри архива захардкожены на `oss`.

Depends on: —

### Что реализовать

1. Заменить `oss.tar.gz` на `main.tar.gz` в URL скачивания
2. Заменить `workflow-template-oss/template` на `workflow-template-main/template` в пути распаковки

### Files

Редактировать:

- `scripts/install.sh` — строки 135–136: исправить ветку с `oss` на `main`

### Constraints

- Менять только эти две строки, ничего больше

### Verification

```bash
grep "main.tar.gz\|workflow-template-main" scripts/install.sh
# ожидаемый вывод: обе строки с main

grep "oss" scripts/install.sh
# ожидаемый вывод: пусто
```

### Changes along the way

(нет)
