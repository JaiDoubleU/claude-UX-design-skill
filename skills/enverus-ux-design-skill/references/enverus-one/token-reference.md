# Enverus One Token Reference

Semantic usage intent, restrictions, and WCAG contrast data for Enverus One tokens.
Enverus One is built on shadcn/ui conventions with Tailwind v4 — token names follow the
shadcn/ui contract; values are in OKLCH format.
This file is guidance only — always verify actual values against `tokens.css`.

---

## Color Token Usage
---

### Background & Foreground

| Token | Used for | Do NOT use for |
|-------|----------|----------------|
| `--background` | Page body, main content area | Component-level surfaces |
| `--foreground` | Default body text, headings | Text on colored backgrounds |
| `--card` | Card, panel, dialog surfaces | Page-level backgrounds |
| `--card-foreground` | Text inside cards | Text on `--background` |
| `--popover` | Dropdown menus, tooltips, context menus | Persistent panel surfaces |
| `--popover-foreground` | Text inside popover surfaces | Inline text |

**Pairing rule:** Always use the `-foreground` companion of whichever surface token you apply.

---

### Interactive Colors

| Token | Used for | Do NOT use for |
|-------|----------|----------------|
| `--primary` | CTA buttons, primary actions, checked states — **Enverus brand green** | Decorative accents; success feedback (use `--success`) |
| `--primary-foreground` | Text/icons on `--primary` backgrounds | Text on any other surface |
| `--secondary` | Secondary buttons, pill badges, tag backgrounds | Primary actions |
| `--secondary-foreground` | Text on `--secondary` backgrounds | Text on primary |
| `--accent` | Hover/selected state backgrounds | Default resting state |
| `--accent-foreground` | Text on `--accent` backgrounds | General body text |
| `--accent-brand-light` | Hover state for `--primary` fills (e.g. `hover:bg-accent-brand-light` on the primary button) | Resting state |

**Note on primary:** `--primary` is the Enverus brand green (`oklch(0.544 0.149 138.62)`) and is the same value in both light and dark modes. Do not confuse with `--success` — primary is for interactive actions, success is for status feedback.

> **Matches env-one.ui:** `--accent-brand-light` is the same value as env-one.ui's `--env-theme-accent-brand-light`, exposed to Tailwind as `accent-brand-light`. This is the class the real `Button` uses for its primary hover.

---

### Utility Colors

| Token | Used for | Do NOT use for |
|-------|----------|----------------|
| `--muted` | Skeleton loaders, code blocks, subdued containers | Active or interactive surfaces |
| `--muted-foreground` | Placeholder text, helper text, timestamps | Primary content text |
| `--destructive` | Error messages, delete buttons, destructive confirm dialogs | Warnings (use `--warning`) |
| `--destructive-foreground` | Text/icons on `--destructive` backgrounds | Text on any other surface |

**`--destructive-foreground`** is the label color on `--destructive` fills: white in light mode (4.76:1) and near-black in dark mode (6.84:1, because dark `--destructive` is a lighter red). Do not use `--foreground` or `--background` for this — `--foreground` in dark mode is only 2.77:1.

---

### Semantic Status Tokens

These are defined directly in the token system (not custom extensions):

| Token | Used for | Do NOT use for |
|-------|----------|----------------|
| `--success` | Success states, completed actions, positive feedback | Primary interactive actions (use `--primary`) |
| `--info` | Informational messages, neutral status alerts | Errors or warnings |
| `--warning` | Warning states, at-risk conditions, caution indicators | Errors (use `--destructive`) |
| `--link` | Hyperlink text color | Button backgrounds, decorative elements |
| `--ai` | AI-generated content indicators, AI UI elements | General branding or non-AI status |

**No `-foreground` companions defined for these tokens.** When placing text on these backgrounds, choose between `--foreground` and `--background` based on which passes contrast, and verify in both light and dark modes — dark values shift significantly.

---

### Sidebar Tokens

