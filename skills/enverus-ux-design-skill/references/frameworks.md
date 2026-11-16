# UX Frameworks Reference
Core design frameworks applied across all UX work in this skill.

> **How to apply these frameworks:**
> - Use **Nielsen's Heuristics** for general design reviews and interaction audits.
> - Use **WCAG 2.2 AA** for accessibility-specific audits and compliance checks.
> - Use **Cognitive Load Theory** for onboarding flows, complex forms, and information-dense interfaces.
> - **Framework priority:** WCAG violations take precedence in all audit reports. Nielsen and CLT findings are ranked by the shared severity scale below.

---

## Severity Scale
Applies to all findings across all three frameworks.

| Level | Definition |
|-------|------------|
| **Critical** | Blocks task completion |
| **High** | Causes significant friction or confusion |
| **Medium** | Noticeable issue; workaround exists |
| **Low** | Minor polish or consistency issue |

---

## Audit Finding Format
Use this structure for all reported findings, regardless of source framework.

```
Framework:      [Nielsen | WCAG | CLT]
Criterion:      [Heuristic name, WCAG ID, or CLT principle]
Severity:       [Critical | High | Medium | Low]
Location:       [Component, screen, or interaction point]
Observation:    [What was found]
Recommendation: [Specific corrective action]
```

---

## Nielsen's 10 Usability Heuristics
Use these as the evaluation vocabulary for all design reviews and interaction audits.

| # | Heuristic | Key Question |
|---|-----------|--------------|
| 1 | **Visibility of system status** | Does the user always know what's happening? |
| 2 | **Match between system and real world** | Does the system speak the user's language? |
| 3 | **User control and freedom** | Can users undo, redo, and exit easily? |
| 4 | **Consistency and standards** | Are conventions followed throughout? |
| 5 | **Error prevention** | Does the design prevent problems before they occur? |
| 6 | **Recognition over recall** | Are options visible rather than memorized? |
| 7 | **Flexibility and efficiency of use** | Can experts shortcut; beginners still succeed? |
| 8 | **Aesthetic and minimalist design** | Is every element earning its place? |
| 9 | **Help users recognize, diagnose, recover from errors** | Are errors plain-language and actionable? |
| 10 | **Help and documentation** | Is support findable when needed? |

---

## WCAG 2.2 AA — Core Criteria
> **Note:** This reference targets WCAG 2.2 AA (published October 2023), which supersedes 2.1. All 2.1 AA criteria are preserved; 2.2 adds new criteria marked **[2.2]**.

### Perceivable
- 1.1.1 Non-text content has a text alternative
- 1.3.1 Info and relationships conveyed through presentation are programmatically determinable
- 1.4.1 Color is not the only visual means of conveying information
- 1.4.3 Text contrast ratio ≥ 4.5:1 (normal text), ≥ 3:1 (large text)
- 1.4.4 Text can be resized up to 200% without loss of content
- 1.4.11 Non-text UI components contrast ratio ≥ 3:1

### Operable
- 2.1.1 All functionality operable by keyboard
- 2.4.3 Focus order is logical and meaningful
- 2.4.6 Headings and labels are descriptive
- 2.4.7 Keyboard focus is visible
- 2.4.11 **[2.2]** Focus appearance — focus indicator meets minimum size and contrast requirements
- 2.5.3 Label in Name — visible label text is included in the accessible name
- 2.5.7 **[2.2]** Dragging Movements — all functionality that uses a dragging motion can be achieved with a single pointer without dragging (except where dragging is essential)
- 2.5.8 **[2.2]** Target Size (Minimum) — interactive targets are at least 24×24 CSS pixels

### Understandable
- 3.1.1 Language of page is programmatically determinable
- 3.2.1 Focus does not trigger unexpected context changes
- 3.2.6 **[2.2]** Consistent Help — help mechanisms appear in consistent location across pages
- 3.3.1 Errors are identified and described in text
- 3.3.2 Labels or instructions provided for user input
- 3.3.7 **[2.2]** Redundant Entry — information already provided is not re-requested in the same session
- 3.3.8 **[2.2]** Accessible Authentication — cognitive function tests not required unless alternative is provided

### Robust
- 4.1.2 Name, role, value — all UI components have accessible properties
- 4.1.3 Status messages are programmatically determinable

### Quick contrast check targets
| Element | Minimum ratio |
|---------|---------------|
| Body text on background | ≥ 4.5:1 |
| Large text (18pt+, or 14pt bold+) | ≥ 3:1 |
| UI components and icons | ≥ 3:1 |
| Focus indicators (2.4.11) | ≥ 3:1 against adjacent colors |
| Decorative elements | Exempt |

---

## Cognitive Load Theory
Design interfaces that **minimize user mental effort** so tasks are easy to understand and complete.

### Principles
- **Focus on the main task** — design around the user's primary goal.
- **Remove unnecessary elements** — eliminate clutter and redundant information.
- **Chunk information** — group related content into clear sections.
- **Use progressive disclosure** — reveal complexity only when needed.
- **Support recognition** — show options instead of requiring memory.
- **Create clear hierarchy** — highlight important information and primary actions.
- **Limit choices** — avoid overwhelming users with too many options (Hick's Law).

### Rules
- Prioritize clarity and simplicity.
- Reduce unnecessary cognitive effort.
- Guide users toward the next action.

### When to flag a CLT issue
Raise a CLT finding when:
- A screen presents more than ~5–7 unrelated elements without visual grouping.
- A user must remember information from a previous step to complete the current one.
- The primary action is not visually dominant or immediately obvious.
- An interaction requires reading instructions before the task intent is clear.
- Choices are presented without defaults, recommendations, or progressive filtering.

**Report using:** Framework: CLT → Criterion: [relevant principle] → Severity → Location → Observation → Recommendation.

---