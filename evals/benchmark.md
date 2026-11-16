# Benchmark

Benchmark results and scoring notes for the enverus-ux-design-skill evals.

Run evals defined in `evals.json` against the skill and record pass/fail counts and notes here.

## Format

```
Date: YYYY-MM-DD
Model: [model name]
Eval IDs run: [1, 2, 3, 4]
Results:
  - Eval 1: Pass / Partial / Fail — [notes]
  - Eval 2: Pass / Partial / Fail — [notes]
  ...
Overall: N/4 passed
```

## Results

> **Eval ids changed again on 2026-10-23.** The token-leakage "pending" status color eval (old id 4) was removed and the ids renumbered 1-8. Entries dated before 2026-10-23 use the old ids: old 5 (sidebar) is now 4, old 6 (icons) is now 5, old 7 (asset map toolbar) is now 6, old 8 (navbar) is now 7 and old 9 (Spaces list page) is now 8. Old ids 1-3 are unchanged, and old 4 no longer exists.
>
> **Eval ids changed on 2026-10-19.** PR #21 trimmed `evals.json` from 7 evals to 4 (ids 1-4). Entries labelled "previous eval set" use the old ids and are not comparable with the current ids: the old token-leakage (2), password-reset flow (3), Figma file health (5), Wells header (6) and first asset-detail header (7) evals no longer exist, and current ids 2 and 3 are page-header evals.

### 2026-10-23 — list-layout.md: Spaces list page eval (id 8), runs 1-8
```
Date: 2026-10-23
Model: subagents inheriting the session model (claude-sonnet-5-5)
Skill path: skills/enverus-ux-design-skill (working tree on main, uncommitted at the time)
Eval ID run: [8] (called id 9 until the renumbering above; it also gained and lost assertions between runs)
Method: blind subagent per run, told not to read evals/; page served with vite preview and measured in a browser (computed colors in both themes, table cell padding, row and header heights) plus screenshots of list and card views in light and dark. Not every assertion was graded line by line: results below are spot checks, not N/N counts.
Results:
  - Run 1: Fail (theme) — sidebar stayed rgb(250,250,250) in dark mode. The shadcn CLI appended its own HSL --sidebar* block and a .dark block to index.css after the tokens.css import, overriding the tokens; sidebar.md also described the container as a white overlay (alpha/5, alpha/10).
  - Run 2: Pass (theme) — agent replaced the CLI block; sidebar and navbar followed --sidebar / --sidebar-border in both themes. Avatar initials clipped, selected segment faint in light mode.
  - Run 3: Stopped before finishing (no results).
  - Run 4: Pass (theme, after the sidebar/navbar variable wording was added) — sidebar and navbar oklch(0.98) / oklch(0.24) with matching borders. Disabled checkboxes shifted ~16px off-center in the Select column.
  - Run 5: Stopped (prompt still asked for bulk selection, which was removed from the evals).
  - Run 6: Pass (colors, padding) — every table cell 16px/16px, no [&:has([role=checkbox])]:pr-0. Spaces shown active but still carried the "Coming Soon" badge; avatar initials still clipped.
  - Run 7: Pass — first run on evals/scaffold (~6.5 min vs 9-11). Table box on card surface, avatars readable, Spaces active with no badge. Gaps: shadcn AvatarGroup forces its own overlap and ring, header Button default is h-8 not h-9, Badge forces 12px icons.
  - Run 8: Pass (spot checks) — html font-size 14px, Tailwind scale re-based in px (header button 36px, row 50px, header row 43px, avatars 24px), color-scheme light/dark follows the theme, sidebar/navbar background and border follow --sidebar / --sidebar-border in both themes, all table cells 16px/16px, Spaces active (aria-current="page"), no Select column, "Records per page". Not checked on screen: the mobile sidebar trigger, row hover, the Columns and Sort by menus' contents.
Overall: runs 1 failed on theming; runs 2, 4, 6, 7, 8 passed the spot checks; runs 3 and 5 were stopped.
```
Doc and eval changes made along the way (all uncommitted until the PR that adds this entry):
- sidebar.md / navbar.md: background is the --sidebar variable and border is --sidebar-border, never a white overlay or border-border; the CLI-added --sidebar* block must be deleted; the active item is the current page's, and "Coming Soon" applies only while the page doesn't exist; mobile-only sidebar trigger in the navbar.
- rules/page-layout.md: the navbar is the first child inside SidebarProvider (a trigger outside it throws); 24px gutter; list bodies are an exception to "only the page body scrolls".
- list-layout.md (new): toolbar, table and card views, optional Select and Actions columns, scroll behavior, pagination, checkbox cells centered with --input borders, same padding on every cell, avatar group recipe, card surface for contrast.
- token-system.md, shadcn/rules/styling.md, forms.md: html font-size 14px with a px re-base of Tailwind's scale, color-scheme for scrollbars, --input borders for every checkbox and radio, and a post-generation fixes table for shadcn files (cn import, table.tsx padding class and overflow-x-auto, button primary variant, sonner next-themes).
- evals: removed the pending-status-color token eval (old id 4) and removed bulk selection from the Spaces eval; added theme, 14px root, color-scheme and table-padding assertions.
- evals/scaffold and evals/scripts/new-run.sh: a pre-built starter project so runs skip setup.

