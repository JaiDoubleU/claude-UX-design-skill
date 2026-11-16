# Figma Audit & Design Review

Process and checklist for conducting structured Figma audits and design reviews.

---

## Audit Process

**Step 1: Scope the audit**
- Identify what's being reviewed: single screen, flow, component library, full product
- Confirm the target user and primary tasks
- Note the fidelity level (wireframe / mid-fi / high-fi / production-ready)

**Step 2: First pass — gestalt**
- Review without zooming in first
- Note: visual hierarchy, scanning pattern, density, overall consistency
- Flag anything that "feels off" before rationalizing why

**Step 3: Structured checklist pass**
- Work through the checklist below systematically
- Log findings as you go with: location, heuristic/criterion, severity, recommendation

**Step 4: Prioritize and report**
- Cluster findings by theme
- Rank by severity (Critical → Low)
- Write the report using the output format below

---

## Audit Checklist

### Visual Hierarchy & Layout
- [ ] Clear primary action on each screen
- [ ] Heading levels create scannable structure
- [ ] Spacing is consistent with token system (not arbitrary px values)
- [ ] Grid alignment is maintained
- [ ] Visual weight guides the eye in the intended order

### Consistency (Heuristic 4)
- [ ] Component usage matches the design system (no one-offs)
- [ ] Color usage follows semantic token rules
- [ ] Typography uses defined type styles, not custom overrides
- [ ] Icon set is consistent (same family, same size grid)
- [ ] Interaction patterns are consistent across similar elements

### Accessibility (WCAG 2.2 AA)
- [ ] All text meets contrast ratio requirements (4.5:1 normal, 3:1 large)
- [ ] UI components meet 3:1 contrast (borders, icons, states)
- [ ] Focus states are visible on all interactive elements
- [ ] Color is not the sole differentiator of information
- [ ] Form fields have associated labels (not placeholder-only)
- [ ] Error states include text, not just color
- [ ] Touch targets ≥ 44×44px (mobile), ≥ 24×24px (desktop)

### Feedback & Status (Heuristic 1)
- [ ] Loading states are designed
- [ ] Empty states are designed
- [ ] Success/confirmation states are designed
- [ ] Error states are designed with recovery path

### Error Prevention & Recovery (Heuristics 5 & 9)
- [ ] Destructive actions require confirmation
- [ ] Forms validate inline before submission
- [ ] Error messages are plain language and actionable
- [ ] Undo is available where expected

### Navigation & Wayfinding (Heuristic 6)
- [ ] User always knows where they are
- [ ] Back/exit paths are clear
- [ ] Breadcrumbs or context indicators present in deep flows

### Content & Language (Heuristic 2)
- [ ] Labels match user mental models (not internal jargon)
- [ ] CTAs are specific and action-oriented
- [ ] Microcopy is consistent in tone and tense

### Figma File Health (if auditing the file itself)
- [ ] Layers are named (no "Frame 247" in handoff files) → **handoff blocker**
- [ ] Components are linked to library, not detached
- [ ] Auto layout used on all responsive components
- [ ] Variants cover all states (default, hover, active, disabled, error, focus)
- [ ] Text styles and color styles applied, not hardcoded
- [ ] Hidden layers cleaned up

**Severity for file-health findings**
- **Handoff blockers** — flag these explicitly as blocking handoff: default layer names (`Frame 247`, `Rectangle 12`, `Button Copy 2`), detached components, and text/color styles applied as local overrides. Developers can't map layers to components or tokens until they are fixed.
- **Cleanup** — hidden layers from old iterations, missing auto layout, incomplete variant coverage.
- Name each blocker by its layer (e.g. "Frame 247, Frame 248, Rectangle 12") and recommend a naming scheme such as `atom/…`, `molecule/…`, `organism/…`.

---

## Audit Report Output Format

```
## UX Audit: [Screen/Flow Name]
**Date:** [date]
**Reviewer:** Claude (UX Design Skill)
**Scope:** [what was reviewed]

---

### Critical Findings
1. **[Issue title]**
   - Location: [screen/component]
   - Heuristic/Criterion: [e.g., WCAG 1.4.3 / Heuristic 5]
   - Problem: [specific description]
   - Recommendation: [specific fix]

### High Findings
[same format]

### Medium Findings
[same format]

### Low Findings
[same format]

---

### Prioritized Action List
**This week:** [Critical items]
**This sprint:** [High items]
**Backlog:** [Medium/Low items]

---

### What's Working Well
[2-3 specific positives — don't skip this]
```
