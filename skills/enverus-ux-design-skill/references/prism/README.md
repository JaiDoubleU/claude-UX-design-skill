# Prism

**Status: not yet implemented.**

This folder is a placeholder for the Prism design reference, a sibling of
[`enverus-one/`](../enverus-one/). It contains no specs, tokens or rules yet, and
[`SKILL.md`](../../SKILL.md) does not route to it, so the skill never loads anything from here.

Until it is built, use the Enverus One references for design work.

When Prism is implemented, follow the layout of `enverus-one/`: spec docs for each component or
layout, an authoritative `tokens.css`, and a routing row in `SKILL.md`. Put its evals in the repo-root
`evals/` folder, outside the skill tree, so blind eval runs cannot read the assertions.
