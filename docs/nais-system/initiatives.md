# Initiative

An initiative describes a piece of planned work – what it is, why we should do it, and how we envision solving it. Initiatives are the primary unit of work in a focus period.

An initiative may stand on its own, or contribute to a larger [ambition](ambitions.md).

Anyone in the team who has a good idea, or recognises something that needs doing, is expected to write initiatives.

## Where initiatives live

Every initiative is a Pull Request in [`nais/system`](https://github.com/nais/system). The PR body contains the markdown file that describes the initiative, placed under the primary area's directory (e.g. `persistence/<slug>/README.md`).

The PR is not a "request to merge code" in the usual sense. It is the initiative itself – a living document. The state of the PR reflects the state of the initiative:

| PR state | What it means |
|---|---|
| Draft | Shaping – the initiative is being formed, not yet ready for broad discussion |
| Open, not draft, no milestone | Ready for discussion and available for selection |
| Open, not draft, with milestone | Selected for that period; being worked on |
| Merged | Completed |
| Closed without merging | Abandoned. The last comment explains why. |

Labels classify the initiative without driving its lifecycle: `type:initiative`, one or more `area:*`, and a `size:*` (see below).

## Ownership

The **initiator** – the person who opens the PR – owns the initiative. They drive the shaping, involve the right people, and answer questions.

The **anchor** for each area the initiative touches is involved when their area is affected. `CODEOWNERS` in `nais/system` automatically requests a review from the anchor of the primary area. Anchors of secondary areas are mentioned manually when their input matters.

Anchors are not initiative owners by default – they are area stewards who make sure the area is well taken care of.

## Anatomy

An initiative's markdown file has these sections.

### Essence

The core idea and purpose. This should be clear and concise, and ensures you have a solid understanding of the problem. It also helps the working group make scoping decisions later.

### Non-goals

Rabbit holes and critical paths you explicitly don't want to go down. Each non-goal has a short explanation.

### Possible solution

A sketch of how we imagine solving this. Not a full spec – just enough detail to show that a path to success exists.

Working through this is where you detect obvious showstoppers and new rabbit holes (which then become non-goals). It also surfaces the technical and human impact: what components are introduced or removed, what dependencies change, what new responsibilities we take on.

If the solution impacts or involves parts of NAIS beyond the primary area, make sure the relevant people – especially the anchors – are involved in the shaping.

Rough sketches help. The working group is free to deviate from the possible solution as long as the essence is preserved.

### Size

Initiatives are labeled with a size: `size:s`, `size:m`, or `size:l`. Size signals how much time we feel is reasonable to spend on the initiative given the current information. It is a rough estimate of the effort required to deliver the essence, and is used for planning and prioritization. If we find out later that the initiative is bigger than we thought, we can re-evaluate and adjust the size or scope.

| Label | Upper bound | Typical shaping |
|---|---|---|
| `size:s` | 1-3 days | Light: essence + possible solution may be enough |
| `size:m` | ≈1-2 weeks | Full anatomy |
| `size:l` | 3-6 weeks | Full anatomy with explicit non-goals |

An initiative without a size label is still in draft. Before a PR leaves draft, the initiator assigns a size.

We do not use an XL size. If an initiative feels bigger than L, it should be broken down, or re-expressed as an [ambition](ambitions.md) with smaller initiatives contributing to it.

### Other relevant information

Anything else the working group might need: links, images, sketches, related initiatives.

## Shaping

Shaping happens while the PR is in draft. The initiator involves relevant anchors by mentioning them or requesting review. When the initiative is clear enough for broad discussion, the initiator marks the PR ready for review. A PR can always be re-drafted if you want to pull it back.

There is no separate "RFC" state – ready-for-review is the state for discussion.

## Contributing to an ambition

If an initiative contributes to an ambition, include the line

```
Contributes to: #<ambition-PR-number>
```

in the PR body. GitHub then shows the initiative as a cross-reference in the ambition's timeline.

## Working on an initiative

Once an initiative is selected for a period, the milestone is set on its PR and assignees are added. The working group meets, talks through the initiative, and makes a plan.

Things to consider:

- Will any key people be unavailable during the focus period?
- Are there other active initiatives we should coordinate with?

Progress is logged as commits to the PR and comments on it. A running `## Status` section in the markdown file is a good way to make progress visible.

It's good practice to check, now and then, whether you're on track to deliver the essence within the allotted size. If you finish early, great – move on. If more time is needed, narrow the scope if you can. If there's no meaningful way to reduce scope, re-evaluate the initiative before continuing.