| Token | Used for | Do NOT use for |
|-------|----------|----------------|
| `--sidebar` | App sidebar surface background | Main content area (use `--background`) |
| `--sidebar-foreground` | Text and icons in the sidebar | Content outside the sidebar |
| `--sidebar-primary` | Primary interactive elements within the sidebar | Non-sidebar primary elements |
| `--sidebar-primary-foreground` | Text on `--sidebar-primary` backgrounds. Alias of `--primary-foreground` | Other surfaces |
| `--sidebar-accent` | Hover/selected states within the sidebar | Default sidebar resting state |
| `--sidebar-accent-foreground` | Text on `--sidebar-accent` backgrounds | General sidebar text |
| `--sidebar-border` | Sidebar dividers and outlines | Main content borders (use `--border`) |
| `--sidebar-ring` | Focus ring on interactive elements within the sidebar | Decorative outlines |

Use sidebar tokens exclusively within sidebar-scoped components — do not mix with the main token set inside the sidebar.

---

### Structural Tokens

| Token | Used for | Do NOT use for |
|-------|----------|----------------|
| `--border` | Dividers, card outlines, table row separators, outline-button border in light mode | Focus indicators; form control borders (use `--input`) |
| `--input` | Border of form controls — `border-input` on Input, Textarea, Select, Combobox, **Checkbox, Radio Group** and Toggle. In dark mode also a translucent tint on controls and outline buttons: `dark:bg-input/30` (`dark:hover:bg-input/50` on hover). Outline buttons use it for their border in dark mode only (`dark:border-input`) | Solid fills (light-mode `--input` is an opaque grey); dividers, card outlines and other structural strokes (use `--border`) |
| `--ring` | Focus-visible ring on all interactive elements (outside sidebar) | Decorative borders |

**Checkboxes and radio buttons (all of them):** every `Checkbox` and `RadioGroupItem`, in any page or component, takes its border from `--input` (`border-input`) while unchecked, on hover, when disabled and when focused (focus adds `--ring`, not a different border). Checked and indeterminate controls fill with `--primary`, so the border is `--primary` too. An invalid control (`aria-invalid`) uses `--destructive`. Never use `--border`, `--foreground`, `--muted-foreground`, a Tailwind palette color or a hex value for the border of an unchecked checkbox or radio button.

**How `--input` is applied (shadcn):** form controls take their border from `--input` (`border border-input`), with `bg-background` (or transparent) as the fill. In dark mode shadcn adds `dark:bg-input/30` so controls read slightly lighter than the surface; because dark `--input` is already a 15% white, that tint is faint. `--input` is not a text, fill or divider color.

**Accessibility note:** `--ring` is the approved focus indicator outside the sidebar; `--sidebar-ring` inside it. Never suppress either without replacing with an equivalent visible focus style — WCAG 2.4.7 / 2.4.11.

---

### Border Radius

| Token | Tailwind utility | Effective size (default `--radius: 0.625rem`) |
|-------|-----------------|----------------------------------------------|
| `--radius` | `rounded-lg` | 0.625rem (10px) |
| `calc(var(--radius) - 2px)` | `rounded-md` | 0.5rem (8px) |
| `calc(var(--radius) - 4px)` | `rounded-sm` | 0.375rem (6px) |

Theming `--radius` globally changes all three derived values. Components should use Tailwind's `rounded-*` utilities, not hardcoded values.

---

### Chart Colors

Chart colors are a **greyscale lightness scale**, not a colorful categorical series:

| Token | Light value | Dark value | Approximate shade |
|-------|------------|------------|-------------------|
| `--chart-1` | `oklch(0.87 0 0)` | `oklch(0.87 0 0)` | Light gray |
| `--chart-2` | `oklch(0.556 0 0)` | `oklch(0.556 0 0)` | Mid gray |
| `--chart-3` | `oklch(0.439 0 0)` | `oklch(0.439 0 0)` | Medium-dark gray |
| `--chart-4` | `oklch(0.371 0 0)` | `oklch(0.371 0 0)` | Dark gray |
| `--chart-5` | `oklch(0.269 0 0)` | `oklch(0.269 0 0)` | Darkest gray |

Chart colors are identical in light and dark modes. For charts requiring categorical color differentiation, supplement with custom tokens — the built-in series are greyscale steps only. Do not repurpose chart tokens for UI state indicators.

---

### Tokens Not Used by This Skill

