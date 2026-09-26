# TJU Official Document Writing Skill

> A Chinese applied-writing Agent Skill for university scenarios in China

`official-document-writing-tju` is an adaptation layer on top of the open-source
official-document writing skill
[official-document-writing-skill](https://github.com/KaguraNanaga/official-document-writing-skill):
on top of its Chinese official-document standard (GB/T 9704-2012), it adds
genre routing, structure templates and writing rules for real university scenarios.

**Current version: v1.0.0 (Production)** — see [README.md](README.md) for the Chinese primary documentation.

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

**FULL VERIFIED** — TJU LLM (`tju-llm`) end-to-end validation completed on 2026-09-26.

Verified end-to-end with:

```
TJU LLM (`tju-llm`)
→ ZCode Skill Runtime
→ `official-document-writing-tju`
→ `competition_summary`
→ academic-office MCP
→ DOCX
→ verify 13/13
```

| Item | Value |
|---|---|
| Actual model | `580ff3eb-26bc-4a55-9989-de1b9a6d207b/tju-llm` |
| Skill selected | `official-document-writing-tju` → `references/competition_summary.md` |
| Genre | 总结 (Competition Summary) |
| MCP tool | `generate_academic_docx` |
| document_type | 总结 |
| status | success |
| verify | 13/13 |
| DOCX | `FPGA比赛总结_144641.docx` (16.8 KB) |
| fallback | none |

> Validation scope: ZCode Runtime + TJU LLM (`tju-llm`).
> This is not a compatibility claim for other Agent Runtimes or LLMs.

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
