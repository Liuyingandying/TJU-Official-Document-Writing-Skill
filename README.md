# TJU Official Document Writing Skill

> 面向中国高校场景的中文应用写作 Agent Skill

`official-document-writing-tju` 是上游开源公文写作 Skill
[official-document-writing-skill](https://github.com/KaguraNanaga/official-document-writing-skill)
的适配层：在其"党政机关公文"规范（GB/T 9704-2012）之上，补充中国高校真实场景的
应用写作文种路由、结构模板与写作规范。

**当前版本：v1.0.0（Production）**

## Features

- 科研项目总结 / 阶段总结 / 结题报告
- 课程总结 / 课程报告
- 比赛总结（电子设计、FPGA 创新、建模等竞赛复盘）
- 实习总结（提交学校备案版）
- 项目申报（大创 / 科研立项申请书结构）
- 调研报告 / 研究报告
- 工作计划 / 研究计划
- 通知 / 会议纪要 / 请示 / 函（基础公文，由上游承载）
- 汇报材料（汇报提纲底稿）
- 保研个人陈述
- 科研经历总结（复试 / 套磁 / 评审）
- 答辩稿（口头汇报底稿 + PPT 页面大纲）
- 求职总结 / 就业材料
- 公文格式检查与语言润色规范（GB/T 9704-2012，由上游承载）

每类模板均包含：**使用场景 / 推荐结构 / 禁止事项 / 示例**。

## Architecture

```
User
 ↓
Agent Runtime（如 ZCode / Claude Code 等支持 Agent Skill 的运行环境）
 ↓
official-document-writing-tju        ← 本仓库（文种识别 / 结构规划 / 高校场景适配）
 ↓
official-document-writing            ← 上游依赖（基础中文正式文书 / 公文规范）
+
tju-extension                        ← 本仓库内的高校场景扩展
 ↓
optional document generator / MCP    ← 可选（如 academic-office MCP，负责 DOCX/PDF 排版）
```

职责边界：本 Skill 负责**文种识别、写作结构、规范与高校场景适配**；
上游负责**基础中文正式文书/公文规范**；
文档生成（academic-office MCP 或等价管线）是**可选的运行环境能力**，
不属于本 Skill 的内置组件——没有该能力时，本 Skill 交付定稿 Markdown。

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

| 记录项 | 值 |
|---|---|
| 实际模型 | `580ff3eb-26bc-4a55-9989-de1b9a6d207b/tju-llm` |
| Skill 命中 | `official-document-writing-tju` → `references/competition_summary.md` |
| 文种判定 | 总结（竞赛项目总结） |
| MCP tool | `generate_academic_docx` |
| document_type | 总结 |
| status | success |
| verify | 13/13 |
| DOCX | `FPGA比赛总结_144641.docx`（16.8 KB） |
| fallback | none |

> 验证范围：ZCode Runtime + TJU LLM（`tju-llm`）。
> 不构成对其他 Agent Runtime 或其他 LLM 的适配性承诺。

## Supported Environments

- 任何支持 Agent Skill 规范（`SKILL.md` + frontmatter）的运行环境即可发现并加载本 Skill
- 文档生成（DOCX/PDF）为**可选能力**：需要运行环境另行提供（如 academic-office MCP
  或等价的 pandoc 管线）；没有时本 Skill 仍然完成文种判断与内容写作

## Installation

Windows PowerShell：

```powershell
git clone https://github.com/<YOUR_ORG>/TJU-Official-Document-Writing-Skill.git
cd TJU-Official-Document-Writing-Skill
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\install.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\verify_install.ps1
```

安装脚本行为：

1. 使用 `$HOME\.agents\skills` 作为技能根目录（可用 `-SkillsRoot` 覆盖）；
2. 检查上游依赖 `official-document-writing`，缺失时自动 `git clone`；
3. 将本 Skill（SKILL.md + references + tju-extension）安装到
   `$HOME\.agents\skills\official-document-writing-tju`；
4. **幂等**：重复执行不会重复 clone、不会覆盖其他 Skill、不会删除任何用户文件。

## Usage Examples

需要文档生成能力（MCP / 管线）由运行环境提供时：

```text
"帮我写一份 FPGA 比赛总结，只给正文"          ← 内容写作，交付 Markdown
"帮我生成一份 FPGA 比赛总结 Word"             ← 内容写作 + 调用环境的文档生成工具
```

两者是不同的意图：前者不产生文件，后者才调用文档生成能力。

## Markdown Conventions

本项目在真实 Dogfood 中确认的排版输入约定（适用于 academic-office 管线）：

表格题注必须写：

```markdown
表：关键指标实测对照

| 指标 | 数值 |
|---|---|
```

原因：当前 academic-office 后处理器以 `^表[：:]` 识别 Markdown 表题注，
随后生成 Word 的 SEQ 表字段。

以下形式当前**不应使用**（不会触发题注识别）：

```markdown
表 2-1 关键指标实测对照
```

其他约定：文档主标题放 YAML frontmatter 的 `title:`；章节标题用 `#`/`##`
且不手写编号（管线自动编号）；图片用 `![图注](绝对路径)`。

## Dependency

- 上游仓库：[KaguraNanaga/official-document-writing-skill](https://github.com/KaguraNanaga/official-document-writing-skill)
- License：MIT
- 引用方式：**dependency / attribution**——本仓库不包含、不复制上游源码，由安装脚本按需克隆

## License / Attribution

- 本仓库（适配层 + 高校扩展 + 模板库）：MIT License，见 [LICENSE](LICENSE)
- 上游 official-document-writing-skill：Copyright 上游作者，MIT License
- 本仓库模板、结构规则与示例为自主整理的原创表达；未包含任何第三方课程材料

## Known Limitations

- 文档生成依赖运行环境提供的能力，本 Skill 自身不产出文件
- 公文红头版式（发文机关标志、红色分隔线、版记）不在学术排版管线模拟范围内，需在 Word 中手工套版
- "总结/计划"类文种不强制参考文献；"论文"类仍按 GB/T 7714 强制（由配套校验器承载，非本仓库组件）
