# Trace — Enverus One Component Reference

**Atomic layer:** Molecule (a list of rows, each row a composed icon + title + optional description)
**Status:** Draft — pending design review
**Upstream:** https://ui.shadcn.com/docs/components/base/trace (Base UI variant; `base-nova` registry)
**Source:** `references/enverus-one/components/trace.tsx` (E1-adapted)

---

## Overview

**Purpose:** Show the steps an agent or process takes — tool calls, reasoning, sources, plans, queued tasks — as one consistent list. Use `Trace` for steps. Use `Message` for the reply and `Marker` for notes and dividers between turns.

**Use for:** tool calls, subagent runs, file edits, reasoning summaries, source lists, plan steps, task queues.
**Do not use for:** the final answer (use `Message`), system notes or dividers (use `Marker`), file attachments (use `Attachment`).

---

## Anatomy

```
Trace                              list container
└── TraceLine                      one row (span, not interactive by default)
    ├── TraceIcon                  leading action icon (aria-hidden)
    ├── TraceTitle                 one sentence, truncates, shimmers while running
    ├── TraceDescription           optional secondary text (count, duration, diff stat)
    └── TraceIcon                  optional trailing indicator

Trace
└── TraceCollapsible               expandable row
    ├── TraceCollapsibleTrigger    button wrapping a TraceLine; adds a chevron
    │   └── TraceLine
    └── TraceCollapsibleContent    detail; keepMounted optional
```

`TraceLine` is always the line. To make a row do something, wrap it in that thing's trigger (link, dialog, sheet, drawer, popover). Do not put interactive controls inside `TraceLine`.

---

## Variants

Trace has no visual variants. Its only state axis is `TraceLine` status.

| Variant | Description |
|---------|-------------|
| default (no status) | Completed work. Plain muted text. |
| `running` | In progress. Title shimmers. Write the title in the present tense. |
| `error` | Failed work. Icon takes `--destructive`; title stays `--foreground`. Say "Failed to…" in the title. |
| `pending` | Not started (plan steps). Reduced opacity. |

---

## States

| State | Trigger | Visual change |
|-------|---------|---------------|
| Default | — | `--muted-foreground` text, `--muted-foreground` icon |
| Hover (interactive row) | Cursor over trigger or link | Text and icon to `--foreground`; pointer cursor |
| Focus | Keyboard focus on trigger or link | `ring-3` in `--ring` at 50% on the row's rounded box |
| Expanded | Trigger activated | Chevron rotates 90°; detail panel animates height |
| Running | `status="running"` | Title shimmer (disabled under `prefers-reduced-motion`) |
| Error | `status="error"` | Icon in `--destructive`; title in `--foreground` |
| Pending | `status="pending"` | 60% opacity |
| Disabled | Not supported by Trace | Do not render a disabled row. Omit it or show as `pending`. [OPEN QUESTION: confirm with design whether any row needs a disabled state.] |

---

## Spacing & Sizing

| Property | Token / Utility | Value |
|----------|----------------|-------|
| Row gap (icon ↔ title) | `gap-2` | 8px |
| List gap (between rows) | `gap-2` on `Trace` | 8px |
| Icon box | `size-4` | 16px |
| Detail indent | `pl-4` with `border-l` | 16px, left rule |
| Row text | `text-sm` | 14px |
| Row minimum touch target (interactive) | — | [OPEN QUESTION: rows are text-height; confirm whether interactive rows need a 44px mobile target per the spec template] |

---

## Color Tokens

| Element | CSS token | Notes |
|---------|-----------|-------|
| Row text and icon (default) | `--muted-foreground` | Passes on background in both themes |
| Row text on hover / active | `--foreground` | |
| Error icon | `--destructive` | Icon only. Text stays `--foreground`. |
| Description | `--muted-foreground` | No opacity modifier (see contrast results) |
| Focus ring | `--ring` | Via `ring-ring/50` |
| Detail rule | `--border` | Via `border-l` default |

---

## Accessibility Requirements

