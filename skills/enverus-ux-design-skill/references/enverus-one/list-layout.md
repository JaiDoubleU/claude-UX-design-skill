# List Layout — Enverus One

The standard layout for a page body that lists records. The same data can be shown as a **table**
(list view) or as a grid of **cards**, switched by a toggle in the toolbar. The layout has three
stacked parts: a toolbar above, the table or card grid in the middle, and pagination below.

Use it as-is for any list of records (spaces, projects, assets, documents). Pages differ only in
the columns, filters, sort options and card content they supply.

This doc owns the list body. The page shell around it (navbar, sidebar, page header) lives in
[`rules/page-layout.md`](rules/page-layout.md); the list body is what goes in that doc's page body.

---

## When to Use

- A page whose main job is browsing, searching and opening a set of records of the same kind.
- Use **both** views when the records have a meaningful at-a-glance summary (a card) and
  comparable attributes (columns). Offer only one view, and hide the toggle, if the other adds
  nothing.
- Do **not** use it for a handful of fixed items (use a plain list or cards without a toolbar), for
  dense spreadsheet-style editing, or inside dialogs and drawers.
- Build it from the shadcn components under `@/components/ui/*` (`Input`, `ToggleGroup`, `Button`,
  `DropdownMenu`, `Select`, `Table`, `Card`, `Badge`, `Avatar`) with Lucide icons. Do not hand-roll
  the markup.

---

## Anatomy

```
┌──────────────────────────────────────────────────────────────────────────┐
│ TOOLBAR                                                                  │
│ [🔍 Search…] [All|Mine|Shared]            [Columns ▥] or [Sort by: ⌄] [List|Cards] │
├──────────────────────────────────────────────────────────────────────────┤
│ TABLE VIEW                       or        CARD VIEW                     │
│ ┌──────────────────────────────┐          ┌────────┐ ┌────────┐ ┌────────┐│
│ │ NAME ⇅  TYPE  GOAL  MEMBERS  │          │ card   │ │ card   │ │ card   ││
│ │ row                          │          └────────┘ └────────┘ └────────┘│
│ │ row                          │                                          │
│ └──────────────────────────────┘                                          │
├──────────────────────────────────────────────────────────────────────────┤
│ PAGINATION  Records per page [10 ⌄] · 1–6 of 6        [«] [‹] [1] [›] [»]│
└──────────────────────────────────────────────────────────────────────────┘
```

| Part | Position | Behavior |
|---|---|---|
| Toolbar | Top of the list body | Always visible; does not change height between views |
| Table / card view | Fills all remaining height between toolbar and pagination | The only part that scrolls, vertically, when the rows or cards overflow |
| Pagination | Bottom of the list body, pinned | Never scrolls and is never pushed out of the parent; separated by a 1px top border (`border`) |

The list body fills the full height of its parent container. The toolbar and pagination keep their
natural height, and the table or card view takes all the space between them and scrolls on its own
(see Scroll Behavior).

The toolbar, the table or card grid and the pagination bar all use the page gutter, 24px (`px-6`),
the same as the page header, so their left and right edges line up with the page title and the
actions above. Do not use a narrower 16px inset inside the list.

---

## Toolbar

A single row, `flex items-center justify-between`, 24px horizontal padding (`px-6`), 8px gap between
controls, 8px vertical padding. All toolbar controls are 28px tall, use the `border` color and the
`radius/md` corner, and use 14px text.

### Left side: search, then filters

Order is fixed: **search field first, then one or more filter fields**.

| Control | Spec |
|---|---|
| Search | `Input` with a leading Lucide `Search` icon (16px, `muted-foreground`), about 220px wide. Placeholder names the records: "Search spaces…". |
| Filters | One or more controls to the right of search, 8px gap. Each filters the data in the table or cards. |

- Search filters as the user types, debounced about 250ms, and matches the visible text fields
  (name, goal and so on). It resets to page 1.
