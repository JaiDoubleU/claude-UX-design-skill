---
name: enverus-one-token-system
description: Design token rules, architecture, and audit logic for Enverus One projects. Load when auditing token usage, reviewing component implementations, or generating token documentation in an Enverus One codebase. Enverus One is built on shadcn/ui conventions with Tailwind v4 and OKLCH color values.
---

# Enverus One Token System

Rules, architecture, and audit logic for projects built on the Enverus One design token system.
Enverus One is built on shadcn/ui conventions — CSS variable names follow the shadcn/ui token
contract; values use OKLCH format (Tailwind v4).

---

## Required Context

**Before any token-related task, read these files in order:**

1. `./tokens.css` — authoritative source for all current token names and values
2. `./token-reference.md` — usage intent, restrictions, WCAG failure flags, and Tailwind mapping
3. `./shadcn/SKILL.md` — for component installation and CLI operations (official shadcn skill — CLI commands, component search, docs)

Token values shown in `token-reference.md` are semantic guidance only. Always verify actual values against `tokens.css`.

---

## Token Architecture

Three-layer architecture:

```
@theme         →  --background (Tailwind v4 theme variable)
:root          →  Light-theme color tokens + static tokens (radius)
.dark-theme    →  Dark-theme color token overrides (applied to <html>)
```

**No CSS variable prefix** — all tokens are unprefixed (e.g., `--background`, not `--ui-background`).

**Value format:** OKLCH — `oklch(L C H)` where L = lightness 0–1, C = chroma, H = hue degrees.

```css
/* Correct — OKLCH format */
--primary: oklch(0.544 0.149 138.62);

/* Wrong — do not use HSL or hex in variable definitions */
--primary: hsl(136 39% 40%);
```

**Tailwind v4 consumption:** CSS variables are exposed to Tailwind utilities via `@theme inline`:

```css
@theme inline {
  --color-primary: var(--primary);
  --color-primary-foreground: var(--primary-foreground);
}
```

This maps `--primary` to `bg-primary`, `text-primary`, etc. Do not use the v3 `tailwind.config.js` `colors{}` pattern.

---

## Token Groups

| Group | Variables | Purpose |
|-------|-----------|---------|
| Background | `--background`, `--foreground` | Page-level surface and default text |
| Card | `--card`, `--card-foreground` | Card containers |
| Popover | `--popover`, `--popover-foreground` | Floating surfaces (dropdowns, tooltips) |
| Primary | `--primary`, `--primary-foreground` | Primary interactive elements — Enverus brand green |
| Secondary | `--secondary`, `--secondary-foreground` | Secondary interactive elements |
| Muted | `--muted`, `--muted-foreground` | Subdued backgrounds and placeholder text |
| Accent | `--accent`, `--accent-foreground` | Hover and selected states |
| Destructive | `--destructive` | Error states, delete actions (no foreground companion defined) |
| Border/Input | `--border`, `--input`, `--ring` | `--border`: structural strokes. `--input`: form control borders (`border-input`; dark-mode `bg-input/30` tint). `--ring`: focus rings |
| Radius | `--radius` | Base border-radius unit (0.625rem) |
| Sidebar | `--sidebar`, `--sidebar-foreground`, `--sidebar-primary`, `--sidebar-primary-foreground`, `--sidebar-accent`, `--sidebar-accent-foreground`, `--sidebar-border`, `--sidebar-ring` | App sidebar surface and interactive elements |
| Chart | `--chart-1` through `--chart-5` | Data visualization — greyscale lightness steps |
| Semantic Status | `--success`, `--info`, `--warning`, `--link`, `--ai` | Semantic state colors (no `-foreground` companions defined) |

---

## Core Rules

**Color**
- Components must reference semantic tokens via Tailwind utilities — never hardcoded hex or OKLCH
- Hardcoded color values in component code = token leakage → flag as **Critical**
- This covers every color property, not just backgrounds: text (`color: '#ffffff'`, `text-white`), borders, fills and strokes. A hardcoded `#ffffff` or `#000000` is **Critical** like any other hex
- Report contrast problems (WCAG 1.4.3) as a separate finding. Never downgrade the leakage finding because the value is white, black or "neutral"
- Example violation: `bg-[#4a8c3f]` instead of `bg-primary`