### 2026-10-21 — rules/page-layout.md and trimmed page-header.md: full run, evals 1-8
```
Date: 2026-10-21
Model: subagents inheriting the session model (claude-sonnet-5-5)
Skill path: skills/enverus-ux-design-skill (working tree on main, uncommitted)
Eval IDs run: [1, 2, 3, 4, 5, 6, 7, 8]
Results:
  - Eval 1: Pass (5/5) — 1.4.3, 1.4.1 + 3.3.1 + H9, H5 + AlertDialog, severities, action list
  - Eval 2: Pass (7/7) — secondary page header with back button, Share before the single primary
  - Eval 3: Pass (12/12) — full Flows page from page-layout.md; sticky navbar outside the sidebar provider, sidebar at top-[42px], header and body siblings, tabs in the body
  - Eval 4: Pass (5/5) — checked --info/--warning/--muted first, --pending, :root + .dark-theme, OKLCH, missing dark entry = High
  - Eval 5: Pass (12/12) — sidebar; logo mark, collapsible rail, tooltips, non-clickable Spaces, top-[42px]
  - Eval 6: Pass (7/7) — Search, Settings, Share2, Trash2 from lucide-react, aria-labels, no sizing or data-icon
  - Eval 7: Partial (6/8) — "Ask Vera" uses the inlined Enverus logo mark instead of a Lucide import, so it has no Lucide import and the output inlines an SVG
    Re-run after the eval wording was changed to allow the logo mark for "Ask Vera" (see below): Pass (8/8)
  - Eval 8: Pass (9/9) — navbar; inlined wordmark with text-foreground, sticky top-0 z-40, Sun toggle with aria-label, JS avatar
Overall: 7/8 passed, 1 partial (8/8 after the eval 7 wording change and re-run)
```
Notes:
- Agents were blind to assertions and to evals/. Evals 2, 3, 5 and 8 opened rules/page-layout.md; eval 3 also opened page-header.md, navbar.md and sidebar.md.
- Changes under test: new references/enverus-one/rules/page-layout.md, the updated page-building row in the SKILL.md routing table, and the "Full page" section of page-header.md reduced to a pointer.
- Eval 7: sidebar.md says the Vera item uses the Enverus "E" logo mark, and the agent applied that to the "Ask Vera" toolbar button. The assertions expect a Lucide icon such as Sparkles. Earlier runs scored 8/8. Either the eval wording or the skill needs to say which applies to "Ask Vera" outside the sidebar.
- Eval 3's agent marked Flows (not Vera) active and did not build the loading and error states from page-layout.md; no assertion covers either.
- Eval 7 assertions 1, 3, 4, 6 and 8 and the expected output now allow the inlined Enverus logo mark (EnverusLogoMark, from sidebar.md) for "Ask Vera". The re-run scored 8/8 with a different outcome: that agent never opened sidebar.md and used Sparkles as a placeholder, so it passed on the Lucide route. Whether the agent finds the logo-mark rule depends on whether it opens sidebar.md, so the same eval can now take either path and pass.
- Not rendered or type-checked.

