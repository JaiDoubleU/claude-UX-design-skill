# Enverus UX Design Skill

Structured UX design guidance for Enverus One — covering design audits, component spec writing, token system audits, and user flow documentation. Grounded in Nielsen's 10 Heuristics, WCAG 2.2 AA, and Atomic Design methodology.

## What it does

| Task | What you get |
|------|-------------|
| **Design audit** | Severity-ranked findings (Critical → Low) mapped to specific heuristics and WCAG criteria, with a prioritized action list |
| **Component spec** | Full handoff spec — states, variants, spacing tokens, accessibility requirements, do/don't examples |
| **Token audit** | Token leakage detection, dark mode compliance, and naming convention checks |
| **User flow & IA** | Structured flow docs with entry points, decision branches, error states, and heuristic/accessibility checklists |

## Token system

Specific to the **Enverus One** design system (shadcn/ui + Tailwind v4, unprefixed tokens, OKLCH values). Support can be added for other design systems by adding them under references.

## Example prompts

- "Audit this screen for WCAG and heuristic issues."
- "Write a component spec for a primary button."
- "Audit this Enverus One component for token leakage and dark mode issues."
- "Map the password reset flow with error states and edge cases."
- "How do I add a new semantic token to the Enverus One system?"

## How the skill works

When invoked, the agent reads the reference files listed in `SKILL.md` based on the task type — audits load `figma-audit.md`, token work loads `token-system.md` and `tokens.css`, and so on. Files are read on-demand, not pre-loaded automatically.