- Use a **segmented control** (`ToggleGroup`, `type="single"`) for a filter with 2–4 short mutually
  exclusive options, such as "All | Mine | Shared with me". The selected segment gets the `muted`
  background, `font-medium` and `foreground` text; the others use `muted-foreground`. Segments are
  separated by a 1px `border` divider inside one bordered group. The group itself sits on the `card`
  surface (`bg-card`), not the page `background`: in light mode `muted` (oklch 0.94) is almost the
  same as `background` (0.95), so a selected segment placed straight on the page is invisible. The
  same applies to the List / Cards toggle. "All" is the default and cannot be deselected.
- Use a **Select or DropdownMenu filter button** for a filter with many options (status, type,
  owner). When a value is chosen, show it in the button label ("Type: Action") and show a clear
  affordance.
- Filters combine with AND. Changing any filter or the search resets to page 1.
- Add as many filters as the data needs; if they no longer fit on one row, wrap the left group
  under the right group rather than shrinking controls below their natural width.

### Right side: layout tools

Order, left to right: **mode-specific tool, then the view toggle on the far right**.

| View | Mode-specific tool | Far right |
|---|---|---|
| Table | **Columns** button | View toggle |
| Card | **Sort by** dropdown | View toggle |

The Columns button is **replaced** by the Sort dropdown when the view switches to cards, and back
again when it returns to table. The two never show together, and the view toggle does not move.

**Columns button (table view)**
- Outline `Button`, `size="sm"`, with a leading Lucide `Columns3` icon and the label "Columns".
- Opens a `DropdownMenu` of `DropdownMenuCheckboxItem`s, one per column, to show or hide it. Keep the
  menu open while toggling. The identifying column (Name) is always shown and its item is disabled.
- Hiding a column removes it from the table only; it does not change filters or sort.

**Sort by dropdown (card view)**
- Outline `Button`, `size="sm"`, with a leading Lucide `ArrowUpDown` icon, the label "Sort by:
  *current option*" (for example "Sort by: Updated") and a trailing `ChevronDown`.
- Opens a `DropdownMenu` of `DropdownMenuRadioItem`s, one per sortable field, such as Updated, Name
  and Type. Include a direction control (ascending/descending) in the menu, or toggle direction by
  choosing the active option again. Default to the most useful field, usually "Updated" newest first.
- In table view sorting happens in the column headers instead (see Table view).

**View toggle (far right, both views)**
- A `ToggleGroup` with two items, **List** (Lucide `Rows3`, or `List`) and **Cards** (Lucide
  `LayoutGrid`), each an icon plus a text label, in one bordered group.
- The active item has the `muted` background; the inactive one is transparent with
  `muted-foreground` text.
- Switching views keeps the search, filters, sort and current page size. It does not reload data.
  Put `aria-label="View"` on the group and give each item an accessible name.

---

## Table view

A bordered, rounded container (`border`, `radius/lg`, `bg-card`) holding a shadcn `Table`. The
container fills with `card`, not `background`, so the `muted` row hover and selected states are
visible in light mode (see the note on `muted` under Toolbar). Its height is its content: a short
list leaves blank page space below the border, as in the standard layout, and a long list scrolls
inside the container (see Scroll Behavior).

| Part | Spec |
|---|---|
| Header row | About 43px tall, uppercase 12px labels, `font-semibold`, `foreground` color, with a 1px bottom border |
| Sortable header | Label followed by a small Lucide `ChevronsUpDown` icon (`muted-foreground`); becomes `ChevronUp` or `ChevronDown` when active. The whole header is a button. |
| Rows | About 50px tall, 14px text, 1px `border` divider between rows, no outer divider at the bottom |
| Cell padding | 16px horizontal (`px-4`), vertically centered, **identical on every header and body cell**, including checkbox and Actions cells. Do not special-case any column. |
| First column | `font-medium`, the record's name; it is the link or click target that opens the record |
| Row hover | `muted` background at low opacity |
| Select column | Optional. Fixed first column of checkboxes for bulk operations; table view only (see Select column) |
| Actions column | Optional. Fixed last column, header "ACTIONS", holding a ghost icon button with Lucide `EllipsisVertical` that opens the row's action menu (see Actions column) |

