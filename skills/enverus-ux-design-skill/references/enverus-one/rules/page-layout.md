# Page Layout — Enverus One

The standard shell every Enverus One page is built in. It has four regions: a fixed top navbar, a
sidebar nav rail below it on the left, and to the right of the rail a main section that holds the
page header followed by the page body. Use it as-is for every top-level and secondary page.

This doc owns **how the regions fit together**. The details of each region live in their own docs
and are not repeated here:

| Region | Doc |
|---|---|
| Top navbar | [`navbar.md`](../navbar.md) |
| Sidebar nav rail | [`sidebar.md`](../sidebar.md) |
| Page header | [`page-header.md`](../page-header.md) |
| Page body: list of records (table or cards, toolbar, pagination) | [`list-layout.md`](../list-layout.md); the list fills the body and scrolls inside itself, with pagination pinned below |
| Other page body components | shadcn rules in [`shadcn/rules/composition.md`](../shadcn/rules/composition.md) and the other `shadcn/rules/*` files |

If this doc and a region doc disagree on a measurement, the region doc wins.

---

## When to Use

- A request to build, mock up or lay out a page, screen or view always means the whole shell: navbar,
  sidebar, page header and page body. Never deliver the body alone and call it "the page".
- Build all four regions from their docs. Do not import a `Navbar` or `AppSidebar` you have not
  written, and do not skip them as "part of the app shell". Reuse an existing navbar or sidebar
  component only if the project already has one.
- Do **not** use the shell inside dialogs, drawers, sheets or cards. Those have their own headers and
  sit on top of the shell.
- Do **not** invent per-page variants of the shell. Pages differ only in what goes in the page body.

---

## Anatomy

```
┌──────────────────────────────────────────────────────────────────────┐
│ NAVBAR  [ENVERUS | ONE]                                  [☀]  (AC)  │ 42px, fixed
├────────┬─────────────────────────────────────────────────────────────┤
│        │ PAGE HEADER                                                 │
│        │  [‹ Back to Parent]                                         │
│ SIDE-  │  Page Title                              [Secondary][Primary]│
│ BAR    │  Short description                                          │
│ RAIL   ├─────────────────────────────────────────────────────────────┤
│        │ PAGE BODY  (the only region that scrolls)                   │
│ 264px  │  toolbar / tabs / filters                                   │
│  or    │  ┌───────────────────────────────────────────────────────┐ │
│ 48px   │  │ page-specific components: table, cards, charts, form  │ │
│        │  └───────────────────────────────────────────────────────┘ │
│ [?]    │                                                             │
└────────┴─────────────────────────────────────────────────────────────┘
```

| Region | Position | Size | Scrolls? |
|---|---|---|---|
| Navbar | Top edge, full page width, sticky | 42px tall | Never |
| Sidebar | Left, starts below the navbar | 264px expanded, 48px collapsed; height `calc(100svh − 42px)` | Only its middle group, if items overflow |
| Page header | Top of the main section | Natural height, never shrinks | Never |
| Page body | Fills the rest of the main section | Remaining width and height | **Yes** |

The page itself never scrolls. The browser window is exactly one viewport tall and the body is the
scroll container, so the navbar, sidebar and header cannot move.

---

## Canonical Markup

```tsx
<SidebarProvider
  className="h-svh min-h-0 flex-col bg-background text-foreground"
  style={{ "--sidebar-width": "264px", "--sidebar-width-icon": "48px" } as React.CSSProperties}
>
  <a href="#main-content" className="sr-only focus:not-sr-only focus:absolute focus:z-50 focus:m-2 focus:rounded-md focus:bg-background focus:px-3 focus:py-2">
    Skip to main content
  </a>
  <Navbar />                                   {/* sticky top-0, h-[42px], see navbar.md; inside the provider for its mobile trigger */}
  <div className="flex min-h-0 flex-1">
    <AppSidebar />                             {/* top-[42px] h-[calc(100svh-42px)], see sidebar.md */}
    <SidebarInset id="main-content" className="flex min-h-0 flex-col overflow-hidden">
      <div id="page-header" className="flex flex-col flex-shrink-0 overflow-hidden">…</div>
      <div id="page-body" className="flex min-h-0 flex-1 flex-col overflow-hidden">
        {/* optional fixed strip: tabs or toolbar, flex-shrink-0 */}
        <div className="min-h-0 flex-1 overflow-auto px-6 pb-6">
          {/* page-specific content */}
        </div>
      </div>
    </SidebarInset>
  </div>
</SidebarProvider>
```

Notes on the markup:

- These numbers come from the design specs. `SidebarLayout` in env-one.ui (260px wide, 56px top
  margin, collapse hides the sidebar entirely) does not match them yet, so do not copy its defaults.

- The root is the `SidebarProvider`, set to `h-svh flex-col`, so the navbar is the first child and the
  sidebar and main section, in a `flex` row, share the remaining height.
