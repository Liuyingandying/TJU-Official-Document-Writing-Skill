# tju-extension — 中国高校场景应用写作扩展

> 本目录是 [TJU-Official-Document-Writing-Skill](../../README.md) 的高校场景扩展，为纯增量内容：
> 上游仓库 [official-document-writing-skill](https://github.com/KaguraNanaga/official-document-writing-skill)
> 的任何原文件均未被修改。

## 用途

把上游"党政机关公文"能力扩展到高校应用文场景，供主 SKILL.md 在文种路由时引用：

| 场景 | 结构模板 |
|---|---|
| 课程报告 | [references/tju-academic-scenarios.md](references/tju-academic-scenarios.md) §1 |
| 科研总结（项目阶段总结/结题总结） | §2 |
| 项目申报（大创/申请书） | §3 |
| 计划（研究计划/工作计划） | §4 |
| 实习总结 | §5 |
| 就业材料（求职信等） | §6 |
| 汇报材料（汇报提纲底稿） | §7 |

语言规范、文种逻辑、质量检查沿用上游核心（安装后位于
`~/.agents/skills/official-document-writing/` 的 `checklists/quality-checklist.md`、
`references/writing-techniques.md`、`references/gb-t-9704-2012-standard.md`）。

## 与排版产出的衔接

内容定稿后交运行环境的文档生成能力（如 academic-office MCP）产出文件，
`--style` 参数建议映射：

| 场景 | 建议 style |
|---|---|
| 课程报告 | `course_report` |
| 科研总结 / 项目申报 | `academic_paper` / `competition_report` |
| 其他应用文 | 默认 `academic_paper` |

## 来源记录

- 上游仓库：https://github.com/KaguraNanaga/official-document-writing-skill（MIT License）
- 本扩展：TJU-Official-Document-Writing-Skill 自主整理，随主仓库 License 发布
