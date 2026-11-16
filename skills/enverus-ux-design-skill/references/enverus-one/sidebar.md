# Sidebar — Enverus One

The primary navigation rail on the left of every Enverus One page. It is the shadcn/ui Sidebar 07
block ("Sidebar 07") with E1 tokens and Lucide icons. Use it as-is and do not invent
per-page variants.

Implementation: `apps/one/src/components/sidebar/UnifiedSidebarContent.tsx` in env-one.ui.

---

## When to Use

- Every top-level E1 page shows the sidebar to the left of the page header and page body.
- Build it from the shadcn `Sidebar`, `SidebarMenu`, `SidebarMenuItem`, `SidebarMenuButton` and
  `SidebarFooter` components with Lucide icons. Do not hand-roll the markup.
- Use the tokens below, never hardcoded hex values.
- Do **not** use it inside dialogs, drawers or cards.
- Always make it collapsible to an icon-only rail (see Behavior).

---

## Variants

`EnverusOne Sidebar` is a component set with one boolean variant, `collapsed`. Both variants are
full height, vertical, and carry the same items in the same order.

| Variant | Width | Role |
|---|---|---|
| `collapsed=false` | 264px | Expanded: icon plus label |
| `collapsed=true` | 48px | Icon rail: icons only, no labels, no badge |

---

## Anatomy — Expanded

```
┌──────────────────────────────┐
│ [E] Vera                 [▯] │  active item, collapse control at right
│ [⚯] Flows                    │
│ [ϟ] Agents                   │
│ [▦] Applications             │
│ [✦] Skills                   │
│ [💡] Concepts                 │
│ [⛬] Spaces      Coming Soon  │
│ [▥] Library                  │
│ [⌁] Connections              │
│                              │
│ (middle group scrolls/clips) │
│                              │
│ [?] Help & Support           │  footer, pinned to bottom
└──────────────────────────────┘
```