- The navbar sits **inside** `SidebarProvider` as its first child, above the sidebar and main row, so
  it spans the full width above the rail and its mobile-only sidebar trigger can call `useSidebar`
  (a trigger outside the provider throws "useSidebar must be used within a SidebarProvider").
- `SidebarInset` renders the `<main>` element, so it is the main landmark. Do not wrap it in a second
  `<main>`.
- `#page-header` and `#page-body` are siblings, header first. Page content never goes inside the
  header (see `page-header.md`).
- `#page-body` is `overflow-hidden` so it can hold a fixed strip above the scroll region. The scroll
  region is the inner `overflow-auto` div. `min-h-0` on every flex parent in the chain is required,
  or the content grows past the viewport instead of scrolling.

---

## Page Body

The body holds everything specific to the page. It owns its own spacing; the header adds none below
itself.

### Structure, top to bottom

1. **Fixed strip (optional, `flex-shrink-0`).** Tabs, or a toolbar with search, filters, sort and a
   view toggle. It stays in view while the content scrolls.
2. **Scroll region (`flex-1 overflow-auto`).** The main content of the page.
3. **Pagination or footer actions (optional).** Pin it below the scroll region when the page has a
   paged table or a sticky save bar.

### Gutter and spacing

| Rule | Value |
|---|---|
| Horizontal gutter | 24px (`px-6`), the same as the page header, so the title and the content share a left edge |
| Space between stacked sections | 24px (`gap-6`) |
| Space between related controls | 8–16px (`gap-2` to `gap-4`) |
| Bottom padding of the scroll region | 24px (`pb-6`), so the last item does not touch the window edge |

Use spacing tokens (`spacing/6` and so on), not arbitrary pixel values.

### Page types and what goes in the body

Pages differ only in their body. Pick the closest pattern, and compose it from shadcn components
under `@/components/ui/*`.

| Page type | Examples | Body pattern |
|---|---|---|
| **List / browse** | Flows, Agents, Library, Connections | Toolbar (search, filters, view toggle) over a `Table` or a responsive grid of `Card`s; pagination below |
| **Detail** | Asset detail, flow run | Back button in the header; summary strip or `Tabs`; each tab holds cards, a table or a viewer |
| **Dashboard** | Overview, usage | Optional filter bar; a row of stat cards; then charts and tables in a grid (see the `dataviz` skill for charts) |
| **Form / settings** | Create flow, connection setup | A single column, max 640–768px wide, left-aligned in the body; field groups in `Card`s or sections; a save/cancel bar (see `shadcn/rules/forms.md`) |
| **Empty page** | First visit, no results | The `Empty` component centered in the body, with one primary call to action |
| **Full-bleed workspace** | Vera chat, map, document viewer | Keeps the navbar and sidebar but fills the body edge to edge with no gutter. Confirm the header treatment with design |

### Width

- Tables, card grids and dashboards fill the available width. Do not center them in a fixed-width
  column.
- Reading and form content gets a max width (forms 640–768px, prose about 72ch) and stays left-aligned
  with the header, never centered.

---

## States Every Page Needs

Design all four, not just the loaded state.

| State | Treatment |
|---|---|
| **Loading** | Header renders immediately with its real title. The body shows `Skeleton` placeholders shaped like the final content. No full-page spinner, and never blank the shell. |
| **Empty** | `Empty` component in the body with an icon, a title, one sentence and one action. The header's actions stay in place. |
| **Error** | `Alert` (destructive) at the top of the scroll region with what failed and a retry action. The shell stays intact. |
| **Forbidden / not found** | Same shell. The body shows an `Empty`-style message and a link back to a valid page. |

Transient feedback (saved, deleted, copied) uses a toast, not an inline banner. See
`shadcn/rules/composition.md` for the toast component by project base.

---

## Layering and Overlays

| Layer | Z-index guidance | Notes |
|---|---|---|
| Page body, header, sidebar | base | |
| Navbar | `z-40` | Above the content so nothing scrolls over it |
| Sidebar tooltips, dropdowns, popovers | shadcn defaults (`z-50`) | |
| `Dialog`, `Sheet`, `Drawer`, `AlertDialog` | shadcn defaults (`z-50`) | Open over the whole shell, including the navbar and sidebar, with the shadcn overlay dimming everything |
| Toasts | Top of the stack | Render once at the app root, outside the shell's scroll containers |

Pick the overlay with the table in `shadcn/rules/composition.md`. A side `Sheet` for details or
filters is preferred over navigating away when the user needs to keep their place in a list.

---

## Navigation and Wayfinding

- **Sidebar** is the only primary navigation. The active item matches the current top-level section.
  Secondary pages keep their parent section active.
- **Back button** (in the page header) is the only way up from a secondary page. Do not add
  breadcrumbs unless design asks for them, and never use both.
- **Tabs** switch views of the same page. They are not navigation between pages. If a tab changes the
  URL, it is still the same page, and the header stays the same.
- **Page title** matches the sidebar label for top-level pages ("Flows" in the rail, "Flows" in the
  `h1`) and the `<title>` of the document.
- Do not add a second navigation rail, a top menu or links in the navbar.

---

