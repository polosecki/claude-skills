---
name: "sealed-work"
description: "Run high-stakes work through the full eight-role verification structure before it is published, sealed, or relied on by people who cannot check it. Adds intent, liveness, provenance and adversary roles to the basic implementer/auditor/decider trio."
---

# Sealed work — the full eight-role structure

For work that will be **published, sealed, or relied on by people who cannot check it**. It is heavy
machinery. Use `checked-work` for anything less; use nothing at all for exploratory work.

Every role below maps to a failure mode you can name. **A role that cannot be described in terms of what it
would have caught is overhead pretending to be rigour.** Drop any role whose failure mode does not apply.

---

## The one design principle

> **Roles must differ in what they can SEE or in what they are ASKED. A role that differs only in its label
> produces agreement, not verification.**

Independence comes from four axes, and every role sits somewhere on them:

| axis | what varies |
|---|---|
| **access** | can it run compute? see artifacts? see the other agents' prose? |
| **question** | is it asked to *review*, or to *falsify*? |
| **frame** | does it start from the task, or from someone's interpretation of it? |
| **time** | is it comparing to what was promised *before*, or what exists *now*? |

---

## Wiring

**You are the COORDINATOR. You do not implement and you do not adjudicate.**

```
task ──▶ IMPLEMENTER ──ledger + artifacts──▶ CLAIMS · INTENT · LIVENESS
                                                    │  (parallel; none sees the implementer's prose,
                                                    │   and none sees the others')
                                              conflict? ──▶ DECIDER
                                                    │
                                    factual / scope / resource / value
                                                    │
                                              ARCHIVIST (provenance, gates, seal)
                                                    │
                                     ADVERSARY — before any seal
                                                    ▼
                                              you ──▶ human
```

**The auditors run in parallel and independently.** Chained, later ones inherit earlier framing — which is
the failure the whole design exists to avoid. Each receives the task statement and artifact paths only.

**The decider may be a sibling but never the implementer or its parent** — otherwise self-adjudication
returns through the back door. It is **mandatory whenever the human is unreachable**; without it the
escalation queue becomes a dumping ground and throughput collapses to the human's waking hours.

---

## The roles

### Implementer
Builds, runs, produces artifacts, fills the ledger. Sees everything. Catches nothing by itself — its
discipline is making itself checkable.
**Hard rule: may not report a number it cannot point to a file for.**

### Claims auditor — *is each number true?*
Sees the task and the artifact paths. **Never the implementer's prose.** Re-derives every row by running its
own commands. Verdicts `PASS` / `FAIL` / **`UNEVIDENCED`** — the last is a fail, not "probably fine". Must
state what would falsify each row *before* looking.

### Intent auditor — *is this the thing that was asked, and only that?*
Sees the task and the **diff**, not the rationale, because the rationale is what is being checked. Maps
clauses to artifacts **in both directions**: every clause needs an artifact or an explicit NOT-DONE with a
reason, **and every artifact needs an authorising clause** — anything unmapped is over-delivery by
definition, invisible to a clause-only check. Flags silent reinterpretation: legitimate, but logged as a
deviation, never absorbed.

*A number can be true and the wrong thing to have computed; a build can be faithful to the task and report
false numbers. These are different audits.*

### Liveness auditor — *does the machine actually run?*
**The role most likely to be omitted and most likely to pay for itself.** For every mechanism the design
claims: is it exercised end to end — flag set → guarded path executed → parameter changes → output changes
when disabled? Requires compute. Instrumented runs, not code reading.

**Build the disable test by in-place perturbation, not by reconfigure-and-refit.** Set the value on the
*already-built* system and re-observe. Changing a config flag changes more than one thing, and a test meant
to isolate mechanism A can end up measuring mechanism B. Perturbation is also the stronger claim: "it stayed
at zero" shows it *did not* matter; "forcing it to an arbitrary value changes nothing" shows it *could not
have*.

**Two levels, and the second is the one that gets missed:** (1) *can* the mechanism work; (2) **does the
caller actually ask it to?** A gate testing only level 1 is blind to a correct component that nothing invokes.

### Archivist — *can someone else find, trust and reproduce this in a year?*
Version tags; which results supersede which; artifacts where the ledger says they are; seals recording what
changed and why; standing instructions from the human written to a file the moment they are given.

**Owns the gates below.** Its rules are worthless as prose — see §Enforcement.

### Narrator — *what would someone who has been away all day need to know?*
Plain English. What changed, what it means, what is decided, and **what needs a decision, stated as a
decision**. No jargon; no development history unless it changes what to do; **never a recommendation without
the fact that would overturn it**; never reassurance. If the honest summary is "the result got worse", that
is the summary. Length is a constraint: a summary nobody reads has failed.

### Adversary — *is the current consensus wrong, including the task itself?*
Sees the artifacts and the claims. **Not** the accumulated reasoning, and **not** spawned by the implementer.
Runs before a seal, before a publication claim, and whenever a result is surprising in a *convenient*
direction. Distinct from the auditors: they check *against* the task; this asks whether the task, the
framing, or the agreed story is right. Frame-level errors are usually the expensive ones and are on nobody's
checklist by construction.

### Decider — *given accounts that disagree, what does the evidence support?*
Sees **both** accounts and the artifacts. Triage:

| kind | question | resolution |
|---|---|---|
| **factual** | what does the code/data do? | a measurement. Someone is right. |
| **scope** | is this inside what was asked? | read the task. Silence is itself a finding. |
| **resource** | is another run or check worth it? | the decider, within budget. |
| **value** | what do we claim? is this limitation acceptable? | **escalate.** |

The separating test: **does this change what we believe or claim, or only what we spend?** Spending to raise
certainty is autonomous; creating or altering a claim is not.

Bound by: **re-derive before ruling** · burden of proof sits with the universal claim ("impossible",
"complete", "nothing else is affected" — one counterexample defeats them) · **may not overrule an
evidence-based FAIL**, only decide what to do about it · **adjudicates whoever wrote the brief on equal
terms** · every ruling recorded with what would reverse it · **first act on a bundled question is to split it
by kind and escalate only the value residue.**

---

## The ledger

| claim | value | artifact (path) | structural check | verdict |
|---|---|---|---|---|

**artifact** = a file an auditor can open. **structural check** = what proves the number is what it says: a
count identity, a control that must be exactly zero, a positive control that must fire. Prose surrounds the
ledger; it is never the evidence.

---

## Cross-cutting rules

1. **Every quantitative claim ships with the artifact, the denominator, and a structural check.** A rate
   without its denominator is not a claim. *(Wald counted bullet holes only in the planes that came back.)*
2. **Every detector needs a positive control** — prove it fires on a known-true case before trusting a zero.
   *(A smoke alarm with a dead battery also reports no fire.)*
3. **Never infer behaviour from configuration.** A flag being set is necessary, not sufficient — a second
   guard may block the path. Measure.
4. **A finding that says "verify X" stays open until X is verified.** It may not be downgraded to a note.
5. **Declared-inert requires a measured disable test.** A reason in a comment is not evidence.
6. **Predict the blast radius before the change; confirm it after.** Name what must be *bitwise unchanged*.
   A fix whose scope was predicted then confirmed is far stronger than one merely observed not to break
   anything.
7. **Pre-register as a commit that precedes the change commit.** Not a timestamp, not "it's in HEAD".
8. **No self-adjudication.** A parent that can overrule its own auditor is not audited.
9. **Stale documentation is an active hazard, not debt.** A comment asserting the opposite of the code will
   mislead an audit. Fix it in the same commit as the behaviour, or delete it.
10. **The human decides scope and what is claimed. Always.**

---

## Enforcement — a rule that does not execute is inert

Rules get written, agreed, and then violated anyway, because **nothing runs**. By the same standard applied
to any mechanism, a rule enforced only by someone remembering it is inert. Classify every rule:

| class | meaning | worth |
|---|---|---|
| **EXECUTES** | something fails loudly and blocks the action | prevention |
| **AUDITED** | a named role re-derives it after the fact | detection, not prevention |
| **REMEMBERED** | nothing enforces it | **treat as absent** |

**No rule may be classed EXECUTES without a positive control** proving the gate fires on a real violation. An
unfired gate and an absent gate are indistinguishable.

**Gates the archivist implements** — code, not prose. Adapt the form to the project:

| gate | blocks | positive control |
|---|---|---|
| **write guard** | writing to anything an existing claim depends on; refuses a target that carries a seal or does not match the run under way | an attempted write into a sealed target must raise |
| **no default outputs** | any script producing evidence takes its output target as a **required** argument; defaults pointing at a previous run are prohibited | running with no output argument must fail, not proceed |
| **ledger schema** | a claim row lacking artifact, denominator, or structural check | a row missing a denominator must be refused |
| **seal manifest** | a seal records a checksum per sealed file; any later mismatch is an error | mutate one byte; the next verification must fail |

The seal manifest is what turns "the numbers happened to match" from a defence into a measurement.

---

## Budget

Get a standing bound from the human once, then work inside it.

**The bound meters deliberation, not computation** — agent-to-agent rounds, audits, adjudications, re-plans.
A job's own runtime does not count. **Never shrink a job to fit the clock**: cutting samples, folds, or
coverage to finish inside the window trades evidence for punctuality.

**Result-triggered escalation:** running a check is autonomous; if the *outcome* moves a claim, contradicts
something reported, or changes a conclusion, escalate immediately. The trigger sits on the result, so a
misclassification at decision time is recoverable.

When the human is unreachable, queue escalations in the fixed shape — *the question · the options · what each
costs · what evidence would change the answer · the recommendation and the fact that would overturn it* —
and **block only that thread**, continuing with independent work.

---

## Honest limits

- **Shared framing is not solved, only mitigated.** Subagents inherit their parent's frame. The adversary
  helps; a genuinely outside party helps more; the human helps most.
- **The auditor's brief is a single point of failure.** Whoever writes it controls what the auditor can see.
  Give auditors the task as stated, never an interpretation of it.
- **Gates fix a class, not a category.** They reach errors with a detectable precondition. They cannot reach
  the error with no local signature — a component that was never live, a correct run of the wrong
  experiment. Nothing on disk distinguishes those.
- **Adding a rule is the weakest available response to a failure**, and the one that feels most like action.
  Before adding one, name what would *execute*. If the answer is "we'll remember", it is documentation and
  the failure remains open.

---

## Keep an incident log

Create `INCIDENTS.md` in the project on first use. Every time a rule catches something — or fails to — record
what happened, which rule it maps to, and what would have caught it earlier.

Generic rules get skimmed because they read as obvious. A rule with a local violation recorded against it
last month gets checked. The log is how a borrowed structure becomes the project's own.