| Part | Spec |
|---|---|
| Container | Background is the `--sidebar` variable (`bg-sidebar`), with no white or other overlay on top; 1px right border is the `--sidebar-border` variable (`border-sidebar-border`), not `border-border` or a hex value |
| Content group | Inset 6px horizontally (`spacing/1.5`); 8px vertical padding (`spacing/2`) |
| Menu item (button) | Full-width button wrapping a menu-button row |
| Menu-button row | 32px tall, 8px padding, 8px gap between icon and label, `rounded-md` (8px) |
| Label | 14px, line-height 1, single line, ellipsis on overflow; Roboto Flex |
| Default item | Regular (400), `sidebar-foreground` (#0a0a0a), no background |
| Active item | `sidebar-accent` (#f5f5f5) background, Medium (500), `sidebar-accent-foreground` (#171717) |
| Icon | 16px, left of the label |
| Footer | Pinned to bottom, 8px padding, one 32px row styled like a default item; no separator above |

### Items, top to bottom

| # | Label | Icon | Notes |
|---|---|---|---|
| 1 | Vera | Enverus "E" logo mark (see Logo mark below) | Active in the design; 16px collapse control (`PanelLeft`) at the right edge |
| 2 | Flows | `workflow` | |
| 3 | Agents | `zap` | |
| 4 | Applications | `layout-grid` | |
| 5 | Skills | `wand-sparkles` | |
| 6 | Concepts | `lightbulb` | |
| 7 | Spaces | `network` | "Coming Soon" badge |
| 8 | Library | `library-big` | |
| 9 | Connections | `cable` | |
| Footer | Help & Support | `circle-question-mark` | |

### Logo mark

The Vera item uses the Enverus "E" logo mark, not a Lucide icon. Use the supplied asset
[`assets/enverus-logo-mark.svg`](assets/enverus-logo-mark.svg) and never redraw or approximate it.

- `viewBox="0 0 120 97"`. The product code renders it at 18px (`h-4.5 w-4.5`, `flex-shrink-0`);
  size it to sit in the same 16-18px icon slot as the Lucide icons.
- The "E" letterform is `currentColor`. Set `text-foreground` on the SVG so it uses the `--foreground`
  color in light and dark themes (not the sidebar item's own text color):
  `<EnverusLogoMark className="h-4.5 w-4.5 flex-shrink-0 text-foreground" />`.
- The three green bars are fixed brand colors, `#A0EF6E` and `#56BC2F`. They are the one place a
  hex value is allowed in the sidebar, because they are the logo, not a theme token.
- It is decorative next to the "Vera" label: `aria-hidden="true"` and `focusable="false"`. In the
  collapsed rail the item's `aria-label` and tooltip name it.

```tsx
function EnverusLogoMark(props: React.ComponentProps<"svg">) {
  return (
    <svg viewBox="0 0 120 97" fill="none" aria-hidden="true" focusable="false" {...props}>
      <path fillRule="evenodd" clipRule="evenodd" fill="currentColor" d="M115.5,54.6v-16H74.8V18.9h42.3V2H54.6v75.4h20.2V54.6H115.5z M74.8,93.8h44.6V77.4H74.8V93.8z" />
      <polygon fillRule="evenodd" clipRule="evenodd" fill="#A0EF6E" points="24.2,93.8 54.7,93.8 54.7,77.4 24.2,77.4" />
      <polygon fillRule="evenodd" clipRule="evenodd" fill="#A0EF6E" points="0,54.8 20.3,54.8 20.3,38.4 0,38.4" />
      <polygon fillRule="evenodd" clipRule="evenodd" fill="#56BC2F" points="34.2,54.8 115.5,54.8 115.5,38.4 34.2,38.4" />
    </svg>
  )
}
```

### Icon names and the Lucide version

These names are for `lucide-react` 0.542.0, the version `apps/one` uses. `packages/ui` is on
`^0.462.0`, which may not have every name: in that older package the help icon is `circle-help`
(`CircleHelp`, now an alias of `circle-question-mark`), and `wand-sparkles` may be missing. Check the
installed version before importing (see `lucide-icons.md`).

### "Coming Soon" badge

- Absolutely positioned inside the Spaces row: `right` 4px, `top` 6px.
- Height 20px (`h-5`), 4px horizontal padding (`spacing/1`).
- Text 12px Medium, line-height 16px, `sidebar-foreground`.
- Plain text with no background or border. It is not a pill.
- **Only while the page doesn't exist.** The badge and the not-clickable state mark an item that is
  not available yet. When the page you are building *is* that item (for example the Spaces page),
  drop the badge and the tooltip suffix, make the item a normal active item (`isActive`,
  `aria-current="page"`) and keep it clickable, linking to the current page.
- The Spaces row is not dimmed in the design, but while unavailable it is **not clickable**: it does not navigate
  and has no hover or pressed state. Render it as non-interactive (for example `aria-disabled="true"`
  with no `href` and no click handler) so assistive technology announces it as unavailable.

---

## Anatomy — Collapsed

| Part | Spec |
|---|---|
| Container | Background is the `--sidebar` variable (`bg-sidebar`), the same as expanded; same 1px right border (`border-sidebar-border`); 8px side padding |
| Header | `bg-sidebar` area (inherits the container background), 8px padding, one 32px square slot holding the `PanelLeft` toggle that expands the sidebar |
| Items | Same nine items, icon only, each a 32 × 32 button centered in the rail |
| Active item | The current page's item; `sidebar-accent` fills its 32px square. In the standard example that is Vera, whose icon is the Enverus logo mark (`rounded-lg`, 10px, with 10px padding). Vera keeps the logo mark on whichever page is current. |
| Footer | Only the `CircleQuestionMark` icon, as a 32px square button |

The design export gives the collapsed button rows a 248px width. They are clipped to the rail, so
build them 32px wide.

---

## Tokens

- **Colors:** `sidebar` #fafafa, `sidebar-border` #a3a3a3, `sidebar-accent` #f5f5f5,
  `sidebar-accent-foreground` #171717, `sidebar-foreground` #0a0a0a. The design export also shows the container
  as `alpha/5` and `alpha/10` (white at 95% and 90%); that is the light-mode look of `--sidebar`
  and must not be built as a white overlay. The design files name these `base/sidebar…`; in code they are
  unprefixed (`--sidebar`, `--sidebar-accent`, …).
- **Background:** the sidebar's background is always the `--sidebar` variable, applied as
  `bg-sidebar` on the container (expanded and collapsed, header included). Do not use `bg-white`,
  `bg-background`, a hex value or a white/alpha overlay. Its border is always the `--sidebar-border`
  variable (`border-sidebar-border`). The top navbar uses the same two variables, so the bar and the
  rail always match.
- **Theming:** the hex values above are the **light** render only. Never write them into the
  component. Use the `sidebar*` tokens (`bg-sidebar`, `text-sidebar-foreground`,
  `border-sidebar-border`, …) so the sidebar follows the `.dark-theme` class on the root, as the
  navbar does. If the project's `tokens.css` is imported, do not keep the `--sidebar*` variables the
  shadcn CLI adds to the app CSS (HSL values, with a dark block keyed to `.dark`). They override the
  tokens and leave the sidebar light in dark mode. Delete that block, or `shadcn add sidebar` will
  leave the sidebar stuck on the light colors.
- **Spacing:** `spacing/0` (0), `spacing/1` (4), `spacing/1-5` (6), `spacing/2` (8).
- **Radius:** `rounded-md` 8px (items), `rounded-lg` 10px (collapsed logo button), `rounded-xl`
  14px (expanded container).
- **Type:** `font/font-sans` (Roboto Flex). Labels `text-sm/leading-none` at medium or normal
  weight; badge `text-xs/leading-normal/medium`.

---

## Behavior

- The active item is the one for the current page, not always Vera. The standard example shows Vera active
  because it shows the Vera page.
- One active item at a time. Mark it with the filled `sidebar-accent` background plus Medium
  weight. No left bar, no color change.
- The sidebar must be collapsible. Collapsing shrinks it to the 48px icon-only rail (`collapsed=true`):
  labels and the "Coming Soon" badge are hidden, and every item keeps its icon. Every item
  therefore needs an icon, even if the expanded design could do without one.
- The `PanelLeft` toggle must stay visible and reachable in both states. Never hide it when the
  sidebar collapses, or the user has no way to expand it again. In the collapsed rail it lives in
  a `SidebarHeader` slot above the items (see Anatomy — Collapsed).
- Collapse and expand use the `PanelLeft` icon: in the Vera row when expanded, in the header slot
  when collapsed.
- The footer stays pinned to the bottom; the middle group scrolls or clips.
- **The sidebar sits below the top navbar**, starting 42px from the top of the page (the navbar's
  height, see `navbar.md`). Offset it with `top-[42px]` and give it the remaining height,
  `h-[calc(100svh-42px)]`. It never runs underneath or on top of the navbar.

- **Tooltips:** in the collapsed rail every item shows a tooltip with its label on hover and on
  keyboard focus (use the `tooltip` prop on `SidebarMenuButton`). This includes Help & Support and
  the Spaces item, whose tooltip should read "Spaces (Coming Soon)" while it is unavailable (just "Spaces" once it is the live page). Expanded items show no
  tooltips, because the label is already visible. Every icon-only button also keeps an `aria-label`.
- **Spaces is not clickable.** See the "Coming Soon" badge section above.
