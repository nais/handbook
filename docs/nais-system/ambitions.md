# Ambitions

An ambition is a long-term goal that spans several periods. It describes a desired future state and why we want to reach it. The _how_ is defined and discussed in individual [initiatives](initiatives.md) that contribute to the ambition over time.

Ambitions are not timeboxed and they rarely merge – they stay open until the ambition is reached or abandoned.

## Where ambitions live

Like initiatives, ambitions are Pull Requests in [`nais/system`](https://github.com/nais/system). An ambition PR is placed under the primary area's directory. If an ambition genuinely spans several areas (as most do), it carries multiple `area:*` labels, but the file itself has one home.

Ambitions use the `type:ambition` label. They do not carry a `size:*` label.

## Ownership

Ambitions follow the same ownership rules as initiatives. The person who opens the PR is the initiator; the anchor of the primary area is involved via `CODEOWNERS`; anchors of other affected areas are mentioned manually.

## Anatomy

An ambition's markdown file follows this structure.

### Essence

Two to four sentences that explain what the ambition is and why it exists. This should stand alone as the answer to "what is this about?" when someone links here from an initiative, a pitch, or a Slack thread.

### Desired state

A description of the world as it should look when the ambition is reached. Write about the outcome, not the tasks that get us there.

Keep this at a level that is stable across several periods. If it reads like a plan or a task list, it probably belongs in an initiative instead.

### Why

What problem does this solve? What value does it bring – for our users, for the team, for the platform?

A short reference to relevant [NAIS properties](properties.md) is often worthwhile.

### Goals

Concrete, observable things we want to achieve. Stable enough to hold across several periods, but precise enough that we can say "yes, we've reached this".

- …
- …

### Non-goals

Things one might read into the ambition but that we deliberately leave out, with short explanations.

- …

### Direction

A rough sketch of the path forward – not a plan or list of initiatives. Things that can go here:

- Milestones or phases on the way to the goal
- Hypotheses we want to test along the way
- Larger choices that are open or already settled
- Dependencies on other ambitions or external factors

The _how_ lives in the [initiatives](initiatives.md) that contribute – don't repeat them here.

### Background and references

Links to relevant context: earlier discussions, external resources, diagrams, related ambitions.

### Linked initiatives

```markdown
<!-- agent:linked-initiatives:begin -->
(Generated – do not edit manually)
<!-- agent:linked-initiatives:end -->
```

The section above is generated from the initiative PRs that carry a `Contributes to: #<ambition-number>` line. These cross-references also appear automatically in the ambition's PR timeline.

## Contributing initiatives

An initiative that contributes to an ambition includes the line

```
Contributes to: #<ambition-PR-number>
```

in its PR body. This creates a cross-reference in the ambition's timeline and feeds the generated "Linked initiatives" section above.
