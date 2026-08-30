---
name: "checked-work"
description: "Run a task through an implementer / auditor / decider trio so its results are verified rather than asserted. Use for analysis, data work, or any claim that will be believed and acted on."
---

# Checked work — implementer, auditor, decider

A three-role structure for work whose output will be **believed**. It exists to stop one specific thing:
a claim arriving without the artifact that would settle it.

## When to use this

Use it when a wrong answer would be acted on — data analysis, a number that goes into a document, a claim
about what a codebase does, a measurement someone will cite.

**Do not use it** for conversation, quick lookups, or exploratory work that will be thrown away. It costs
three subagents and an extra pass. A role that cannot be described in terms of what it would have caught is
overhead pretending to be rigour.

If the work will be published, sealed, or relied on by people who cannot check it, use the fuller
`sealed-work` structure instead — it adds intent, liveness, provenance and adversary roles.

---

## The one design principle

> **Roles must differ in what they can SEE or in what they are ASKED. A role that differs only in its label
> produces agreement, not verification.**

Two agents with the same context and the job titles "implementer" and "reviewer" will agree, because the
second is really the first asked to be pleased with itself. Independence comes from four axes: what a role
can **access**, whether it is asked to **review or to falsify**, whether its **frame** starts from the task
or from someone's interpretation of it, and whether it compares to what was **promised before** or what
exists **now**.

---

## Before anything runs — the scope check

**Emit these three lines and stop, before the first fit, the first file, or the first multi-step plan.**
Not a subagent — three lines in your own reply, audited by the human at a glance:

```
Doing:         <one sentence. If it needs two, it is too big — split it or cut it.>
Authorised by: "<direct quote from the person who asked>"
Cheaper:       <one sentence, or "none">
```

Three rules make it bite:

- **Anything you cannot attach a quote to is CUT.** Not queued, not flagged, not "worth doing anyway."
  Over-delivery is *defined* as the absence of an authorising quote, so no judgment is involved.
- **If `Cheaper` is non-empty, stop and wait.** A cheap route you did not offer is a choice the person
  never got to make. Offering it after you have spent the expensive one is not offering it.
- **The trigger is mechanical, not discretionary:** any action that fits a model, creates a file, or takes
  more than one step. "When it seems warranted" is the discretion that fails — it fails exactly when you
  are in the mood to over-build, which is exactly when it is needed.

*Why this is not a subagent:* it must fire many times a day. Anything with a round-trip cost gets skipped
under time pressure, and a check that gets skipped is not a check. Three lines survive contact.

*What it catches that the auditor cannot:* a number can be correctly computed, correctly re-derived, and
still be something nobody asked for. The ledger below verifies that claims are **true**. This verifies they
are **wanted**. Work that is unwanted passes every downstream check cleanly, because there is nothing wrong
with it except that it exists.

---

## Wiring — this part is not optional

**You are the COORDINATOR. You do not implement and you do not adjudicate.** Spawn three siblings:

```
you (coordinator)
 ├── IMPLEMENTER   builds, runs, produces artifacts, fills the ledger
 ├── AUDITOR       re-derives every ledger row from the artifacts
 └── DECIDER       resolves conflicts; escalates only value questions
```

If you implement, you cannot adjudicate your own work, and the decider role silently becomes vacant. If you
adjudicate, you are a party to the dispute. Stay out of both.

The auditor is spawned **after** the implementer reports, and receives the *task statement and artifact
paths only* — never the implementer's report, prose, or reasoning. Whoever writes the auditor's brief
controls what it can see, so hand over the task as the user stated it, not your summary of it.

**Every round gets an auditor, and the last one most of all.** The round you are tempted to skip is the one
immediately before you commit, when the work looks finished, the checks you ran yourself came back clean,
and one more agent feels like ceremony. That is the round whose defects ship. Verifying a few things
personally is not the same structure: you wrote the brief, you know what the implementer intended, and you
will look where you already expect it to be fine. The cost of the skipped audit is not the audit — it is
that nothing else in the process was ever going to catch what it would have caught.

---

## The ledger — the report format

Reports are **not prose**. Every quantitative claim is a row:

| claim | value | artifact (path) | structural check | verdict |
|---|---|---|---|---|

- **artifact** is a file someone can open, not a log line that scrolled past.
- **structural check** is what proves the number is what it says: a count identity (`85 rows = 17 cells × 5
  folds`), a control that must be exactly zero, a total that must match a known denominator.
- Prose may surround the ledger for reasoning and recommendations. It is never the evidence.

**Hard rule: no number may be reported that cannot be pointed to a file for.** If it isn't in an artifact, it
doesn't go in the report.

---

## Brief for the IMPLEMENTER — hand over verbatim

> Build and run what the task asks. Produce artifacts on disk, not just answers.
>
> Report as a ledger: `claim | value | artifact path | structural check | verdict`. You may not report a
> number you cannot point to a file for. Prose is allowed around the ledger; it is never the evidence.
>
> Three rules that catch most errors:
> 1. **Every rate ships with its denominator.** "1 in 810" is not a claim unless 810 is on disk. (Wald
>    counted bullet holes only in the planes that came back.)
> 2. **Every detector needs a positive control.** Before trusting a zero, prove the check fires on a case you
>    know is true. A smoke alarm with a dead battery also reports no fire.
> 3. **Never infer behaviour from configuration.** A flag being set is necessary, not sufficient — a second
>    guard may block the path. Measure the behaviour.
>
> If you reinterpreted any instruction ("this can't mean literally X, so I did Y"), that is legitimate but
> must be **logged as a deviation**, never absorbed silently.

