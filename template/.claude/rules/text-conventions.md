# text-conventions

Two mechanical rules for all text in the repository: prose in `.md` files, code
comments, commit messages, docstrings, user-facing strings and replies in chat.

- The letter «ё» is not used in Russian text: «еще», «все», «берет».
- En dash (–, U+2013) only, never em dash (—, U+2014). This file is the only place
  in the repository that quotes the forbidden character.

The dash rule exists because the two characters are visually close and mixing them
makes the docs look accidentally inconsistent. There is never a case where an em
dash is correct here.

## Anti-pattern

Any occurrence of `—` outside a code block that reproduces external output verbatim.
Model-generated prose is the usual source: em dash is the default in generated text,
so every newly written paragraph is a candidate.

## Good pattern

`–` in every position where a dash separates clauses or introduces an explanation.
A plain hyphen `-` stays a hyphen: compound words, list markers, CLI flags.

## Judgment notes

- Do not touch dashes inside quoted external output, sample payloads, or fixture
  data reproduced verbatim – changing those changes the data.
- Text imported from another repository is converted on import (em dash → en dash).
  Data files are never touched.
- Do not convert hyphens to en dashes. The rule is one-directional: em dash out,
  nothing else in.
- Check the whole hunk, not just the changed line – an em dash in surrounding
  context of an edited file is worth flagging while the file is open.