### 2026-10-21 — regression run on the 1.2.1 release branch: evals 1, 4 and 7
```
Date: 2026-10-21
Model: subagents inheriting the session model (claude-sonnet-5-5)
Skill path: skills/enverus-ux-design-skill (branch release-1.2.1)
Eval IDs run: [1, 4, 7]
Results:
  - Eval 1: Pass (5/5) — WCAG 1.4.3 for grey headers; 1.4.1 + 3.3.1 + H9 for color-only errors; H5 + AlertDialog for delete; Critical/High/Medium/Low severities; prioritized action list
  - Eval 4: Pass (5/5) — checked --warning/--info/--muted first, --pending, :root + .dark-theme, OKLCH, missing dark entry = High
  - Eval 7: Pass (8/8) — asset map toolbar; 15 valid Lucide names, no good match reported for well, rig and pipeline, no custom SVGs, aria-label on icon-only buttons, no size classes on icons inside Buttons
Overall: 3/3 passed
```
Notes:
- Agents were blind to assertions and to evals/. Together with the 2026-10-21 runs of evals 2, 3, 5, 6 and 8 earlier the same day, every eval has now run on the content that makes up 1.2.1.
- Eval 1's action list is followed by a short "what's working" section and a request for a screenshot, as in earlier runs. Its delete finding was rated High this time (Critical in an earlier run); no assertion depends on it.
- Eval 7's agent called Drill misleading but used it as the rig stand-in, clearly flagged. Eval 7 still uses a different pipeline stand-in from earlier runs (Cable, then Waypoints, Route); all are valid names.
- Not rendered or type-checked.

### 2026-10-21 — logo color, routing and review clean-up: evals 3, 5 and 8
```
Date: 2026-10-21
Model: subagents inheriting the session model (claude-sonnet-5-5)
Skill path: skills/enverus-ux-design-skill (branch page-shell-section)
Eval IDs run: [3, 5, 8]
Results:
  - Eval 3: Pass (12/12) — full Flows page; sticky navbar outside the sidebar provider, sidebar at top-[42px] collapsible to a rail, header and body siblings; wordmark and logo mark use text-foreground
  - Eval 5: Pass (all assertions) — sidebar; logo mark with text-foreground, top-[42px] offset, tooltips, non-clickable Spaces, CircleQuestionMark
  - Eval 8: Pass (9/9) — navbar; wordmark inlined with text-foreground, sticky top-0 z-40, Sun toggle with aria-label, 32px JS avatar
Overall: 3/3 passed
```
Notes:
- Agents were blind to assertions and to evals/. Eval 3 and 8 saved their code to files, which were checked for the structural claims.
- Changes under test: logo and wordmark colored with text-foreground (--foreground), CircleQuestionMark rename, the Lucide version note in sidebar.md, the reordered routing table, the README tree and the usage-confirmation example.
- Eval 5's agent made two unspecified choices (tabIndex 0 and role="link" on the disabled Spaces item); neither is covered by an assertion.
- Not rendered or type-checked.