---

## Brief for the AUDITOR — hand over verbatim, with artifact paths and nothing else

> Your mandate is to **re-derive each ledger row from the artifacts and return pass/fail**. It is not to
> review the work, and not to form an opinion of its quality.
>
> **Before you look at anything, state for each row what evidence would falsify it.** Then go and look.
>
> Run your own commands against the artifacts. Reading a summary is not auditing. Verdicts are:
> - **PASS** — you re-derived it and it holds.
> - **FAIL** — you re-derived it and it does not.
> - **UNEVIDENCED** — the artifact does not support the claim. **This is a fail, not "probably fine".**
>
> Then check the mapping between what was asked and what exists, **in both directions**. Neither direction
> finds the other's failures:
>
> - **Over-delivery** — anything built that the task did not ask for. Invisible to a clause-only check,
>   because unrequested work maps to no clause.
> - **Under-delivery** — anything the task asked for with no artifact behind it. Invisible to a
>   ledger-only check, because a claim that was never made cannot fail an audit. **A missing thing produces
>   no row.**
>
> **Split every requirement into one clause per deliverable before you map.** A sentence joining two
> deliverables with "and" is two clauses. Map each separately. This is where under-delivery hides: a
> two-part requirement matches an artifact for its first part and passes as a whole, and the unbuilt half
> is never named by anything.
>
> **Then enumerate the readers, which the clause mapping cannot reach.** For every value, field, file or
> setting the change touched, list every *other* site that reads it and give a verdict per site. A second
> reader appears in no clause of any requirement, so both directions above pass it honestly. This is the
> most common way a correct repair breaks something: one value served two purposes, the change was right
> for one of them, and nothing asked about the other.
>
> **Say when the available data cannot exercise the change.** A clean diff proves nothing if the dataset
> is structurally incapable of expressing the failure — a timing defect cannot appear in data that carries
> no times. Before reporting a zero, state what property the data would need in order to show a problem,
> and whether it has it. This is the positive-control rule applied to the input rather than the detector.
>
> **Where the source document carries its own status label** — "implemented", "done", "resolved" — verify
> the label, and report a wrong one as a finding in its own right. A document asserting that something
> exists is a claim like any other, and it is the most costly kind to get wrong: everyone downstream stops
> looking.
>
> You will not be shown the implementer's report or reasoning. That is deliberate.

---

## Brief for the DECIDER — hand over verbatim, with both accounts and the artifacts

> Two accounts disagree. Your job is **not to judge between two narratives** — that is the failure this role
> exists to prevent. Your first move is to **name the measurement that would settle it**, and commission it.
>
> **Triage every conflict by kind. Only the last goes to the human:**
>
> | kind | question | resolution |
> |---|---|---|
> | **factual** | what does the code/data actually do? | a measurement. Someone is right. |
> | **scope** | is this inside what was asked? | read the task. If it is silent, that is itself the finding. |
> | **resource** | is another run or check worth it? | yours to decide, within the budget. |
> | **value** | what do we claim? is this limitation acceptable? | **escalate.** |
>
> The test separating the last two: **does this change what we believe or claim, or only what we spend?** An
> agent may spend resources to raise its own certainty. It may not create or alter what is claimed.
>
> Rules that bind you:
> 1. **Re-derive before ruling.** You may not rule from the two accounts alone. A decider that rules on
>    testimony is just a louder participant.
> 2. **Burden of proof sits with the universal claim.** "Impossible", "complete", "nothing else is affected"
>    are claims about all cases. A single counterexample defeats them.
> 3. **You may not overrule an evidence-based FAIL.** You decide what to *do about* it. Reversing one needs
>    new evidence, not judgement. Otherwise you are a laundering step, which is worse than no auditor.
> 4. **You adjudicate everyone equally** — including whoever wrote the brief. They are a party like any other.
> 5. **Record each ruling**: the conflict, both positions, the evidence relied on, the disposition, and what
>    would reverse it.
>
> **Result-triggered escalation:** running a check is autonomous, but if its *outcome* moves a claim,
> contradicts something already reported, or changes a conclusion, escalate immediately — even though no
> permission was needed to run it. You do not have to classify correctly in advance; the trigger sits on the
> result.

---

## Budget

Ask the user for a standing bound once, then work inside it without asking again.

**The bound meters deliberation, not computation.** It counts agent-to-agent rounds: proposals, audits,
adjudications, re-plans. A job's own runtime does not count — a six-hour computation inside one authorised
step is not a budget event.

**Never shrink a job to fit the clock.** Cutting samples, folds, or coverage to finish inside the window
trades evidence for punctuality, which inverts the intent.

---

## What you report back

Plain English, and short. Specifically:

- what changed, what it means, and what is now decided;
- **anything needing a decision, stated as a decision** — not buried in a paragraph;
- **never a recommendation without the fact that would overturn it**;
- no jargon, no development history unless it changes what to do, and **no reassurance**. If the honest
  summary is "the result got worse", that is the summary.

When escalating, use a fixed shape: *the question · the options · what each costs · what evidence would
change the answer · the recommendation and the fact that would overturn it.*

---

## Keep an incident log

The first time you use this in a project, create `INCIDENTS.md` there. Each time a rule catches something —
or fails to — add a line: what happened, which rule it maps to, what would have caught it earlier.

This matters more than it sounds. Generic rules get skimmed because they read as obvious. A rule with a local
violation recorded against it last month gets checked. The log is how a borrowed framework becomes yours.

