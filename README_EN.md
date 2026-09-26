# TJU Official Document Writing Skill

> A Chinese applied-writing Agent Skill for university scenarios in China

`official-document-writing-tju` is an adaptation layer on top of the open-source
official-document writing skill
[official-document-writing-skill](https://github.com/KaguraNanaga/official-document-writing-skill):
on top of its Chinese official-document standard (GB/T 9704-2012), it adds
genre routing, structure templates and writing rules for real university scenarios.

**Current version: v0.9.0 (Public Beta)** — see [README.md](README.md) for the Chinese primary documentation.

## Features

- Research project summaries (stage / closing)
- Course reports and course summaries
- Competition summaries (post-competition review)
- Internship summaries (registrar-submission variant)
- Project proposals (innovation-training / research programs)
- Survey / research reports
- Work and research plans
- Notices, meeting minutes, requests, letters (official documents, carried by upstream)
- Reporting briefs
- Postgraduate personal statements
- Research experience summaries
- Defense scripts (oral presentation drafts + slide outlines)
- Job-application summaries and career materials
- Official-document format checking and polished wording (GB/T 9704-2012, via upstream)

Every template ships with: **use cases / recommended structure / prohibitions / examples**.

## Architecture

```
User
 ↓
Agent Runtime (any Agent-Skill-capable host, e.g. ZCode / Claude Code)
 ↓
official-document-writing-tju        ← this repository (genre routing / structure / university adaptations)
 ↓
official-document-writing            ← upstream dependency (Chinese official-document standards)
+
tju-extension                        ← university-scenario extension (in this repository)
 ↓
optional document generator / MCP    ← optional (e.g. academic-office MCP for DOCX/PDF typesetting)
```

Boundary: this Skill handles **genre identification, structure planning, writing rules and
university adaptations**; upstream carries the **base official-document standards**;
document generation (academic-office MCP or equivalent) is an **optional runtime capability**,
not a built-in component — without it, this Skill delivers finalized Markdown.

## Validation Status

Verified (real runs inside ZCode Runtime):

- The runtime discovers and loads this Skill
- official-document-writing-tju was actually selected (Skill invocation → full SKILL.md injected)
- tju-extension templates were actually used (research stage summary / competition summary / proposal drafts)
- Skill → academic-office MCP → DOCX ran end to end
- document_type = 总结 (Summary)
- status = success
- verify = 13/13

Current model used for the validated runtime chain: **GLM-5.3-Flash**

TJU LLM status:

- tju-llm provider configured
- Standalone REST test confirms OpenAI-compatible tool_calls support
- Not yet verified within a single real ZCode session: tju-llm → Skill → MCP → DOCX

Hence the current project status: **v0.9.0 Public Beta**.

v1.0.0 criteria: real model_usage proving model_id=tju-llm, plus a complete
tju-llm → official-document-writing-tju → academic-office MCP → DOCX → verify 13/13 run.

> Wording note: the above describes a real end-to-end validation "in the ZCode Runtime with the
> stated model environment"; it is not a compatibility claim for every Agent Runtime or LLM.

## Installation

Windows PowerShell:

```powershell
git clone https://github.com/<YOUR_ORG>/TJU-Official-Document-Writing-Skill.git
cd TJU-Official-Document-Writing-Skill
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\install.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\verify_install.ps1
```

The installer is idempotent: it clones the upstream dependency once, installs this skill into
`$HOME\.agents\skills\official-document-writing-tju`, and never touches other skills or user files.

## Markdown Conventions

Confirmed by real dogfooding (academic-office pipeline): table captions must be written as
`表：caption` (Chinese colon) followed by a blank line and the Markdown table — the post-processor
recognizes captions via `^表[：:]` and emits Word SEQ fields. Numbered forms such as
`表 2-1 caption` do NOT trigger caption recognition.

## Dependency

- Upstream: [KaguraNanaga/official-document-writing-skill](https://github.com/KaguraNanaga/official-document-writing-skill) (MIT)
- Referenced as a dependency/attribution only — upstream source code is NOT included in this repository.

## License

MIT for this repository's adaptation layer, extension and templates — see [LICENSE](LICENSE).
Upstream official-document-writing-skill remains under its own MIT License and is installed as a dependency.