**Borders**
- Form controls (Input, Textarea, Select, Combobox, Checkbox, Radio Group, Toggle) use `border-input`; dividers, card and popover outlines use `border-border`
- Every checkbox and radio button uses `border-input` for its unchecked, hover, focus and disabled border (see `token-reference.md`); checked and indeterminate use `primary`, invalid uses `destructive`
- Outline buttons use `border` (`--border`) in light mode and `dark:border-input` in dark mode
- `--input` is a border color: in dark mode it may also appear as a translucent tint (`dark:bg-input/30`), never as a solid fill or text color
- Form control border using `--border`, or a hardcoded border color → flag as **Medium** (hardcoded color is **Critical**, see above)

**Foreground pairing**
- Most background tokens have a paired foreground token — always use them together
- `bg-primary` → text must use `text-primary-foreground` (never `text-foreground`)
- Text on `--destructive` uses `--destructive-foreground` (white in light mode, near-black in dark mode) — never `--foreground` or `--background`
- Mismatched foreground = potential contrast failure → flag as **High**

**Dark mode**
- Dark theme is applied via `.dark-theme` class on `<html>` — never assume hardcoded values
- Components must not use arbitrary `dark:` values where a semantic token exists
- `dark:bg-gray-900` instead of `dark:bg-background` → flag as **High**

**Root font size**
- The `html` element sets `font-size: 14px` in every Enverus One page, prototype and demo: `html { font-size: 14px; }` in the app's global CSS (for a standalone HTML prototype, in its `<style>`). Set it on `html`, not on `body` or a wrapper, because `rem` resolves against the root element.
- **Keep px true.** The specs in this skill are px values (`h-9` = 36px, `text-sm` = 14px, `px-4` = 16px, radius 10px). Tailwind's defaults are `rem`, so a 14px root would shrink them by 12.5% (`h-9` would be 31.5px). Re-base the scale in px in the app's global CSS, right after the `tokens.css` import, so every utility keeps its specified size:

```css
@theme {
  --spacing: 4px;                 /* p-4 = 16px, h-9 = 36px, size-8 = 32px */
  --text-xs: 12px;
  --text-sm: 14px;
  --text-base: 16px;
  --text-lg: 18px;
  --text-xl: 20px;
  --text-2xl: 24px;
  --text-3xl: 30px;
  --text-4xl: 36px;
}
:root { --radius: 10px; }         /* tokens.css has 0.625rem, which is 8.75px at a 14px root */
html { font-size: 14px; }
```

- Do not use raw `rem` values in components (`w-[16.5rem]`, `p-[0.5rem]`); write px. Fixed shell measurements (navbar 42px, sidebar 264px and 48px) use px, and `--sidebar-width` and `--sidebar-width-icon` are set in px.
- Missing or non-14px root font size, or specs that render at the wrong size because the scale was not re-based → flag as **Medium**