- **Must** render as the element that wraps the line. A bare `TraceLine` is a `span` and is read as text, not as a control.
- **Must** wrap an expandable row in `TraceCollapsibleTrigger`. This provides a button with `aria-expanded`.
- **Must** wrap a link row in an `<a>` with an `href`. For new-tab links, add `<span className="sr-only"> (opens in a new tab)</span>` inside `TraceTitle`.
- **Must** write `TraceTitle` as a sentence that says what happened ("Edited trace.tsx", not "trace.tsx"). `TraceIcon` is `aria-hidden`, so the title is the accessible name.
- **Must** put status in the title text, not only in color or motion. Examples: "Running pnpm build", "Failed to run pnpm build".
- **Must** keep status color on the icon only for `error`. Text must stay at 4.5:1 (see E1 adaptations).
- **Must** honor `prefers-reduced-motion`. The shimmer is disabled in that case, and the title still states the current status.
- **Must** give any block placed inside `TraceCollapsibleContent` an explicit `text-foreground` if it sits on a muted background. `CodeBlock` sets its own color.
- **Must** use `Dialog`, `Sheet`, `Drawer`, or `Popover` with a `Title` (or `sr-only` title) when the trigger opens an overlay. These handle Escape and focus return.
- **Must not** nest interactive controls inside `TraceLine`.
- Keyboard: triggers and links are reachable by Tab and activated by Enter/Space (native button/anchor behavior). Plain `TraceLine` is not a tab stop.
- Screen reader: inside `MessageScroller`, each new line is announced once when added. [OPEN QUESTION: verify announcement behavior in E1's chat prototype.]

---

## Contrast Results (WCAG 2.2 AA, measured from `tokens.css`)

| Pair | Light | Dark | Requirement | Result |
|------|-------|------|-------------|--------|
| `muted-foreground` on `background` | 7.96:1 | 4.54:1 | 4.5:1 (text) | Pass both |
| `muted-foreground` on `card` | 8.69:1 | 4.17:1 | 4.5:1 (text) | Light pass; **dark fails** if row sits on a card |
| `muted-foreground/70` on `background` (upstream description) | 3.73:1 | 2.87:1 | 4.5:1 (text) | **Fail both — fixed in E1 adaptation** |
| `muted-foreground/70` on `card` (upstream description) | 3.91:1 | 2.74:1 | 4.5:1 (text) | **Fail both — fixed in E1 adaptation** |
| `destructive` on `background` (upstream error title) | 4.12:1 | 6.19:1 | 4.5:1 (text) | **Light fails — fixed: title stays `foreground`, icon takes `destructive`** |
| `destructive` on `card` | 4.50:1 | 5.69:1 | 4.5:1 (text) | Pass (at threshold) |
| `destructive` icon on `background` | 4.12:1 | 6.19:1 | 3:1 (non-text) | Pass both |

**Open contrast flag:** In dark theme, `--muted-foreground` on `--card` is 4.17:1. Rows placed inside a Card should use `text-foreground` on the title or the row should move to a background surface. [TBD: decide with design.]

---

## E1 Adaptations (from upstream base-nova source)

| # | Change | Reason |
|---|--------|--------|
| 1 | Added `"use client"` | Collapsible uses state and event handlers. Required under RSC. |
| 2 | `cn` imported from `@/lib/utils` (upstream: `"cn"`) | E1 alias convention. [VERIFY against env-one.ui `components.json` aliases.] |
| 3 | `Collapsible*` imported from `@/components/ui/collapsible` (upstream: `@/registry/base-nova/ui/collapsible`) | Project alias path. |
| 4 | `IconPlaceholder` replaced with `ChevronRightIcon` from `lucide-react` | Upstream placeholder is app-specific. Icon library per `components.json` `iconLibrary`. [VERIFY.] |
| 5 | `TraceLine` error: title `text-foreground`, icon `text-destructive` | Light-theme contrast 4.12:1 for `destructive` text. |
| 6 | `TraceDescription`: removed `/70` opacity | Fails 4.5:1 in both themes. |
| 7 | `TraceCollapsibleTrigger`: removed `has-[[data-status=error]]:text-destructive` | Follows change 5; error color no longer applies to the trigger text. |

### Dependency and runtime notes

- **Base UI required.** The `TraceCollapsibleContent` height uses `--collapsible-panel-height`, a Base UI variable. If E1 uses Radix collapsible, this variant will not animate. Confirm `base` in `components.json` before using. [VERIFY.]
- **`shimmer` utility required.** `data-[status=running]:*:data-[slot=trace-title]:shimmer` depends on a `shimmer` class. Without it, running titles render as plain text. This is not an a11y failure because the title still states the status. [VERIFY that E1 defines `shimmer`; if not, add it from the shadcn utils page or drop the class.]
- **Tailwind v4 syntax.** Uses `h-(--collapsible-panel-height)`, `--spacing(2)`, and `wrap-break-word`. Matches E1's Tailwind v4 setup.

---

## Props / API (for dev handoff)

| Component | Prop | Type | Default | Description |
|-----------|------|------|---------|-------------|
| `Trace` | `className` | `string` | — | List container classes |
| `TraceLine` | `status` | `"running" \| "error" \| "pending"` | — | State of the reported work |
| `TraceLine` | `className` | `string` | — | Row classes |
| `TraceIcon` | `className` | `string` | — | Icon slot classes. Use `data-icon`-free children; no size classes needed. |
| `TraceTitle` | `className` | `string` | — | Title classes |
| `TraceDescription` | `className` | `string` | — | Secondary text classes |
| `TraceCollapsible` | `open` | `boolean` | — | Controlled open state. Pass with `onOpenChange`. |
| `TraceCollapsible` | `defaultOpen` | `boolean` | `false` | Start open |
| `TraceCollapsible` | `onOpenChange` | `(open: boolean) => void` | — | Open state change |
| `TraceCollapsibleTrigger` | `className` | `string` | — | Trigger classes |
| `TraceCollapsibleContent` | `keepMounted` | `boolean` | `false` | Keep detail mounted while closed (preserves nested open state) |
| `TraceCollapsibleContent` | `className` | `string` | — | Applied to the inner detail wrapper |

---

## Usage

### Single step

```tsx
<Trace>
  <TraceLine>
    <TraceIcon><SearchIcon /></TraceIcon>
    <TraceTitle>Searched for minimumReleaseAge</TraceTitle>
  </TraceLine>
</Trace>
```

### Expandable step

```tsx
<Trace>
  <TraceCollapsible>
    <TraceCollapsibleTrigger>
      <TraceLine>
        <TraceIcon><TerminalIcon /></TraceIcon>
        <TraceTitle>Ran node --version</TraceTitle>
        <TraceDescription>0.2s</TraceDescription>
      </TraceLine>
    </TraceCollapsibleTrigger>
    <TraceCollapsibleContent>v24.18.0</TraceCollapsibleContent>
  </TraceCollapsible>
</Trace>
```

### Failed step

```tsx
<TraceLine status="error">
  <TraceIcon><CircleAlertIcon /></TraceIcon>
  <TraceTitle>Failed to run pnpm lint</TraceTitle>
</TraceLine>
```

### Link row (new tab)

```tsx
<a href="https://docs.astro.build" target="_blank" rel="noreferrer">
  <TraceLine>
    <TraceTitle>
      Install Astro
      <span className="sr-only"> (opens in a new tab)</span>
    </TraceTitle>
    <TraceIcon><ArrowUpRightIcon /></TraceIcon>
  </TraceLine>
</a>
```

### Dialog row

```tsx
<Dialog>
  <DialogTrigger>
    <TraceLine>
      <TraceTitle>Searched the web for cache keys</TraceTitle>
      <TraceIcon><ChevronRightIcon /></TraceIcon>
    </TraceLine>
  </DialogTrigger>
  <DialogContent>
    <DialogTitle>Cache key search results</DialogTitle>
    {/* … */}
  </DialogContent>
</Dialog>
```

---

## Do / Don't

**Do:**
- Write titles as completed sentences with the object named: "Edited trace.tsx".
- Use the status prop and say the status in the title.
- Use `Trace` rows for AI SDK reasoning, tool, and source parts. Map each part to one row.
- Use `TraceDescription` for counts and durations.

**Don't:**
- Don't use `text-muted-foreground/70` or any opacity on description or title text.
- Don't color an error title in `--destructive`. Color the icon.
- Don't use `Trace` for the reply text. Use `Message`.
- Don't put buttons or inputs inside `TraceLine`.
- Don't hand-build a row with a styled `div`. Compose `TraceLine`.

---

## Related Components

- `Message` — the assistant's reply text. Use it alongside a `Trace`, not inside one.
- `Marker` — system notes and dividers between turns.
- `Collapsible` — the primitive `TraceCollapsible` wraps.
- `Sheet`, `Dialog`, `Drawer`, `Popover` — overlays a row can open.
- `Attachment` — file items.
- `Badge` — counts or labels that do not belong in a row.

---

## Changelog

| Version | Date | Change |
|---------|------|--------|
| 1.0 | 2026-10-18 | Initial E1 reference from shadcn base-nova Trace. Contrast fixes applied. |
