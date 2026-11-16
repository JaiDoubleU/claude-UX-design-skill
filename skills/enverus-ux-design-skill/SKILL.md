---
name: enverus-ux-design-skill
description: >
  Expert UX design skill for the Enverus One design system (shadcn/ui + Tailwind, unprefixed
  tokens). Covers Figma audits, component spec writing, variable/token systems, and user flow &
  IA design, plus building Enverus One pages and UI. Follows Nielsen's 10 Heuristics, WCAG
  accessibility standards, and Atomic Design methodology. Use this skill whenever the user
  mentions: design reviews, Figma audits, component specs, design tokens, variables, user flows,
  IA, information architecture, accessibility checks, UX critique, design systems, building or
  laying out an Enverus One page (page header, page layout, app shell), the sidebar or left
  navigation, the top navbar or top navigation, the Enverus wordmark or logo, the light/dark
  theme toggle, Lucide icons or choosing an icon, shadcn/ui components, the trace component, UI
  construction or interface building, or any request to evaluate, document, or structure UI/UX
  work, even if they don't use the word "UX" explicitly.
---

# UX Design Skill

A comprehensive skill for UX design work across four domains: Figma audits, component spec
writing, variable/token systems, and user flow & IA design. All work is grounded in Nielsen's
10 Heuristics, WCAG 2.2 AA accessibility.

Specific to the **Enverus One** design system — built on shadcn/ui + Tailwind CSS with
unprefixed CSS custom properties and `.dark-theme` on `<html>` for dark mode.

---

## Reference Files

Load the relevant reference file(s) based on the task:

| Task | Load |
|------|------|
| Figma audit or design review | `references/figma-audit.md` |
| Component spec writing | `references/component-specs.md` |
| User flow or IA design | `references/user-flow-ia.md` |
| Token/variable work — Enverus One | `references/enverus-one/token-system.md` |
| Token usage intent & WCAG flags — Enverus One | `references/enverus-one/token-reference.md` |
| Enverus One component work (shadcn/ui CLI) | `references/enverus-one/shadcn/SKILL.md` |
| Building or laying out an Enverus One page, page header or full page (a page always includes the top navbar and the sidebar) | `references/enverus-one/rules/page-layout.md` (start here), then `references/enverus-one/page-header.md`, `references/enverus-one/navbar.md` and `references/enverus-one/sidebar.md` |
| Sidebar only / primary navigation — Enverus One | `references/enverus-one/sidebar.md` |
| Top navbar only (wordmark, theme toggle, avatar) — Enverus One | `references/enverus-one/navbar.md` |
| List of records as a table or cards (toolbar with search, filters, columns/sort, view toggle; pagination) — Enverus One | `references/enverus-one/list-layout.md` |
| Choosing or validating an icon — Enverus One | `references/enverus-one/lucide-icons.md` (search it for a name; do not read it whole) |
| Trace component (tool calls, reasoning, sources, plans) — Enverus One | `references/enverus-one/components/trace.md` and `references/enverus-one/components/trace.tsx` |
| Show the user a visual preview of the tokens (not needed to build) | `references/token-preview.html` |

Always load `references/frameworks.md` first if the task spans multiple domains or
requires grounding in heuristics, WCAG, or Atomic Design before proceeding.

---

## Token System

All token work uses the **Enverus One** system:
- CSS variables without prefix: `--background`, `--primary`, `--muted-foreground`
- Dark mode via `.dark-theme` class on `<html>`
- Component imports from `@/components/ui/*` or `env-one.ui`
- Tailwind v4 with `colors: { primary: "hsl(var(--primary))" }` pattern
- Values expressed in OKLCH format
- `:root { color-scheme: light }` and `.dark-theme { color-scheme: dark }` on every page so dark-mode scrollbars are not white (see `references/enverus-one/token-system.md`, Color scheme)
- `html { font-size: 14px }` on every page, prototype and demo, with Tailwind's spacing, type and radius scale re-based in px so specs keep their intended sizes (see `references/enverus-one/token-system.md`, Root font size)

### Token reference files

| Purpose | File |
|---------|------|
| Token architecture, naming rules, audit checklist | `references/enverus-one/token-system.md` |
| Semantic usage intent and WCAG contrast notes | `references/enverus-one/token-reference.md` |
| Authoritative CSS variable values | `references/enverus-one/tokens.css` |

---

## Core Principles

**Always apply across all UX work:**

1. **Accessibility first** — WCAG 2.2 AA is the floor, not the ceiling
2. **Heuristics as a lens** — Nielsen's 10 provide the evaluation vocabulary
3. **Atomic thinking** — Every element belongs to a layer: atom → molecule → organism → template → page
4. **Clarity over cleverness** — Prefer the obvious pattern over the novel one
5. **Name things consistently** — Naming is design; inconsistent naming is a UX bug

---

## Output Standards

### For Audits
- Lead with a severity-ranked findings list (Critical / High / Medium / Low)
- Map each finding to a specific heuristic or WCAG criterion
- Include a "What good looks like" note for each finding
- Close with a prioritized action list (this week / this sprint / backlog)

### For Component Specs
- Use the standard spec template in `references/component-specs.md`
- Always include: states, variants, spacing tokens, accessibility requirements, do/don't examples
- Name components in Atomic Design layer notation (e.g., `atom/button-primary`)

### For Token/Variable Work
- Read `references/enverus-one/token-system.md` before any token task
- Follow the naming convention documented in `token-system.md`
- Always document: value, alias, usage context, and do-not-use cases
- Flag any token that lacks a semantic alias (raw values in components = a bug)

### For Icons — Enverus One
- Enverus One uses the Lucide icon library (`lucide-react`). Import icons from it; do not use another icon set or hand-drawn SVGs for UI icons
- Use the Lucide icon that matches the meaning (for example `Workflow` for Flows, `CircleQuestionMark` for help)
- Only use icon names that exist: check `references/enverus-one/lucide-icons.md`, which lists every valid name, before importing one
- Size icons as `lucide-icons.md` says: no size classes inside shadcn components (the component sets 16px), `size-4` for standalone icons, and no `data-icon`

### For User Flows & IA
- Document flows with: entry point → decision nodes → outcomes → error states
- Apply the IA principles from `references/user-flow-ia.md`
- Always note where the flow breaks WCAG or heuristic expectations

---

## Usage Confirmation

When this skill is used to build or change elements on a page (components, layouts, prototypes or artifacts), start the reply with one line in italics that names the skill and the reference files actually opened in this chat, for example (paths are relative to `references/`):

*Enverus UX skill applied: enverus-one/page-header.md, enverus-one/navbar.md, enverus-one/sidebar.md, enverus-one/shadcn/rules/forms.md*

Rules for the note:
- List only files you opened with a view or read tool in this chat. Do not list files you only expect to need.
- If no reference file was opened, write: *Enverus UX skill applied: no reference files opened.*
- Put the note once, at the top of the reply that builds the elements. Do not repeat it in each message of a long exchange unless the references change.
- Do not add the note to replies that only discuss design without building elements.

---

## Tone & Communication Style

- Be direct and specific — vague feedback helps no one
- Use design vocabulary precisely (affordance, signifier, mental model, progressive disclosure)
- When critiquing, always pair problem + recommendation
- Quantify where possible ("3 of 7 screens violate this heuristic")