- `--env-one-background` — defined in the env-one.ui token files (`oklch(0.931 0 0)` light, `oklch(0.235 0 0)` dark). This skill does not use it. `--background` (`oklch(0.95 0 0)` light, `oklch(20.5% 0 0)` dark) is the page background here, so do not introduce `--env-one-background` in components built from this skill.

---

## WCAG Contrast Notes

Enverus One targets WCAG 2.2 AA (4.5:1 for normal text, 3:1 for large text and UI components).

### Known passing combinations
| Foreground | Background | Notes |
|-----------|------------|-------|
| `--foreground` on `--background` | Near-black on white | High contrast — safe |
| `--card-foreground` on `--card` | Same as foreground/background pairing | Safe |
| `--secondary-foreground` on `--secondary` | Dark on light gray | Safe |
| `--primary-foreground` on `--primary` | Near-white on brand green | Green sits at medium lightness — verify 4.5:1 after any hue or lightness adjustment |

### Requires verification
| Pair | Risk |
|------|------|
| `--destructive-foreground` on `--destructive` | White on red | 4.76:1 — passes AA; verify after any change |
| `--muted-foreground` on `--background` | Mid-lightness gray on white — verify after any lightness customization |
| `--muted-foreground` on `--muted` | Mid-gray on light gray — large text only |
| `--success`, `--info`, `--warning` as backgrounds | No companion foreground — verify foreground choice in both modes |
| `--link` on `--background` | Verify hue/lightness passes 4.5:1 |
| `--input` border on `--background` | `oklch(88% 0 0)` is about 1.2:1, below the 3:1 non-text minimum (WCAG 1.4.11). Matches env-one.ui; known gap. `oklch(0.62 0 0)` or darker would pass (3.1:1) |

### Dark mode (`.dark-theme`) risks
| Pair | Risk |
|------|------|
| `--destructive-foreground` on `--destructive` (.dark-theme) | Near-black on lighter red (`oklch(0.704 0.191 22.216)`) — 6.84:1, passes AA; white would fail at 2.89:1 |
| `--muted-foreground` on `--muted` (.dark-theme) | Mid-gray on dark gray — 4.80:1 at `oklch(0.708 0 0)`; below about `oklch(0.691 0 0)` it fails AA (at `oklch(0.6 0 0)` it is 3.15:1, and also fails on `--accent`, `--secondary`, `--popover` and `--card`) |
| `--input` border (.dark-theme) | White at 15% alpha over the dark surfaces is about 1.6:1, below the 3:1 non-text minimum (WCAG 1.4.11); it would need roughly 36–40% alpha to pass. Known gap — not changed, because the same alpha drives the `bg-input/30` tint |
| `--border` and `--input` (.dark-theme) | Use alpha-based values (`oklch(100% 0 0 / 0.1)` for `--border`, `oklch(100% 0 0 / 0.15)` for `--input`); opacity stacking can reduce effective contrast |

**Rule:** After any theme customization (changing OKLCH values), re-run contrast checks on all narrow-margin pairs above.

---

## Typography

shadcn/ui ships no typography token system by default — font choices are left to the project. Common patterns:

| Pattern | Description |
|---------|-------------|
| Tailwind's `font-sans` | System font stack — default for all shadcn/ui components |
| `font-mono` | Code blocks, inline code |
| `font-heading` (custom) | Add to `@theme` if a heading font is defined |

**Type scale:** Use Tailwind's built-in `text-*` utilities (`text-sm`, `text-base`, `text-lg`, etc.). Enverus One does not define custom type scale tokens.

---

## Extending the Token System

`--success`, `--info`, `--warning`, `--link`, and `--ai` are already defined — do not redefine them. When adding tokens beyond the existing set:

```css
:root {
  --brand-highlight: oklch(0.82 0.12 85);
}

.dark-theme {
  --brand-highlight: oklch(0.65 0.12 85);
}
```

**Extension rules:**
1. Semantic name only — no primitive names (`--green-500` = wrong)
2. Both `:root` and `.dark-theme` entries required
3. Define a `-foreground` companion if the token is used as a background
4. Expose via Tailwind v4 `@theme inline {}` to create utility classes
5. Document in this file with usage intent and WCAG contrast data

---

*System: Enverus One (built on shadcn/ui conventions, Tailwind v4, OKLCH)*
*Paired with: `token-system.md` (rules + architecture), `tokens.css` (values)*
