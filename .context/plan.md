## Task: Add retry logic to install.sh download step

### Context

`scripts/install.sh` downloads the template archive from GitHub via `curl | tar`.
If GitHub returns a transient 5xx error, tar receives a broken stream and exits with
a cryptic «unexpected end of file» message instead of a readable download error.

Depends on: —

### What to implement

1. Extract the download into a manual retry loop (3 attempts, 5 s delay)
2. Download to a temp file (`mktemp`) instead of piping directly to `tar`
3. On all retries exhausted — print a clear error and exit 1
4. After successful download — run `tar` on the temp file, then remove it
5. Trap `EXIT` to ensure temp file is cleaned up even on unexpected exit

### Files

Edit:

- `scripts/install.sh` — replace lines 134–136 (echo + curl | tar) with retry block

### Constraints

- Do not use `--retry-all-errors` (requires curl ≥ 7.71) — compatibility via shell loop
- Keep `curl -fsSL` flags (fail on HTTP error, silent, follow redirects)
- Do not change any logic outside the download block
- Follow existing code style: same variable naming, same color echo pattern

### Verification

```bash
# Smoke-test: confirm the retry block is present
grep -c "attempt" scripts/install.sh
# expected: ≥ 2

# Syntax check
bash -n scripts/install.sh
# expected: no output, exit 0
```

### Changes along the way

(none)