### 2026-10-21 — full-page shell in page-header.md: eval 3 (three runs)
```
Date: 2026-10-21
Model: subagents inheriting the session model (claude-sonnet-5-5)
Skill path: skills/enverus-ux-design-skill (branch page-shell-section)
Eval IDs run: [3]
Results:
  - Eval 3, run 1 (routing pointed only at page-header.md, whose Full page section linked the other docs): Partial (9/12) — shell structure and header/body assertions held, but the agent imported Navbar and AppSidebar from other files instead of building them, so the sidebar, navbar and offset assertions could not be verified
  - Eval 3, run 2 (added "build all four pieces, do not import ones you have not written"): Fail (9/12) — the agent read only page-header.md, left the navbar and sidebar out as "part of the app shell", and wrote just the header and body
  - Eval 3, run 3 (routing restored to name page-header.md, navbar.md and sidebar.md, and "a request to build a page always means the whole page"): Pass (12/12) — navbar sticky top-0 outside the sidebar provider, sidebar at top-[42px] h-[calc(100svh-42px)] collapsible to an icon rail, header and body as siblings, body owns scrolling
Overall: 1/1 passed after two failed attempts
```
Notes:
- Agents were blind to assertions and to evals/. Run 3 read SKILL.md, page-header.md, navbar.md, sidebar.md, lucide-icons.md, shadcn/SKILL.md and the wordmark SVG; the saved file was checked for the structural claims.
- Lesson: routing a page request to a single doc that links the others is too weak, because agents read the first doc and stop. The routing row has to name all three docs, and the doc must say a page request means the whole page.
- Not rendered or type-checked.

### 2026-10-21 — icon sizing follows the codebase: evals 2 and 6 re-run
```
Date: 2026-10-21
Model: subagents inheriting the session model (claude-sonnet-5-5)
Skill path: skills/enverus-ux-design-skill (branch icon-sizing-follow-codebase)
Eval IDs run: [2, 6]
Results:
  - Eval 2: Pass (7/7) — asset detail header; standard structure, back button, Share left of the single primary; rendered HTML has no 1em / stroke 1.75 / text-[14px]
  - Eval 6: Pass (7/7) — toolbar icons; no sizing classes, no data-icon, no width/height or stroke-width on icons, aria-label on each icon-only button
Overall: 2/2 passed
```
Notes:
- Agents were blind to assertions and to evals/. Both read lucide-icons.md (the new Sizing section) and followed it.
- Basis for the change: env-one.ui's Button sizes icons to 16px by default (size-4 rule), has no data-icon handling (0 uses), and has no 1em or stroke 1.75 anywhere in packages/ui/src or apps/one/src.
- Eval 2's agent wrote the Share2 and FolderPlus SVG paths from memory and flagged them for checking; no assertion covers them.
- Not rendered or type-checked.

### 2026-10-20 — sidebar-below-navbar rule: evals 3 and 5 re-run
```
Date: 2026-10-20
Model: subagents inheriting the session model (claude-sonnet-5-5)
Skill path: skills/enverus-ux-design-skill (branch navbar-spec)
Eval IDs run: [3, 5]
Results:
  - Eval 3: Pass (11/11) — Flows list page; navbar fixed at the top (fixed inset-x-0 top-0), sidebar offset top-[42px] with h-[calc(100svh-42px)], standard header and sibling #page-body
  - Eval 5: Pass (12/12) — sidebar; top-[42px] and h-[calc(100svh-42px)] offset, plus the earlier tooltip, non-clickable Spaces, logo-mark and toggle assertions
Overall: 2/2 passed
```
Notes:
- Agents were blind to assertions and to evals/.
- Eval 3's report abbreviated the wordmark paths ("paste paths from the SVG") while saying the delivered file inlined them in full; the agent's transcript contains the full paths, but the final answer as shown did not. The navbar assertions are graded on structure, position and tokens.
- Eval 3's agent also reported a stray unused icon import in its file. No assertion covers it.
- Neither run was rendered or type-checked.