Cell content types seen in the standard list:

- **Type / status:** an outline `Badge` with a leading Lucide icon and the label. The icon is the 12px (`size-3`) that `Badge` sets itself; do not override it (the generated `Badge` forces `[&>svg]:size-3!`).
- **Long text (goal, description):** single line, truncated with an ellipsis, with the full text in
  a tooltip.
- **Members:** an avatar group (see Members below).

Columns: a column-width model that gives long-text columns the flexible space and fixes the
badge, member and actions columns to their content width. Keep column headers stable when the
Columns menu hides a column.

### Select column (optional)

Include it only when the records support **bulk operations** (delete, archive, share, move several
at once). Leave it out otherwise. It exists **only in the table view**. Cards do not support
selection or bulk operations, so the card view never shows checkboxes.

| Part | Spec |
|---|---|
| Position | **Fixed** as the first column, before the Name column. Not reorderable, not in the Columns menu, cannot be hidden, and not sortable. |
| Width | Fixed, about 48px, never flexible. The checkbox is centered in the cell, horizontally and vertically, in the header and every row. |
| Header | A "select all" `Checkbox` with `aria-label="Select all records on this page"`. No text label. |
| Cell | A `Checkbox` (shadcn, 16px) with `aria-label="Select {record name}"`, border color `--input` (`border-input`) |
| Horizontal scroll | Stays pinned to the left edge (`sticky left-0`, `background` fill, 1px right border or shadow while content scrolls beneath it) |
| Selected row | The row gets the `muted` background so the selection is visible at a glance |

**Checkbox cells (any checkbox column)**
- **No padding override, on any cell.** shadcn's `TableHead` and `TableCell` ship with
  `[&:has([role=checkbox])]:pr-0`, which removes the right padding from any cell that holds a
  checkbox. That class must not be applied to any table cell: delete it from both components in
  `@/components/ui/table.tsx` and do not re-add it per cell, so cells with and without checkboxes
  have the same padding (see `shadcn/rules/styling.md`).
- Checkboxes are **centered** in their cells: the cell is `flex items-center justify-center`, or
  `text-center` with the checkbox as an inline-flex child, and the same centering applies to the
  header and every row so the column lines up. Its padding is the same as every other cell (see
  Table view, Cell padding); a 48px column with 16px side padding leaves exactly the 16px checkbox,
  so no padding override is needed.
- A disabled checkbox wrapped in a `Tooltip` trigger must stay centered like the others. Make the
  wrapper the same size as the checkbox or `contents`, so it does not shift the checkbox sideways.
- The checkbox border color is the `--input` variable (`border-input`) in the unchecked, hover and
  disabled states, in both themes. Do not use `border-border`, `border-foreground` or a hex value.
  A checked or indeterminate checkbox fills with `primary`.

**Header checkbox states**
- Unchecked: no rows on the current page are selected.
- Checked: every selectable row on the current page is selected.
- Indeterminate (`checked="indeterminate"`, dash icon): some but not all rows on the page are
  selected. Clicking it selects all rows on the page.
- Select all applies to the **current page only**, not to every page of results. When a full page
  is selected and more records match, show a link in the bulk action bar ("Select all 42 records")
  that extends the selection to all filtered records. Selecting across pages shows a "Clear
  selection" link.

**Row behavior**
- Clicking the checkbox toggles that row only. It does not open the record, so stop the click from
  reaching the row's open action. Clicking elsewhere on the row still opens the record.
- Rows that cannot take part in bulk operations (no permission, locked) show a `disabled`
  checkbox with a tooltip saying why, and are skipped by select all.
