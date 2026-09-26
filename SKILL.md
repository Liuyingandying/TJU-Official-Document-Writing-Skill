---
name: official-document-writing-tju
description: 中文应用文、公文写作规范助手（中国高校场景适配层）。只要用户提到"写/起草/改 通知、请示、报告、总结、计划、申请书、汇报材料、函、纪要、请示报告、工作总结、阶段总结、项目申报书、申报书、调研报告、研究报告、课程报告、实习总结、就业材料、求职信、公文、比赛总结、结题报告、答辩稿、个人陈述"，或要求"按公文规范/GB-T 9704 检查格式、润色公文用语"，都必须使用本 Skill 决定内容结构、文种选择与语言规范；需要产出 docx/pdf 文件时，由运行环境提供的文档生成工具（如 academic-office MCP 或等价管线）完成排版，本 Skill 不内置文件生成能力。
---

# TJU Official Document Writing Skill（应用写作适配层）

本 Skill 是 [official-document-writing-skill](https://github.com/KaguraNanaga/official-document-writing-skill)（上游开源公文写作 Skill，MIT License）的中国高校场景适配层。

## 职责边界

| 职责 | 由谁承担 |
|---|---|
| 文种识别、内容结构、写作规范、高校场景适配 | **本 Skill**（SKILL.md + `references/` + `tju-extension/`） |
| 基础中文正式文书/公文规范（GB/T 9704-2012：版头/字号/层次序数/成文日期、质量清单） | 上游 `official-document-writing`（dependency） |
| DOCX/PDF 排版与产出（中文字体、页边距、自动目录、题注、自检） | **可选的运行环境文档生成能力**（如 academic-office MCP 或等价 pandoc 管线）。本 Skill 只决定"写什么、怎么组织"，不内置文件生成能力 |

## 文种路由（已验证）

按用户需求关键词选择文种与模板出处。安装后路径约定：`SKILL_DIR` 指本 Skill 安装目录（如 `~/.agents/skills/official-document-writing-tju`）；上游目录为 `~/.agents/skills/official-document-writing`。

| 用户需求关键词 | 文种 | 模板出处 |
|---|---|---|
| 通知、会议通知、转发 | 通知 | 上游 `SKILL.md` §常用公文模板 + `references/document-templates.md` |
| 请示、请求批准、妥否请批示 | 请示 | 同上（一文一事，结尾"妥否，请批示"） |
| 报告、情况报告、汇报工作 | 报告 | 上游 `references/document-templates.md` |
| 总结、工作总结、阶段总结、科研总结 | 总结 | 上游模板（成绩→问题→打算三段式）+ `tju-extension/references/tju-academic-scenarios.md` §2 |
| 计划、工作计划、进度安排 | 计划 | `tju-extension/references/tju-academic-scenarios.md` §4 |
| 申请书、项目申报、大创申报 | 申请书/申报书 | `tju-extension` §3 |
| 汇报材料、汇报 PPT 底稿、述职 | 汇报材料 | `tju-extension` §7 |
| 函、纪要 | 函/纪要 | 上游模板 |
| 课程报告 | 课程报告 | `tju-extension` §1 |
| 实习总结（提交学校备案版） | 实习总结 | `references/internship_summary.md` |
| 保研个人陈述 | 个人陈述 | `references/postgraduate_personal_statement.md` |
| 科研经历总结（复试/套磁/评审） | 科研经历 | `references/research_experience_summary.md` |
| 比赛总结 | 比赛总结 | `references/competition_summary.md` |
| 项目结题报告 | 结题报告 | `references/project_completion_report.md` |
| 答辩稿（口头汇报底稿） | 答辩汇报 | `references/defense_script.md` |
| 求职总结、就业材料 | 高校应用文 | `tju-extension` §6 |

内容写作时同时执行：上游 `checklists/quality-checklist.md` 质量清单（格式/内容/语言/逻辑 100+ 项）与上游 `references/writing-techniques.md` 语言四原则（准确、平实、简明、庄重）。

## 需要产出文件时

把按上述结构定稿的 Markdown 交给运行环境的文档生成能力。若环境提供 academic-office MCP（`generate_academic_docx`，天津大学学术模板管线）：

1. `generate_academic_docx(title, content_markdown)` 生成 docx；
2. 交付前运行其配套 `verify_output.py` 自检并如实报告结果。

若环境没有文档生成工具，直接交付定稿 Markdown，并告知用户需要自行排版——**不要声称已产出文件**。

### Markdown 输入契约（经真实 Dogfood 验证）

- 表格题注必须写成 `表：题注文字`（中文冒号），**空一行**后再写 Markdown 表格——排版后处理器以 `^表[：:]` 识别题注并生成 Word SEQ 表字段；
- `表 2-1 题注` 等编号式写法**不会**触发题注识别；
- 文档主标题放 YAML frontmatter 的 `title:`（不参与章节编号）；章节标题用 `#`/`##`，**不要手写编号**（管线自动编号）；
- 图片用绝对路径 `![图注](路径)`，图注写在方括号内。

## 路由红线

1. 上游 `official-document-writing` 目录内的文件是其原始内容，禁止修改；
2. 实验报告、学术论文、答辩 PPT 等学术工程文体可不经本 Skill，直接走环境中的学术文档生成能力；
3. 本 Skill 不引入新依赖、不注册新服务；文件产出全部复用运行环境的既有工具。

## 版本与来源

- 上游 dependency：https://github.com/KaguraNanaga/official-document-writing-skill v1.0（commit `e76a6f5`，2026-01-27，MIT License）
- 本仓库：TJU-Official-Document-Writing-Skill（适配层 + 高校扩展 + 模板库）
- 安装：见仓库 `README.md` 与 `scripts/install.ps1`