### 2026-10-20 — navbar fixed-at-top rule: evals 3 and 8 re-run
```
Date: 2026-10-20
Model: subagents inheriting the session model (claude-sonnet-5-5)
Skill path: skills/enverus-ux-design-skill (branch navbar-spec)
Eval IDs run: [3, 8]
Results:
  - Eval 3: Pass (10/10) — Flows list page; all eight header/body assertions, plus the collapsible sidebar and a navbar fixed at the top (sticky top-0 z-40, outside the scrolling content)
  - Eval 8: Pass (9/9) — navbar; the eight earlier assertions plus sticky top-0 z-40 so it stays in view when the page scrolls
Overall: 2/2 passed
```
Notes:
- Agents were blind to assertions and to evals/. Eval 3 read SKILL.md, page-header.md, navbar.md, sidebar.md, the shadcn rules, lucide-icons.md and both brand SVGs.
- Eval 3 placed the sidebar below the navbar (a choice the skill does not specify; flagged by the agent and recorded as an open question in navbar.md). Tab contents were Empty placeholders; no assertion covers that.
- Neither run was rendered or type-checked.

### 2026-10-20 — navbar eval (id 8) after adding navbar.md
```
Date: 2026-10-20
Model: subagents inheriting the session model (claude-sonnet-5-5)
Skill path: skills/enverus-ux-design-skill (branch navbar-spec)
Eval IDs run: [8]
Results:
  - Eval 8: Pass (8/8) — 42px bar with sidebar tokens and bottom border; supplied wordmark inlined with currentColor lettering and fixed #A0EF6E/#56BC2F bars; secondary icon Button with Sun (dark page) and aria-label; 32px primary-green avatar with "JS"; no links or search; shadcn components from @/components/ui/*
Overall: 1/1 passed
```
Notes:
- Agent was blind to assertions and to evals/. It read SKILL.md, navbar.md, the wordmark SVG and the first 40 lines of lucide-icons.md.
- It did not verify Sun and Moon against the icon list (both exist in 0.542.0, checked after the run).
- Light mode, the avatar menu and wordmark link behavior are listed as not specified in navbar.md; the agent left them unspecified and flagged them.
- Not rendered or type-checked.

### 2026-10-20 — sidebar eval (id 5) after tooltip, Spaces and logo-mark rules
```
Date: 2026-10-20
Model: subagents inheriting the session model (claude-sonnet-5-5)
Skill path: skills/enverus-ux-design-skill (branch sidebar-tooltips-and-coming-soon)
Eval IDs run: [5]
Results:
  - Eval 5, run 1 (tooltip + Spaces rules, 10 assertions): Pass (10/10) — collapsed items had tooltips ("Spaces (Coming Soon)" for Spaces), Spaces non-clickable and aria-disabled; logo was a placeholder (no assertion yet)
  - Eval 5, run 2 (adds the logo-mark assertion, 11 assertions): Pass (11/11) — Vera uses the supplied E mark exactly (viewBox 0 0 120 97, currentColor letterform, #A0EF6E and #56BC2F bars)
Overall: 1/1 passed (2 runs)
```
Notes:
- Agents were blind to assertions and to evals/. Run 2 read SKILL.md, sidebar.md and lucide-icons.md.
- Design answers recorded in sidebar.md: collapsed items show tooltips; the Coming Soon item is not clickable. The Enverus E mark is now shipped as references/enverus-one/assets/enverus-logo-mark.svg.
- Not rendered or type-checked.

### 2026-10-20 — regression run (evals 1, 2, 4) on branch sidebar-and-lucide-icons (PR #33)
```
Date: 2026-10-20
Model: subagents inheriting the session model (claude-sonnet-5-5)
Skill path: skills/enverus-ux-design-skill (branch sidebar-and-lucide-icons at 6c2dc34)
Eval IDs run: [1, 2, 4]
Results:
  - Eval 1: Pass (5/5) — 1.4.3 for grey headers; 1.4.1 + 3.3.1 + H9 for color-only errors; H5 + AlertDialog confirmation for delete; Critical/High/Medium/Low severities; prioritized action list
  - Eval 2: Pass (7/7) — #page-header wrapper, #back-button row above #page-titles, outline sm "Back to Library" with ChevronLeft, h1 in #page-title, #page-subtitle, Share (secondary) left of the single primary "Add to project"
  - Eval 4: Pass (5/5) — checked --info/--muted (and ruled out --warning) first, --pending, :root + .dark-theme, OKLCH, missing dark entry = High
Overall: 3/3 passed
```
Notes:
- Agents were blind to assertions and to evals/. Confirms the sidebar, Lucide and page-header cross-reference changes did not regress these evals.
- Eval 1's action list was followed by a short "What's Working Well" section and a request for a screenshot, so it is last in the findings but not the final text.
- Eval 2 read page-header.md and lucide-icons.md but not sidebar.md, since the task asked only for the header. It used Share2 and FolderPlus, both valid names.