- Selection is by record ID, so it survives sorting, paging and hiding columns. Changing the
  search or a filter keeps selections that are still in the data but hides the ones filtered out,
  and bulk operations act only on the selected records that are visible under the current filters.
- Shift-click selects the range between the last-clicked row and this one.

**Bulk action bar**
- When one or more rows are selected, a bulk action bar replaces the toolbar row at the same height,
  so the table does not move. It shows "{n} selected", the bulk action buttons (outline `Button`,
  `size="sm"`, icon + verb, destructive last), and a "Clear selection" ghost button on the right.
  When the selection is cleared the toolbar returns with its search, filters and layout controls
  as they were.
- Destructive bulk actions ask for confirmation in a dialog that states how many records are affected.
- Announce changes to assistive tech through an `aria-live="polite"` region ("3 records selected").
- Keep the bar to one or two primary actions plus a "More" `DropdownMenu` if there are more.

**Switching to cards**
- Because cards do not support bulk operations, switching to the card view **clears the
  selection** and the bar closes. The view toggle should warn first, with a confirmation, if there
  is a selection of more than one record. Switching back to the table starts with nothing selected.

### Actions column (optional)

Include it only when records have actions that act on the single record in that row (open, edit,
duplicate, share, archive, delete). Leave it out when the only action is opening the record, which
the first column already does.

| Part | Spec |
|---|---|
| Position | **Fixed** as the last column. It is not user-reorderable and does not appear in the Columns menu, so it cannot be hidden. |
| Header | Label "ACTIONS", styled like other headers but **not sortable** (no sort icon) |
| Width | Fixed to its content, about 96px, never flexible. Cell content is left-aligned under the header label, with the same 16px cell padding. |
| Cell content | One ghost `Button`, `size="icon"`, with a Lucide `EllipsisVertical` icon (`muted-foreground`, `foreground` on hover), and `aria-label="Actions for {record name}"` |
| Trigger | The button is a `DropdownMenuTrigger`; clicking it opens the menu |
| Horizontal scroll | When the table scrolls horizontally, the Actions column stays pinned to the right edge (`sticky right-0`, `background` fill, 1px left border or shadow while content scrolls beneath it) |

**Menu**
- shadcn `DropdownMenu`, `align="end"` so the menu's right edge lines up with the button, opening
  below the button and flipping above it near the bottom of the scroll region.
- Each action is a `DropdownMenuItem` with a leading 16px Lucide icon and a short verb label
  ("Edit", "Duplicate", "Share", "Archive"). Order by frequency, with the most common first.
- Put destructive actions (Delete, Remove) last, after a `DropdownMenuSeparator`, with the
  `destructive` variant (`variant="destructive"`). Destructive actions ask for confirmation in a dialog
  before running.
- Show only the actions the user may perform on that record. Omit those they have no permission for. If
  an action is unavailable for the record's current state but is normally offered, show it
  `disabled` with a tooltip explaining why. If a row has no available actions, hide its button.
- Selecting an item closes the menu and runs the action on that row's record only.

**Interaction**
- Clicking the button or the menu must not trigger the row's open action (`stopPropagation`).
- The button is focusable in the row's tab order; Enter or Space opens the menu, arrow keys move
  between items, Escape closes it and returns focus to the button.
- The menu works the same with a mouse and the keyboard; do not rely on hover.
- Keep the button visible at all times, not only on row hover, so it is discoverable and works on
  touch.
- Use one shared action list for the table row and the card menu of the same record, so both views
  offer the same actions in the same order.