## Responsive Behavior

The design defines the desktop layout only. Build the rest as follows and confirm with design.

| Width | Behavior |
|---|---|
| Desktop (≥ 1024px) | Full shell as above. Sidebar expanded by default, user can collapse to the 48px rail. |
| Tablet (768–1023px) | Sidebar starts collapsed to the 48px rail. Body keeps the 24px gutter. Card grids drop to two columns. |
| Narrow (< 768px) | The navbar stays and never hides the toggle or avatar. The sidebar becomes an off-canvas sheet opened from a trigger; the page header stacks, with actions wrapping under the title. Tables scroll horizontally inside the body. |

Design for 1280px wide first. Never let the shell itself scroll horizontally; only the content that
needs it (tables, code, charts) scrolls inside its own container.

---

## Accessibility

- **Landmarks:** `<header>` (navbar), `<nav aria-label="Primary">` (sidebar), `<main>` (the
  `SidebarInset`). Exactly one `<main>` and one `h1` per page.
- **Skip link:** the first focusable element, jumps to `#main-content`. Visible on focus.
- **Focus order:** navbar, sidebar, page header (back button, then actions in visual order), page body.
- **Scroll region:** a scrollable container must be keyboard reachable. Give it `tabIndex={0}` and an
  `aria-label` only when it has no focusable child.
- **Page change:** on client-side navigation, move focus to the `h1` (or `#main-content`) and update
  `document.title`.
- **Reduced motion:** the sidebar collapse is the only shell animation; honor
  `prefers-reduced-motion`.
- **Contrast:** semantic tokens only, so light and dark themes pass. No raw hex outside the logo.

---

## Tokens

- **Surfaces:** `background` for the page and body, `sidebar` for the navbar and rail.
- **Borders:** `sidebar-border` between the shell chrome and the content; `border` inside the body.
- **Text:** `foreground`, `muted-foreground`.
- **Spacing:** `spacing/6` (24px) for the gutter and section gaps; `spacing/4` (16px) and
  `spacing/2` (8px) inside components.
- **Theme:** both light and dark come from the tokens. Never branch on the theme in layout code.

---

## Rules

1. **Four regions, one shell.** Navbar → (sidebar, main → (header, body)). Don't reorder or nest
   differently.
2. **Navbar fixed on top**, 42px, full width, the first child of the shell above the sidebar row.
3. **Sidebar below the navbar**, 264px expanded and 48px collapsed, collapsible, never under the
   navbar.
4. **Only the page body scrolls.** The page, navbar, sidebar and header never do. Exception: for a
   list body ([`list-layout.md`](../list-layout.md)) the body is `overflow-hidden` and the list's own
   table or card region scrolls, so the pagination stays pinned below it.
5. **Header and body are siblings**, header first. Content never goes inside the header.
6. **Share the gutter.** Header and body both use `px-6`.
7. **Compose from shadcn.** Page content uses `@/components/ui/*`, not custom markup.
8. **Design every state:** loading, empty, error and forbidden, inside the intact shell.
9. **Semantic tokens only.** No hardcoded colors, font sizes or pixel offsets beyond the shell
   measurements above.
10. **Pages differ in the body only.** No per-page navbar, sidebar or header variants.

---

## Checklist

- [ ] `:root` sets `color-scheme: light` and `.dark-theme` sets `color-scheme: dark`, so dark-mode scrollbars are not white
- [ ] `html` sets `font-size: 14px` and the Tailwind scale is re-based in px (`--spacing: 4px`, px `--text-*`, `--radius: 10px`); fixed shell measurements (42px, 264px, 48px) are in px, not `rem`
- [ ] Root is a viewport-height flex column (`h-svh flex flex-col`); the page itself does not scroll
- [ ] Navbar is the first child of the shell (inside `SidebarProvider`), `sticky top-0`, 42px, full width above the sidebar row
- [ ] Sidebar is below the navbar (`top-[42px] h-[calc(100svh-42px)]`), 264px / 48px, collapsible
- [ ] Main section is a single `<main>` (`SidebarInset`) holding `#page-header` then `#page-body`
- [ ] `#page-header` follows `page-header.md` (one `h1`, optional back button, optional actions)
- [ ] `#page-body` has a fixed strip (optional) and an inner `overflow-auto` scroll region, with `min-h-0` through the flex chain
- [ ] Header and body share the `px-6` gutter; sections are 24px apart
- [ ] Body content comes from shadcn components and matches a page type above
- [ ] Loading, empty and error states are designed and keep the shell intact
- [ ] Skip link, landmarks, focus order and `document.title` are in place
- [ ] Works in light and dark; no hardcoded colors

---

## Not specified

These are conventions in this doc, not values taken from a design. Confirm them with the design team
before treating them as final.

- Tablet and mobile behavior (the design is desktop only).
- Max widths for forms and reading content, and the 24px section gap.
- The header treatment for full-bleed workspaces such as Vera chat.
- Whether breadcrumbs are ever allowed on deep detail pages.
- Where the toast stack sits on screen.