### 2026-10-20 — Lucide valid-names eval (id 7) after adding lucide-icons.md
```
Date: 2026-10-20
Model: subagents inheriting the session model (claude-sonnet-5-5)
Skill path: skills/enverus-ux-design-skill (main at a8dc54a plus uncommitted changes)
Eval IDs run: [7]
Results:
  - Eval 7: Pass (8/8) — asset map toolbar: all 15 icons from lucide-react and present in lucide-icons.md (checked by hand), imports given for every control, well and drilling rig reported as no good match and pipeline as weak, no custom SVGs, aria-label on every icon-only button, no sizing classes on icons inside Button/Toggle
Overall: 1/1 passed
```
Notes:
- Agent was blind to assertions and to evals/. It read SKILL.md, lucide-icons.md, shadcn/SKILL.md and shadcn/rules/icons.md.
- Icons: ZoomIn, ZoomOut, Maximize, Layers, Pentagon, Ruler, Funnel, Download, Printer, Bookmark, Sparkles, CircleDot (well), Waypoints (pipeline), TowerControl (rig), Factory (refinery).
- Two runs of this prompt chose different pipeline icons (Route, then Waypoints); both are valid names and both were flagged as weak.
- The code was not rendered or type-checked.

### 2026-10-20 — Lucide icon eval (id 6) after declaring Lucide in the skill
```
Date: 2026-10-20
Model: subagents inheriting the session model (claude-sonnet-5-5)
Skill path: skills/enverus-ux-design-skill (main at a8dc54a plus uncommitted changes)
Eval IDs run: [6]
Results:
  - Eval 6: Pass (6/6) — toolbar icons: states E1 uses Lucide, imports from lucide-react, SearchIcon/SettingsIcon/Share2Icon/Trash2Icon, no custom SVGs, aria-label on every icon-only button, no sizing classes on icons
Overall: 1/1 passed
```
Notes:
- Agent was blind to assertions and to evals/. It read SKILL.md, shadcn/SKILL.md and shadcn/rules/icons.md.
- The icon-to-action mapping was the agent's judgement (the skill gives only Workflow and CircleHelp as examples), and it flagged that the Figma `Lucide Icon / <Name>` layers should be checked.
- The agent also added a Tooltip wrapper and suggested an AlertDialog for Delete; neither is in the skill or in the assertions.

### 2026-10-20 — sidebar evals (ids 3, 5) after adding sidebar.md
```
Date: 2026-10-20
Model: subagents inheriting the session model (claude-sonnet-5-5)
Skill path: skills/enverus-ux-design-skill (main at a8dc54a plus uncommitted sidebar changes)
Eval IDs run: [3, 5]
Results:
  - Eval 3: Pass (9/9) — Flows list page; includes a collapsible shadcn sidebar left of #page-header and #page-body, plus all eight header/body assertions
  - Eval 5: Partial (7/8) — sidebar; everything matched except the PanelLeft control: the toggle was hidden when collapsed, so the rail could not be expanded
    Re-run after sidebar.md fix (see below): Pass (8/8)
Overall: 2/2 pass (eval 5 after one re-run)
```
Notes:
- Agents were blind to assertions and to evals/.
- Eval 3 gained a sidebar assertion on this date. The agent read sidebar.md through the new SKILL.md and page-header.md cross-references.
- Eval 5 fix: sidebar.md now says the PanelLeft toggle must stay visible in both states and lives in a SidebarHeader slot when collapsed. The re-run put it in the Vera row when expanded and in a header slot when collapsed.
- Both agents used a placeholder SVG for the Enverus "E" mark (no brand asset in the repo). Neither run was rendered or type-checked.
- Eval 3's tab panels were empty-state placeholders rather than tables; no assertion covers that.
- The re-run made Spaces non-navigating (aria-disabled) and omitted tooltips. Both are still open questions in sidebar.md.