```tsx
<TableCell className="w-24">
  <DropdownMenu>
    <DropdownMenuTrigger asChild>
      <Button variant="ghost" size="icon" aria-label={`Actions for ${row.name}`}>
        <EllipsisVertical />
      </Button>
    </DropdownMenuTrigger>
    <DropdownMenuContent align="end">
      <DropdownMenuItem><Pencil /> Edit</DropdownMenuItem>
      <DropdownMenuItem><Copy /> Duplicate</DropdownMenuItem>
      <DropdownMenuSeparator />
      <DropdownMenuItem variant="destructive"><Trash2 /> Delete</DropdownMenuItem>
    </DropdownMenuContent>
  </DropdownMenu>
</TableCell>
```

---

## Card view

A responsive grid of cards in place of the table.

| Part | Spec |
|---|---|
| Grid | `grid gap-4`, three columns at desktop (`grid-cols-3`), two at tablet, one at mobile |
| Card | shadcn `Card`: `border`, `radius/xl`, `bg-card`, 16px padding, vertical stack with 8px gaps |
| Header row | Title on the left (`font-semibold`, 14px, truncates to one line) and a ghost `EllipsisVertical` actions button on the right, vertically centered with the title (`flex items-center justify-between`; the 32px button uses `-my-1 -mr-2` so the row keeps the title's height and the dots line up with the card's right padding), opening the same menu as the table's Actions column |
| Meta row | The type `Badge` followed by secondary metadata such as "Owner: Jimmy Tran" (12px, `muted-foreground` label with `foreground` value). Omit the owner when it is not available. |
| Description | 14px body text, up to two lines then truncated |
| Divider | 1px `border` rule above the footer, with the footer pinned to the card bottom so cards in a row align |
| Footer | Avatar group on the left; "Updated 20 min ago" (12px, `muted-foreground`) on the right |

- Cards in a row share the height of the tallest card.
- The card is a single click target that opens the record. The actions button stops propagation.
- Show relative time for the updated stamp; put the exact timestamp in a tooltip.

### Members (avatar group)

Used in the table's Members column and the card footer. Overlapping 24px circular avatars
(`size-6`, `bg-muted`, `foreground` text, 10px semibold initials, `leading-none`, at most two
letters) with a 2px ring in the surface color (`ring-2 ring-card` in cards and the table). The overlap
is 4px (`-space-x-1`), and later avatars sit on top of earlier ones. Do not overlap more than 4px: the
initials are centered in each circle and about 13px wide, so with a 24px circle only 4px of overlap
keeps the right-hand letter clear of the next avatar. The initials must never be clipped or
truncated. Show up to four, then a "+N" overflow avatar.

Build the group as a plain flex wrapper, **not** shadcn's `AvatarGroup`, which forces `-space-x-2` and
`ring-background` and overrides these values. Use `Avatar size="sm"` (24px), `-space-x-1` on the
wrapper and the ring on each avatar:

```tsx
<div className="flex items-center -space-x-1">
  {members.slice(0, 4).map((m) => (
    <Avatar key={m.id} size="sm" className="ring-2 ring-card">
      <AvatarFallback className="text-[10px] font-semibold leading-none">{m.initials}</AvatarFallback>
    </Avatar>
  ))}
  {members.length > 4 && (
    <Avatar size="sm" className="ring-2 ring-card">
      <AvatarFallback className="text-[10px] font-semibold leading-none">+{members.length - 4}</AvatarFallback>
    </Avatar>
  )}
</div>
```

 A private record shows a Lucide `Lock` icon
(14px, `muted-foreground`, with `aria-label="Private"`) after the avatars.

---

## Pagination

A bar below the table or cards, with a 1px top border (full width), 24px horizontal padding (`px-6`) and 12px text.
Left and right groups, `justify-between`.

**Left: records per page**
- The label reads **"Records per page"** (not "Rows per page", even in table view, because the same
  control serves cards).
- A compact `Select` showing the current size. Options: 10, 25, 50, 100. Default 10.
- After a dot separator, show the range and total: "1–6 of 6".

**Right: page buttons**
- Order: first page (`ChevronsLeft`), previous (`ChevronLeft`), page numbers, next (`ChevronRight`),
  last page (`ChevronsRight`). Each is a 28px square outline icon button with
  `aria-label`s "First page", "Previous page", "Next page", "Last page".
