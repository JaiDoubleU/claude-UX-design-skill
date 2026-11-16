# Eval scaffold

A ready-to-build Vite + React 19 + TypeScript + Tailwind v4 + shadcn/ui (radix-nova) project used as
the starting point for blind eval runs, so each run spends its time on the page and not on setup.

Create a run from it with `evals/scripts/new-run.sh <destination-dir>`. Do not build inside this
folder.

## What is set up for the agent

- Vite, React, TypeScript, Tailwind v4 and the `@` alias, with `npm run build` working.
- `src/index.css` imports `tokens.css`, maps the tokens into Tailwind (`@theme inline`) and keys the
  `dark` variant to `.dark-theme`. `tokens.css` itself is not stored here: the script copies it from
  the skill, so it is always the current source of truth.
- Roboto Flex is installed and set as the sans font.
- shadcn components already added (radix-nova): alert, alert-dialog, avatar, badge, button, card,
  checkbox, dialog, dropdown-menu, empty, field, input, label, scroll-area, select, separator, sheet,
  sidebar, skeleton, sonner, table, textarea, toggle, toggle-group, tooltip.
- `@/lib/utils` (`cn`) and `use-mobile`.
- `src/App.tsx` is a placeholder for the agent to replace.

## Deliberately left as shadcn generates it

These are the things the skill docs tell the agent to fix, so the evals still test them:

- `ui/table.tsx` still has the `overflow-x-auto` wrapper and `[&:has([role=checkbox])]:pr-0`.
- `ui/button.tsx` has no `primary` variant.
- `ui/sonner.tsx` still uses `next-themes`.
- `src/index.css` has no `color-scheme` rule: the agent must add it (see `token-system.md`, Color scheme).
- `src/index.css` has no `html { font-size: 14px }` rule and no px re-base of Tailwind's scale: the agent must add both (see `token-system.md`, Root font size).
- No navbar, sidebar, page header or brand assets: the agent builds these from the skill, using the
  wordmark and logo mark SVGs under `references/enverus-one/assets/`.

## Fixed from the CLI output

The CLI writes `import { cn } from "cn"` (an unrelated npm package). It is repointed to
`@/lib/utils` and the `cn` package is removed.

## Updating it

Add components with `npx shadcn@latest add <name> -o -y` inside a copy, then repeat the `cn` import fix,
and copy the result back (without `node_modules` or `dist`). Keep `package-lock.json` in step so
`npm ci` works. Check it with `evals/scripts/new-run.sh /tmp/x` then `npm run build` in `/tmp/x`.
