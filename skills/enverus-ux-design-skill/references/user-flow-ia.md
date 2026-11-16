# User Flow & Information Architecture

Standards for designing, documenting, and evaluating user flows and IA structures.

---

## User Flow Documentation Standard

### Flow anatomy
Every flow must document these elements:

```
Entry point(s) → Steps → Decision nodes → Outcomes → Error states → Exit points
```

### Flow template

```
## Flow: [Flow Name]

### Overview
**User goal:** What is the user trying to accomplish?
**Entry points:** Where can users enter this flow? (list all)
**Success outcome:** What does success look like?
**Failure outcomes:** What are the failure states?

---

### Steps

| Step | Screen/State | User action | System response | Decision? |
|------|-------------|-------------|----------------|-----------|
| 1 | [screen name] | [what user does] | [what system does] | No |
| 2 | [screen name] | [what user does] | [what system does] | Yes → [branch] |

### Decision branches
For each Yes in the steps table:
- **If [condition]:** → [next step or outcome]
- **If [condition]:** → [next step or outcome]

### Error states
| Error | Trigger | Recovery path |
|-------|---------|---------------|
| [error name] | [what causes it] | [how user recovers] |

### Edge cases
- [Scenario]: [how the flow handles it]

---

### Heuristic check
- [ ] H1: User knows where they are at every step
- [ ] H3: Exit/cancel is available at every step
- [ ] H5: Destructive actions are confirmed
- [ ] H9: Error messages explain what happened and what to do next

### Accessibility check
- [ ] Flow is completable by keyboard only
- [ ] All steps are reachable via screen reader in logical order
- [ ] No step relies on color alone to communicate status
- [ ] Timeout warnings give user sufficient time to respond
```

---

## IA Principles

### Card sorting outputs
When working from card sort or tree test data, organize IA around:
1. **User mental models** — not internal org structure
2. **Task frequency** — most-used items at top or shortest path
3. **Mutually exclusive categories** — items should have one obvious home

### Navigation depth rule
- **Optimal:** 3 levels max (L1 → L2 → L3)
- **Acceptable:** 4 levels with clear wayfinding
- **Problem:** 5+ levels; flatten or restructure

### Naming conventions for IA
| ✅ User-facing language | ❌ Internal jargon |
|------------------------|-------------------|
| Account settings | User management |
| Your orders | Order management system |
| Help | Support ticket portal |
| Billing | Invoice administration |

### IA documentation format

```
## Site/App Structure: [Product Name]

### L1 Navigation
- [Section name] → [Purpose]
- [Section name] → [Purpose]

### L2 Structure: [Section]
- [Page name] — [User goal this serves]
  - [Sub-page] — [when/why user goes here]
  - [Sub-page] — [when/why user goes here]

### Cross-cutting patterns
- [Global elements: search, notifications, user menu]
- [Contextual navigation patterns]

### Wayfinding
- How does user know where they are?
- How do they get back?
- What breadcrumbs or context indicators exist?
```

---

## Flow Audit Checklist

Use when reviewing an existing flow:

**Completeness**
- [ ] All entry points are mapped
- [ ] All decision branches are documented
- [ ] All error states have a recovery path
- [ ] Success confirmation is designed

**Usability (Heuristics)**
- [ ] User has clear status feedback at every step (H1)
- [ ] Language matches user mental model, not system model (H2)
- [ ] Cancel/back exists at every step (H3)
- [ ] Similar steps behave consistently (H4)
- [ ] Errors are prevented where possible (H5)
- [ ] User doesn't have to remember info from previous steps (H6)

**Accessibility**
- [ ] Flow completable without a mouse
- [ ] No timed steps without user override option (WCAG 2.2.1)
- [ ] No content that flashes >3 times/second (WCAG 2.3.1)
- [ ] Session timeout warned with ability to extend (WCAG 2.2.1)

**Efficiency**
- [ ] Minimum steps to reach primary outcome
- [ ] No redundant confirmation screens
- [ ] Smart defaults reduce user input burden
- [ ] Progress is saved where the flow spans multiple sessions

---

## Common Flow Problems

| Problem | Symptom | Fix |
|---------|---------|-----|
| Dead ends | Flow ends with no clear next action | Add explicit exit or next-step CTA |
| Orphan states | Error state with no recovery | Add recovery path and back option |
| Asymmetric flows | Can do action but can't undo | Design the reverse flow |
| Premature commitment | Irreversible action with no warning | Add confirmation + undo window |
| Missing empty state | First-use flow jumps into content that doesn't exist yet | Design empty states for all content areas |