- The current page is a filled `primary` button with `primary-foreground` text; other pages are
  outline buttons. Show a window of about five page numbers with an ellipsis for gaps.
- Disable first/previous on page 1 and next/last on the final page (disabled uses 50% opacity and no
  pointer events).
- Changing the page size resets to page 1. Pagination applies to both views and the page size is
  shared between them.

---

## Scroll Behavior

The list body is a vertical flex column that fills its parent. Only the middle region scrolls, so
the pagination bar stays visible at the bottom of the parent at every page size, window height and
record count.

| Region | Classes | Behavior |
|---|---|---|
| List body (root) | `flex h-full min-h-0 flex-col` | Fills the parent's height. The parent must have a bounded height (see below). |
| Toolbar | `shrink-0` | Never shrinks or scrolls |
| Table / card region | `min-h-0 flex-1 overflow-y-auto` | Takes all remaining height and scrolls vertically inside itself |
| Pagination | `shrink-0` | Never shrinks or scrolls; always the last child, pinned to the bottom edge |

Rules:

- **Fill the parent.** The table or card region uses `flex-1`, so it grows to fill the space even
  when there are only a few records. The pagination bar sits at the bottom of the parent, not
  directly under the last row. The empty area under a short list is blank.
- **Bounded parent height.** The parent must have a definite height and not grow with its content.
  In the page shell this is the page body from [`rules/page-layout.md`](rules/page-layout.md); make it
  `flex-1 min-h-0` and give it `overflow-hidden` so the list body, not the page, handles scrolling.
  Every flex ancestor between the viewport and the list body needs `min-h-0`, or the list grows past
  the viewport and the pagination scrolls out of view.
- **One scroll container.** Do not let the page body or the browser window scroll as well. The page
  never shows a second vertical scrollbar next to the list's.
- **Never scroll the pagination or toolbar.** They are siblings of the scroll region, not inside it.
- **Table view:** the scroll element is the bordered container itself, `max-h-full overflow-auto`,
  inside the `min-h-0 flex-1` region. It hugs a short list and scrolls a long one, and its border
  and rounded corners stay in view while the rows scroll. The header row is `sticky top-0` with the
  `card` color (the container fill) and a bottom border, so column labels stay visible while rows
  scroll beneath it. If the Columns menu makes the table wider than the container, it scrolls
  horizontally in the same element and the header scrolls with it. shadcn's `Table` wraps itself in
  an `overflow-x-auto` div, which stops `sticky` from working: remove it (see
  `shadcn/rules/styling.md`, Post-generation fixes).
- **Card view:** the card grid scrolls inside the region with the 24px page gutter on the left and right. Do not let
  the grid stretch cards to fill the height; cards keep their natural height and the grid starts at
  the top.
- **Keep position across views and filters.** Switching views, changing the page or page size, or
  changing a filter scrolls the region back to the top. Changing only the Columns selection keeps
  the scroll position.
- **Scrollbar:** use the native or shadcn `ScrollArea` scrollbar inside the region only. It sits at
  the region's right edge and does not overlap the pagination bar.
- **Small screens:** keep the same structure. The toolbar may wrap to two rows, and the scroll
  region takes whatever height is left. If the toolbar and pagination leave no usable height at
  very short viewports, let the page body scroll as a fallback rather than clipping the list.

```tsx
export function ListLayout({ toolbar, view, pagination }: {
  toolbar: React.ReactNode
  view: React.ReactNode // the table or card grid
  pagination: React.ReactNode
}) {
  return (
    <div className="flex h-full min-h-0 flex-col">
      <div className="shrink-0">{toolbar}</div>
      <div className="min-h-0 flex-1 overflow-y-auto px-6">{view}</div>
      <div className="shrink-0 border-t">{pagination}</div>
    </div>
  )
}
```

