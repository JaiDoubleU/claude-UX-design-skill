# Component Spec Writing

Standard for documenting components for design system handoff and development.

---

## When to Write a Spec

Write a component spec when:
- A new component is being added to the design system
- An existing component is being significantly modified
- A developer needs enough detail to build without back-and-forth
- A component is being contributed by a team outside the core design system team

---

## Component Spec Template

```
## Component: [atom/molecule/organism]/[component-name]

### Overview
**Purpose:** What job does this component do for the user?
**Atomic layer:** Atom / Molecule / Organism
**Status:** Draft / Review / Approved / Deprecated

---

### Variants
List all variants. Format: `[component]-[variant]-[state]`

| Variant | Description |
|---------|-------------|
| default | [description] |
| [variant-name] | [description] |

---

### States
Document every interactive state:

| State | Trigger | Visual change |
|-------|---------|---------------|
| Default | — | [description] |
| Hover | Cursor over element | [description] |
| Focus | Keyboard focus / tab | [description] |
| Active | Click/press | [description] |
| Disabled | `disabled` prop | [description] |
| Error | Validation failure | [description] |
| Loading | Async action | [description] |

---

### Anatomy
Label each part of the component:
1. [Part name] — [description, required/optional]
2. [Part name] — [description, required/optional]

---

### Spacing & Sizing

Use Tailwind spacing utilities or the `--radius` token — not hardcoded px values.

| Property | Token / Utility | Value |
|----------|----------------|-------|
| Padding (internal) | `p-[n]` / `px-[n] py-[n]` | [e.g. p-4 = 16px] |
| Gap (between elements) | `gap-[n]` | [e.g. gap-2 = 8px] |
| Min width | — | [px or %] |
| Min height / touch target | — | ≥ 44px mobile / ≥ 24px desktop |
| Border radius | `rounded-sm` / `rounded-md` / `rounded-lg` | 6px / 8px / 10px (from `--radius`) |

---

### Typography

Enverus One uses Tailwind's built-in text utilities — no custom type token names.

| Element | Tailwind utility | Weight | Size |
|---------|-----------------|--------|------|
| Label | `text-sm` / `text-base` | `font-medium` / `font-semibold` | 14px / 16px |

---

### Color Tokens

Use actual Enverus One CSS custom property names from `references/enverus-one/tokens.css`.
Token values are in OKLCH — look them up in `tokens.css`, not this file.

| Element | CSS token | Notes |
|---------|-----------|-------|
| Background | `--background` / `--card` / `--muted` | Choose the appropriate surface level |
| Body text | `--foreground` / `--card-foreground` | Must match surface token |
| Muted text | `--muted-foreground` | Helper text, timestamps, placeholders |
| Border | `--border` / `--input` | `--input` for form control borders (`border-input`); in dark mode `dark:bg-input/30` tints form controls and outline buttons. `--border` for everything else, including the outline button border in light mode |
| Primary action | `--primary` / `--primary-foreground` | Always pair together |
| Focus ring | `--ring` | Never suppress without equivalent replacement |
| Destructive | `--destructive` | No foreground companion — verify contrast manually |

---

### Accessibility Requirements
- **Keyboard:** [How is it operable by keyboard?]
- **Screen reader:** [What is announced? ARIA role, label, state?]
- **Focus visible:** [Describe focus indicator]
- **Contrast:** Label [ratio]; Icon/border [ratio]; Background [exempt/ratio]
- **ARIA attributes:** List required aria-* attributes
- **Touch target:** Minimum [px]×[px]

---

### Props / API (for dev handoff)

| Prop | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| `label` | string | — | Yes | Button label text |
| `variant` | enum | `primary` | No | Visual style |
| `disabled` | boolean | `false` | No | Disables interaction |
| `onClick` | function | — | No | Click handler |

---

### Do / Don't

**Do:**
- [Correct usage example]
- [Correct usage example]

**Don't:**
- [Incorrect usage — and why]
- [Incorrect usage — and why]

---

### Related Components
- [component name] — [relationship, e.g., "use this when you need X instead"]

---

### Changelog
| Version | Date | Change |
|---------|------|--------|
| 1.0 | [date] | Initial spec |
```

---

## Spec Writing Guidelines

**Be specific about tokens, not values**
- ✅ `gap-4` (16px via Tailwind) or `--primary` (CSS token)
- ❌ `16px` or `#3b8321` (hardcoded — breaks theming and dark mode)

**Document every state — no skipping disabled or error**
These are the states most often missed in handoff and most often broken in build.

**Write the accessibility section as requirements, not suggestions**
Use "must" language: "Must have visible focus ring," "Must announce state change."

**Name props for developers, not designers**
Use the naming convention of the actual codebase if known (camelCase for React, kebab-case for web components).

**Flag anything unresolved**
Use `[TBD]` or `[OPEN QUESTION: ...]` rather than leaving blanks. Blank = ambiguous.
