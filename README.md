# claude-skills

Claude Code skills, versioned so they travel between machines instead of living in
`~/.claude/skills` on one laptop.

| skill | what it does |
|---|---|
| `checked-work` | implementer / auditor / decider trio, so a result is verified rather than asserted |
| `sealed-work` | the full eight-role structure — adds intent, liveness, provenance and adversary roles |

## Install

```bash
git clone git@github.com:polosecki/claude-skills.git ~/code/claude-skills
cd ~/code/claude-skills && ./install.sh
```

| | |
|---|---|
| `./install.sh` | copy into `~/.claude/skills/` — re-run after a `git pull` |
| `./install.sh --link` | symlink instead, so a `git pull` updates the installed skills in place |
| `./install.sh --check` | report what is installed and whether it matches this repo; exits non-zero on drift |

**Restart Claude Code afterwards.** The skill list is read at session start, so a skill installed
mid-session will not appear.

If a skill already installed differs from the copy here, the installer moves it aside to
`<name>.backup.<timestamp>` rather than overwriting it, so a local edit is never lost silently.
Override the destination with `CLAUDE_SKILLS_DIR` if you keep skills elsewhere.

## Adding a skill

Make a directory with a `SKILL.md` in it and commit. `install.sh` picks up anything matching
`*/SKILL.md`, so nothing else needs changing.

`SKILL.md` opens with YAML frontmatter carrying `name` and `description`. The description is what
Claude matches against when deciding whether a skill applies, so it should say when to reach for the
skill, not just what the skill contains.

## Where these two came from

Both were written for the `multimodal_missingness` project and are the operational form of its
`specs/FRAMEWORK_agent_roles.md`, which is the authority on the process. They are kept here rather
than in that repository so they are available in any project, but if that framework document changes
these should change with it — otherwise they quietly describe a process that is no longer the one in
use.

Every role in `sealed-work` maps to a failure mode that actually occurred in that project. A role
that cannot be described in terms of what it would have caught is overhead pretending to be rigour;
drop any whose failure mode does not apply to the work in front of you.