---

## Canonical Markup

```tsx
import { Columns3, ArrowUpDown, ChevronDown, LayoutGrid, Rows3, Search } from "lucide-react"

import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { ToggleGroup, ToggleGroupItem } from "@/components/ui/toggle-group"

type View = "table" | "cards"

export function ListToolbar({
  view,
  onViewChange,
  sortLabel,
  children, // filter controls, rendered after the search field
}: {
  view: View
  onViewChange: (view: View) => void
  sortLabel: string
  children?: React.ReactNode
}) {
  return (
    <div className="flex items-center justify-between gap-2 px-6 py-2">
      <div className="flex items-center gap-2">
        <div className="relative w-[220px]">
          <Search className="absolute left-2.5 top-1/2 size-4 -translate-y-1/2 text-muted-foreground" />
          <Input className="h-7 pl-8" placeholder="Search spaces…" aria-label="Search spaces" />
        </div>
        {children}
      </div>
      <div className="flex items-center gap-2">
        {view === "table" ? (
          <Button variant="outline" size="sm"><Columns3 /> Columns</Button>
        ) : (
          <Button variant="outline" size="sm"><ArrowUpDown /> Sort by: {sortLabel} <ChevronDown /></Button>
        )}
        <ToggleGroup
          type="single"
          variant="outline"
          size="sm"
          value={view}
          onValueChange={(v) => v && onViewChange(v as View)}
          aria-label="View"
        >
          <ToggleGroupItem value="table"><Rows3 /> List</ToggleGroupItem>
          <ToggleGroupItem value="cards"><LayoutGrid /> Cards</ToggleGroupItem>
        </ToggleGroup>
      </div>
    </div>
  )
}
```

---

## Tokens

- **Colors:** `background`, `card` (card surface), `border` (container, dividers, controls), `input`
  (checkbox border), `muted`
  (selected segment, avatar fill, row hover), `muted-foreground` (secondary text, inactive controls,
  sort icons), `foreground`, `primary` and `primary-foreground` (current page).
- **Radius:** `radius/md` for toolbar controls and pagination buttons, `radius/lg` for the table
  container, `radius/xl` for cards.
- **Spacing:** `spacing/2` (8px) between toolbar controls, `spacing/6` (24px) for the page gutter, `spacing/4` (16px) for
  card padding and grid gaps.
- The design files name tokens `base/…`; in code they are unprefixed (`--border`, `--muted`, …).

---

## Behavior

- **State is shared across views:** search, filters, page and page size persist when the view
  toggles. Sort is per mode: the column header sort in table view, and the Sort by dropdown in card
  view. Initialize the dropdown from the active column sort when switching, if one is set.
- **Order of operations:** filter and search, then sort, then paginate. The range text counts the
  filtered total ("1–6 of 6").
- **Empty state:** when search or filters match nothing, replace the table or grid with a centered
  message ("No spaces match your filters") and a "Clear filters" button. Keep the toolbar. Hide
  pagination or show "0 of 0".
- **Loading:** show skeleton rows or cards of the current view, keeping the toolbar interactive.
- **Responsive:** below about 768px, drop to a two-column or one-column card grid, wrap the toolbar
  onto two rows (search and filters, then layout tools) and default to the card view.
- **Keyboard:** all toolbar controls are reachable in DOM order (search, filters, columns or sort,
  view toggle). Sortable headers, rows and cards are focusable with a visible focus ring.

### Not specified in the design

- The exact filter set beyond the "All | Mine | Shared with me" example.
- Whether the user's view choice, column visibility, sort and page size persist between visits
  (recommend remembering them per list in local storage).
- The sort options and default sort per list, and which actions each list's row menu offers.
- The bulk actions each list offers, and the exact look of the bulk action bar. The Select column
  and bar are specified here from the requirements, not from a design.

Confirm these with the design team before specifying them.