### 2026-10-19 — current eval set (evals 1-4) on main after PRs #24-#26
```
Date: 2026-10-19
Model: subagents inheriting the session model (claude-sonnet-5-5)
Skill path: skills/enverus-ux-design-skill (main at 3a25e95)
Eval IDs run: [1, 2, 3, 4]
Results:
  - Eval 1: Pass (5/5) — WCAG audit: 1.4.3, 1.4.1 + H9, H5 + confirmation dialog, severities, action list
  - Eval 2: Pass (7/7) — asset detail header: #page-header flex-shrink-0 wrapper, #back-button row, Share left of the single primary, sibling #page-body
  - Eval 3: Pass (8/8) — Flows list page: tabs in a sibling #page-body (flex flex-col flex-1 overflow-hidden), no back button, single primary
  - Eval 4: Pass (5/5) — pending token: checked --info/--muted first, --pending, :root + .dark-theme, OKLCH, missing dark entry = High
Overall: 4/4 passed
```
Notes:
- Agents were blind to assertions and to evals/.
- Confirms the page-body rule, the --input/--sidebar-primary-foreground/warning-badge doc changes and the token-preview fixes did not regress any eval.

### 2026-10-19 — page-header evals (ids 2, 3) after the page-body rule (branch page-body-sibling)
```
Date: 2026-10-19
Model: subagents inheriting the session model (claude-sonnet-5-5)
Skill path: skills/enverus-ux-design-skill (branch page-body-sibling)
Eval IDs run: [2, 3]
Results:
  - Eval 2: Pass (7/7) — #page-header is flex flex-col flex-shrink-0 overflow-hidden; back button row above #page-titles; Share left of the single primary
  - Eval 3: Pass (8/8) — includes the new assertion: tabs in a sibling #page-body (flex flex-col flex-1 overflow-hidden) after #page-header
Overall: 2/2 run passed (evals 1 and 4 not re-run; unaffected by this change)
```
Notes:
- #page-header changed from flex-1 to flex-shrink-0 so a sibling #page-body with flex-1 fills the remaining height.
- Assertions for evals 2 and 3 were updated to the new header classes; eval 3 gained the page-body assertion.

### 2026-10-19 — current eval set (evals 1-4) on main after PR #21
```
Date: 2026-10-19
Model: subagents inheriting the session model (claude-sonnet-5-5)
Skill path: skills/enverus-ux-design-skill
Eval IDs run: [1, 2, 3, 4]
Results:
  - Eval 1: Pass (5/5) — WCAG audit: 1.4.3, 1.4.1 + H9, H5 + confirmation dialog, severities, action list
  - Eval 2: Pass (7/7) — asset detail header: #page-header wrapper, #back-button row above #page-titles (outline, sm, chevron-left, "Back to Library"), Share left of the single primary
  - Eval 3: Pass (7/7) — Flows list page: unified header, no back button, single primary "New Flow", semantic tokens
  - Eval 4: Pass (5/5) — pending token: checked --warning/--info first, --pending, :root + .dark-theme, OKLCH, missing dark entry = High
Overall: 4/4 passed
```
Notes:
- Agents were blind to assertions and to evals/, and loaded the skill from its path under skills/.
- Evals 2 and 3 agents placed the page body as a sibling after `#page-header` (which has `flex-1`); `page-header.md` does not say where the body goes, so this layout would let the header grow to fill the page.