**Color scheme (scrollbars and native controls)**
- Scrollbars, form-control chrome and the overscroll canvas take their colors from the browser's `color-scheme`, not from the tokens. Without it, `.dark-theme` re-themes the page but scrollbars stay light (white). Set it with the theme, in the app's global CSS (and in a standalone HTML prototype's `<style>`):

```css
:root { color-scheme: light; }
.dark-theme { color-scheme: dark; }
```

- Set it on `:root` and `.dark-theme` (the `<html>` element), not on `body` or a wrapper. Every inner scroll region (table box, card grid, sidebar) inherits it, so one rule covers them all.
- Optional: to tint scrollbars with the tokens, add `* { scrollbar-width: thin; scrollbar-color: var(--border) transparent; }`. Safari ignores `scrollbar-color`, so `color-scheme` is still required.
- Missing `color-scheme` (white scrollbars in dark mode) → flag as **Medium**

**Radius**
- Use `--radius` as the base (0.625rem); Tailwind scales it: `rounded-sm` = `calc(var(--radius) - 4px)`, `rounded-md` = `calc(var(--radius) - 2px)`, `rounded-lg` = `var(--radius)`
- Hardcoded px border-radius in components → flag as **Medium**

**Extending the palette**
- New tokens must follow the `--[semantic-name]` convention — no primitive names (`--green-500` = wrong)
- New color tokens require both `:root` (light) and `.dark-theme` entries — omitting dark = **High**
- `--success`, `--info`, `--warning`, `--link`, and `--ai` are already defined — do not redefine them

---

## Audit Checklist: Token Health

Run when auditing an existing Enverus One component set.
Read `./token-reference.md` for known contrast risks before running contrast checks.

Report all findings using this format:

```
Framework:      Enverus One Token System
Criterion:      [Rule or checklist item]
Severity:       [Critical | High | Medium | Low]
Location:       [Component, file, or token name]
Observation:    [What was found]
Recommendation: [Specific corrective action]
```

### Checklist
- [ ] All color references use semantic tokens via Tailwind utilities — no hardcoded hex, including text colors like `#ffffff` → **Critical if found**
- [ ] Every `bg-[token]` is paired with the correct `text-[token]-foreground` → **High if mismatched**
- [ ] Text on `--destructive` uses `--destructive-foreground` → **High if mismatched**
- [ ] Dark mode uses `.dark-theme` class tokens — no arbitrary `dark:bg-gray-*` where semantic token exists → **High**
- [ ] Form control borders use `border-input` (not `border-border`) → **Medium if found**
- [ ] Every checkbox and radio button uses `border-input` for its unchecked border (not `border-border`, `border-foreground`, a palette color or a hex value) → **Medium if found**
- [ ] Border-radius uses Tailwind `rounded-*` utilities (not hardcoded px) → **Medium if found**
- [ ] `:root` sets `color-scheme: light` and `.dark-theme` sets `color-scheme: dark` (dark-mode scrollbars are not white) → **Medium if missing**
- [ ] `html` sets `font-size: 14px` (not `body`, not omitted) and the Tailwind spacing, type and radius scale is re-based in px (`--spacing: 4px`, `--text-sm: 14px`, `--radius: 10px`) → **Medium if missing**
- [ ] New custom tokens have both `:root` and `.dark-theme` definitions → **High if dark missing**
- [ ] Token names are semantic — no primitive names in CSS variables
- [ ] Chart colors used only for data visualization — not repurposed for UI states
- [ ] `--ring` / `--sidebar-ring` used for focus indicators on respective surfaces — not overridden
- [ ] Semantic status tokens (`--success`, `--info`, `--warning`, `--link`, `--ai`) used for their named purpose only

---

## Common Token Smells

| Smell | What it looks like | Fix |
|-------|-------------------|-----|
| Hardcoded color | `bg-[#4a8c3f]` | Replace with `bg-primary` or define a new semantic token |
| Foreground mismatch | `bg-primary text-foreground` | Change text to `text-primary-foreground` |
| Arbitrary dark value | `dark:bg-gray-900` | Replace with `dark:bg-background` or `dark:bg-card` |
| Primitive token name | `--green-interactive: ...` | Rename to semantic intent: `--primary` or `--accent` |
| Missing dark entry | New `--brand-highlight` with no `.dark-theme` override | Add `.dark-theme` value |
| Chart color reuse | `--chart-1` used for button primary | Use `--primary`; define a new semantic token if needed |
| Missing sidebar token | Sidebar uses `--background` instead of `--sidebar` | Switch to sidebar-scoped token |

---

## Token Documentation Template

Use when documenting new token groups or extensions to the base palette.

```markdown
## Token Group: [name]

### Purpose
What design decision does this token group encode?

### Tokens
Read current values from `tokens.css`.

| Token | Light value | Dark value | Used for | Do NOT use for |
|-------|-------------|------------|----------|----------------|
| --[token] | oklch(...) | oklch(...) | ... | ... |

### Tailwind config entry
[Show the @theme inline {} entry that exposes this token to Tailwind utilities]

### WCAG notes
[Contrast ratios, threshold risks, known failures]
```

---

*Document Type: Claude Code Skill — Token System*
*Status: Active*
*Version: 2.0*
*System: Enverus One (built on shadcn/ui conventions, Tailwind v4, OKLCH)*
*Paired with: `token-reference.md` (semantic layer), `tokens.css` (values)*
