# no-dead-code

New code introduced in the diff must be reachable from an existing entry point
or from a test. If a function, class, method, or module-level constant is added
but nothing calls or imports it, flag it.

## Anti-pattern

- A new utility function added "for future use" with no current caller
- An unused import kept "just in case"
- A commented-out block left behind after refactor
- A `TODO`/`FIXME` marker with no linked issue or explanation

## Good pattern

- Every added symbol is either used by another change in the same diff, or
  imported from an existing caller
- If a symbol is a public API surface (documented as such), it counts as used
- Removed code is deleted outright, not commented out

## Judgment notes

- Test helpers are used if any test imports them
- Framework hooks (route handlers, event listeners, plugin entry points) count
  as used when the framework registers them, even without explicit import
- If in doubt whether something is a public API — ask the owner before flagging