### 2026-10-19 — full run of the previous eval set (evals 1-7) on main after PRs #11 and #15
```
Date: 2026-10-19
Model: subagents inheriting the session model (claude-sonnet-5-5)
Skill path: skills/enverus-ux-design-skill
Eval IDs run: [1, 2, 3, 4, 5, 6, 7]  (previous eval set)
Results:
  - Eval 1: Pass (5/5)
  - Eval 2: Pass (6/6) — #ffffff text rated Critical; contrast reported as a separate High finding. bg-destructive is conditional on the state being an error (neutral muted suggested for "inactive")
  - Eval 3: Pass (6/6)
  - Eval 4: Pass (5/5)
  - Eval 5: Pass (6/6) — default layer names reported as handoff blockers (Critical)
  - Eval 6: Pass (6/6)
  - Eval 7: Pass (6/6) — used hover:bg-accent-brand-light
Overall: 7/7 passed
```
Notes:
- Agents were blind to assertions and to evals/, and loaded the skill from its new path under skills/.
- Confirms the plugin restructure, the token changes and the audit-severity fixes did not regress any eval in that set.

### 2026-10-16 — evals 1-5 (previous eval set)
```
Date: 2026-10-16
Model: subagents inheriting the session model (claude-sonnet-5-5)
Eval IDs run: [1, 2, 3, 4, 5]
Results:
  - Eval 1: Pass (5/5) — 1.4.3, 1.4.1 + H9, H5 + confirmation dialog, severities, action list
  - Eval 2: Partial (5/6) — #22c55e and #ef4444 rated Critical, but hardcoded #ffffff text rated High, not Critical
    Re-run after token-system.md fix (see below): Pass (6/6)
  - Eval 3: Pass (6/6) — extra entry points, steps table, 3+ error states, reused-link case, H1/H3/H5/H9 checklist, a11y notes
  - Eval 4: Pass (5/5) — checked --warning/--info first, --pending name, :root + .dark-theme, OKLCH, missing dark entry = High
  - Eval 5: Partial (5/6) — unnamed layers (Frame 247, Frame 248, Rectangle 12) rated Medium and not called a handoff blocker; naming still recommended
    Re-run after figma-audit.md fix (see below): Pass (6/6)
Overall: 3/5 pass, 2/5 partial, 0 fail (5/5 pass after re-runs of evals 2 and 5)
```
Notes:
- Agents were blind to assertions and to evals/.
- Eval 2 fix: token-system.md now states that hardcoded text colors (e.g. #ffffff) are Critical and that contrast is reported as a separate finding. Re-run rated #ffffff Critical, with WCAG 1.4.3 as a separate High finding.
- Eval 5 fix: figma-audit.md now labels default layer names, detached components and local style overrides as handoff blockers, and the re-run rated the unnamed layers Critical and called them handoff blockers.
- Both partials were severity-calibration misses, not missing findings. Candidates: clarify in token audit guidance that any hardcoded colour (including text) is Critical, and in figma-audit.md that default layer names block handoff.

### 2026-10-16 — page header evals only (previous eval set)
```
Date: 2026-10-16
Model: subagents inheriting the session model (claude-sonnet-5-5)
Eval IDs run: [6, 7]
Results:
  - Eval 6: Pass (6/6 assertions) — plain header; id, classes, h1, description, action group, order and tokens all matched page-header.md
  - Eval 7: Pass (6/6 assertions) — back button above title (outline, sm, chevron-left, "Back to Library"), secondary left of single primary
Overall: 2/2 run passed (evals 1-5 not run in this pass)
```
Notes:
- Agents were blind to assertions and to evals/. Both loaded SKILL.md, then page-header.md.
- Both tasks closely mirror the reference file, so these are regression checks for retrieval and fidelity, not hard generalisation tests.
- Rendered HTML in eval 7 used `hover:bg-primary-light`, which was documented in the skill but not defined in env-one.ui at the time (since changed to `hover:bg-accent-brand-light`, which env-one.ui does define).
