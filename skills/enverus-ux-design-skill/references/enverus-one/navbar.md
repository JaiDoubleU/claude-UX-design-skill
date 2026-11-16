# Top Navbar — Enverus One

The slim bar across the top of every Enverus One page. It carries the Enverus ONE wordmark at the
left and two controls at the right: the light/dark theme toggle and the user avatar. Use it as-is
and do not invent per-page variants.

---

## When to Use

- Every top-level E1 page shows the navbar **fixed at the top of the page**, above the page content
  (see `sidebar.md` and `page-header.md` for the rest of a full page). The sidebar sits **below** the
  navbar, starting 42px from the top of the page (the navbar's height), so the navbar always spans
  the full page width above it.
- Do **not** add navigation links, a search input or other controls to it. The one exception is the
  mobile sidebar trigger below. The design's wrapper is named
  `Input and Buttons Wrapper`, but no input belongs in the bar.
- Do **not** use it inside dialogs, drawers or cards.
- Build the buttons and avatar from the shadcn components under `@/components/ui/*` (`Button`,
  `Avatar`) with Lucide icons. Do not hand-roll the markup.

---

## Anatomy

```
┌────────────────────────────────────────────────────────────────────────┐
│ [ENVERUS | ONE]                                          [☀]  (AC)    │  42px
└────────────────────────────────────────────────────────────────────────┘
 ─ 1px bottom border ─
```

| Part | Spec |
|---|---|
| Container | Full width, height 42px, `flex items-center justify-between`, right padding 16px (`spacing/4`) |
| Background | The `--sidebar` variable (`bg-sidebar`), the same as the sidebar, with no `bg-background`, `bg-white`, hex value or overlay |
| Border | Bottom edge only, 1px (`border-width/border`), color is the `--sidebar-border` variable (`border-sidebar-border`), not `border-border` or a hex value |
| Left group | 16px padding on each side, 16px gap, vertically centered; holds the wordmark |
| Right group | Full bar height, `flex items-center`, 16px gap; sits 16px from the right edge |
| Wordmark | 146.28 × 14px SVG, 16px from the left edge, vertically centered |
| Theme toggle | 32 × 32px icon button |
| Avatar | 32 × 32px circle with the user's initials |

Both right-hand controls are 5px from the top and bottom, which centers them in the 42px bar.

---

## Wordmark

Use the supplied asset [`assets/enverus-one-wordmark.svg`](assets/enverus-one-wordmark.svg) and never
redraw or approximate it. It is the "ENVERUS | ONE" lockup.

- `viewBox="0 0 146.276 14"`. Render it at its natural size, 146.28 × 14px.
- The "ENVERUS" and "ONE" lettering and the thin divider are `currentColor`. Set `text-foreground` on
  the SVG so they use the `--foreground` color in light and dark themes (near-white on the dark bar,
  near-black on the light bar): `<EnverusOneWordmark className="text-foreground" />`.
- The green bars of the "E" are fixed brand colors, `#A0EF6E` and `#56BC2F`. They are the one place
  a hex value is allowed in the navbar, because they are the logo, not a theme token.
- **Inline the SVG** (as a React component or inline `<svg>`). An `<img src>` or CSS background does
  not inherit `currentColor`, so the lettering would stay black on the dark bar.
- It is decorative next to the page, so keep `aria-hidden="true"` and `focusable="false"`. If the
  wordmark is a link home, give the link `aria-label="Enverus One home"`.

---

## Right-hand controls

### Theme toggle

- Shadcn `Button` with `variant="secondary"` and `size="icon"`: 32 × 32px.
- Icon is a Lucide `Sun` or `Moon`. The design holds two stacked buttons for the toggle, `Light Mode
  Button` (shown, `Sun`) and `Dark Mode Button` (hidden), and one is visible at a time. In the dark
  render the sun is showing, so the icon shows the mode the button switches **to**: `Sun` while the
  theme is dark, `Moon` while it is light.
- It is an icon-only button, so it needs an `aria-label` that names the action ("Switch to light
  mode" or "Switch to dark mode").
- Do not size the icon with classes inside the button; the component sizes it.

### Mobile sidebar trigger (below 768px only)

Below 768px the sidebar becomes an off-canvas sheet, so the navbar needs a way to open it. Put a
`SidebarTrigger` at the left of the bar, before the wordmark, with `md:hidden` so it is never shown
at 768px and wider. It is a 32px icon `Button` (`variant="ghost"`, `size="icon"`) with the Lucide
`PanelLeft` icon and `aria-label="Open navigation"`. Because it calls `useSidebar`, the navbar must
render inside `SidebarProvider` (see `rules/page-layout.md`).

### Avatar

- Shadcn `Avatar`, 32px (`size-8`), circular, with an initials fallback (for example "AC") in the
  primary green with light text: `bg-primary text-primary-foreground`.
- Show the signed-in user's initials. The design's value is a placeholder.
- If the avatar opens a menu, make it a button with an `aria-label` such as "Account menu".

---

## Canonical Markup

```tsx
import { Moon, Sun } from "lucide-react"

import { Avatar, AvatarFallback } from "@/components/ui/avatar"
import { Button } from "@/components/ui/button"

// Inline the wordmark SVG so currentColor works. Source: assets/enverus-one-wordmark.svg
function EnverusOneWordmark(props: React.ComponentProps<"svg">) {
  return (
    <svg width="146.276" height="14" viewBox="0 0 146.276 14" fill="none" aria-hidden="true" focusable="false" {...props}>
      {/* paste the paths from assets/enverus-one-wordmark.svg */}
    </svg>
  )
}

export function Navbar({
  isDark,
  onToggleTheme,
  initials,
}: {
  isDark: boolean
  onToggleTheme: () => void
  initials: string
}) {
  return (
    <header className="sticky top-0 z-40 flex h-[42px] items-center justify-between border-b border-sidebar-border bg-sidebar pr-4 text-sidebar-foreground">
      <div className="flex items-center gap-4 px-4">
        <EnverusOneWordmark className="text-foreground" />
      </div>
      <div className="flex h-full items-center gap-4">
        <Button
          variant="secondary"
          size="icon"
          aria-label={isDark ? "Switch to light mode" : "Switch to dark mode"}
          onClick={onToggleTheme}
        >
          {isDark ? <Sun /> : <Moon />}
        </Button>
        <Avatar>
          <AvatarFallback className="bg-primary text-primary-foreground">{initials}</AvatarFallback>
        </Avatar>
      </div>
    </header>
  )
}
```

---

## Tokens

- **Colors:** `--sidebar` (background) and `--sidebar-border` (bottom border), the same two variables the sidebar uses, so the bar and the rail always match in both themes; `sidebar-foreground`
  (bar text), `foreground` (wordmark lettering via `text-foreground`), `primary` and
  `primary-foreground` (avatar). The design files name
  these `base/sidebar…`; in code they are unprefixed (`--sidebar`, `--sidebar-border`, …).
- **Spacing:** `spacing/4` (16px) for the bar's padding and gaps.
- **Border:** `border-width/border` (1px).
- **Fixed colors:** `#A0EF6E` and `#56BC2F` in the wordmark only.

---

## Behavior

- **Fixed at the top of the page.** The navbar stays pinned to the top edge and stays in view when the
  page content scrolls. Use `sticky top-0` with a z-index above the page content in the
  viewport-height flex column from `rules/page-layout.md`, and never put the navbar inside the
  scrolling content area.
- The bar does not collapse. At narrow widths keep the wordmark and both
  controls; do not hide the avatar or toggle.
- Switching the theme changes the toggle icon and the bar's colors. The wordmark lettering follows
  `--foreground` through `text-foreground`.

### Not specified

- How the navbar looks in light mode. The design was only rendered in dark mode here; build the
  light version from the same tokens and check it against the design.
- What the avatar opens (account menu, profile, sign out).
- Whether the wordmark is a link.

Confirm these with the design team before specifying them.
