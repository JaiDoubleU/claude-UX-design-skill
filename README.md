# Claude UX Design Skill

A Claude Code skill for UX design work — design audits, component spec writing, token system audits, and user flow/IA documentation. At the moment it's specific to the design system (shadcn/ui + Tailwind CSS + OKLCH tokens) but support can be added for other design systems by adding them under references.

## What this skill does

- Design audits and UX reviews mapped to Nielsen's 10 Heuristics and WCAG 2.2 AA
- Component spec documentation for design system handoff
- Token audit logic for the design system
- User flow and information architecture documentation

## Installing in Claude Code

There are two ways to add this skill depending on your setup.

The options below are one-time copies — you won't see future changes to this repo unless you re-copy it by hand. This repo is packaged as a Claude Code plugin, so installing it as a marketplace source (this option) has Claude Code pull updates for you.

**Via settings.json** (works in any environment, including ones where `/plugin` isn't available — e.g. Claude Code on the web):

Add this to `~/.claude/settings.json` (just for you) or your project's `.claude/settings.json` (shared with your team via git):

```json
{
  "extraKnownMarketplaces": {
    "Claude-ux-design": {
      "source": {
        "source": "github",
        "repo": "jaidoubleu/claude-ux-design-skill"
      },
      "autoUpdate": true
    }
  }
}
```

Restart Claude Code (or start a new session) after saving.

**Staying up to date:** `"autoUpdate": true` above makes Claude Code pull the latest version of this marketplace — and the plugin installed from it — automatically each time it starts, once changes here are merged to `main`. To force a refresh without waiting for the next session start:

### Option A — Global skill (available in all projects)

Clone the repo, then copy the skill folder (`skills/claude-ux-design-skill`, the one that contains `SKILL.md`) into your global Claude skills directory:

```bash
git clone git@github.com:jaidoubleu/claude-ux-design-skill.git
cp -r Claude-ux-design-skill/skills/claude-ux-design-skill ~/.claude/skills/claude-ux-design-skill
```

Claude Code auto-discovers skills in `~/.claude/skills/` by reading each folder's `SKILL.md`.

### Option B — Project-local skill

From your clone of this repo, copy the skill folder (`skills/claude-ux-design-skill`) into a `skills/` directory at your project root, then register it in your project's `CLAUDE.md`:

```bash
mkdir -p my-project/skills
cp -r Claude-ux-design-skill/skills/claude-ux-design-skill my-project/skills/
```

In `my-project/.claude/CLAUDE.md`, add:

```markdown
## Skills
- `skills/claude-ux-design-skill` — UX design audits, component specs, token audits
```

### Verifying the install

In any Claude Code session, run:

```
/skills
```

You should see `Claude-ux-design-skill` listed. If not, confirm the folder path contains a `SKILL.md` with `name: Claude-ux-design-skill` in its frontmatter.

## Using the skill

Invoke by mentioning any of the trigger areas from `SKILL.md`:

```
Audit this screen for WCAG and heuristic issues.

Write a component spec for the filter dropdown.

Audit thi component for token leakage and dark mode compliance.

Map the password reset flow with error states and edge cases.

How do I add a new semantic token to this design system?
```

The skill routes to the right reference files automatically based on what you're asking for. You don't need to name a specific file or reference the skill explicitly — it triggers from task type.

### How routing works

When invoked, the skill reads the reference files relevant to the task (all paths below are relative to the skill root, `skills/claude-ux-design-skill/`):

| Task type | Files read |
|-----------|-----------|
| Figma audit / design review | `references/figma-audit.md` + `references/frameworks.md` |
| Component spec | `references/component-specs.md` |
| Token audit | `references/enverus-one/token-system.md` + `references/enverus-one/token-reference.md` + `references/enverus-one/tokens.css` |
| shadcn/ui component work | `references/enverus-one/shadcn/SKILL.md` |
| Trace component (tool calls, reasoning, sources, plans) | `references/enverus-one/components/trace.md` + `references/enverus-one/components/trace.tsx` |
| Building or laying out a page, page header or full page | `references/enverus-one/rules/page-layout.md` (start here) + `references/enverus-one/page-header.md` + `references/enverus-one/navbar.md` + `references/enverus-one/sidebar.md` |
| List of records as a table or cards (toolbar, filters, columns/sort, view toggle, select and actions columns, pagination) | `references/enverus-one/list-layout.md` |
| Sidebar only / primary navigation | `references/enverus-one/sidebar.md` |
| Top navbar only (wordmark, theme toggle, avatar) | `references/enverus-one/navbar.md` |
| Choosing or validating an icon | `references/enverus-one/lucide-icons.md` |
| User flow / IA | `references/user-flow-ia.md` |
| Multi-domain or ambiguous | `references/frameworks.md` first, then task-specific files |

Files are read on-demand — nothing is pre-loaded automatically.

## Token system

| Cue | Means |
|-----|-------|
| Unprefixed CSS variables: `--background`, `--primary` | Enverus One |
| Dark mode via `.dark-theme` on `<html>` | Enverus One |
| Imports from `@/components/ui/*` or `env-one.ui` | Enverus One |
| OKLCH color values | Enverus One |
| `--env-*` prefixed variables | **Not Enverus One** — different system |

## File overview

```
.claude-plugin/
  plugin.json                         — Plugin manifest (name, version, author)
ABOUT.md                              — One-page summary for consumers
evals/
  evals.json                          — Eval prompts and assertions for testing the skill
  benchmark.md                        — Benchmark results log
skills/
  Claude-ux-design-skill/
    SKILL.md                          — Skill manifest (triggers, routing, output standards)
    references/
      frameworks.md                   — Nielsen heuristics, WCAG 2.2 AA, CLT — severity scale and finding format
      figma-audit.md                  — Figma audit process, checklist, report template
      component-specs.md              — Component spec template and writing rules
      user-flow-ia.md                 — Flow templates, IA conventions, audit checklist
      token-preview.html              — Live visual preview of Enverus One tokens (light/dark toggle)
      enverus-one/
        token-system.md               — Token architecture, naming rules, audit checklist
        token-reference.md            — Semantic usage intent, do/don't pairs, WCAG contrast notes
        tokens.css                    — Authoritative CSS variables (source of truth for values)
        rules/
          page-layout.md              — Full page shell: navbar, sidebar, page header, page body, scroll and gutter rules
        page-header.md                — Standard page header: title, description, optional back button and actions
        sidebar.md                    — Primary navigation sidebar: expanded and collapsed variants, items, tokens
        navbar.md                     — Top navbar: wordmark, theme toggle, avatar, tokens
        list-layout.md                — List page body: table/card views, toolbar, select and actions columns, scroll behavior, pagination
        lucide-icons.md               — Every valid lucide-react icon name (v0.542.0), how to import it, and icon sizing rules
        assets/
          enverus-logo-mark.svg       — Enverus "E" logo mark (currentColor letterform, fixed brand greens)
          enverus-one-wordmark.svg    — Enverus ONE wordmark (currentColor lettering, fixed brand greens)
        components/
          trace.md                    — Trace component spec: anatomy, variants, states, accessibility, props, E1 adaptations (draft)
          trace.tsx                   — E1 adaptation of the shadcn/ui Trace component (tool calls, reasoning, sources, plans)
        shadcn/
          SKILL.md                    — Official shadcn/ui skill: CLI commands, component search, composition rules
          cli.md, registry.md, mcp.md — shadcn CLI, registries and MCP reference
          customization.md            — Theming and customization
          design-system.md            — Design system reference
          design-system-page.md       — Design system page reference
          rules/                      — Composition, forms, icons, styling, chat and base-vs-radix rules
          evals/evals.json            — Evals for the shadcn skill
          agents/openai.yml           — Agent metadata
          assets/, scripts/           — Showcase components and the coverage script
```

## Keeping tokens up to date

`skills/enverus-ux-design-skill/references/enverus-one/tokens.css` is a snapshot of the token system at a point in time. When the Enverus One token system changes (new tokens, value updates), update this file from the source:

```
packages/ui/src/css/shadcn-tokens.css in the env-one.ui repo
```

Copy the updated `:root` and `.dark-theme` blocks into `tokens.css`.

## Contact

For questions about this skill, contact Jason Shannon.
