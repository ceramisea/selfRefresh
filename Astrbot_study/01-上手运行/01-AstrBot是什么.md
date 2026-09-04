# 01 · AstrBot 是什么

> 目标:用 3 句话向别人讲清楚 AstrBot;对它的"零件"有个直觉印象。
> 对应源码:本仓库根目录的 `README_zh.md`,以及 `docs/zh/what-is-astrbot.md`。

## 一句话版本

**AstrBot 是一个开源聊天机器人"中控台":它负责把各种聊天软件(QQ、Telegram、飞书…)和各家大模型(AI)连接起来,让你在聊天窗口里就能跟 AI 对话、用插件、查知识库。**

如果你只记三句话,记这三句:

1. **它连接"聊天平台"和"AI 大脑"两端**,你不用自己写对接代码。
2. **它自带一个网页控制台(WebUI)**,大部分配置点鼠标就能完成。
3. **它支持插件(叫 Star)**,社区有上千个现成插件,你也可以自己写。

## 它是用来解决什么问题的?

假设你想让 QQ 群里的机器人能"用 AI 回答 + 查资料 + 定时发消息"。没有框架时,你要自己搞定:

- 怎么接收 QQ 消息?(对接 QQ 的协议/SDK)
- 怎么调用大模型?(OpenAI?DeepSeek?接口各不相同)
- 多轮对话历史放哪?怎么截断?
- 不同平台(QQ / Telegram / 飞书)都要各写一套?

AstrBot 把这些**通用脏活都封装好了**,你只需要:

1. 启动 AstrBot;
2. 在网页里"接入一个聊天平台"(比如 QQ);
3. 在网页里"接入一个大模型"(比如 DeepSeek);
4. 完事,开始聊天。想加功能就装/写插件。

## 核心"零件"一览(先混个脸熟)

下面的名词在后续笔记会反复出现,现在有个印象即可:

| 名词 | 通俗理解 | 在代码里大致对应 |
|---|---|---|
| **Platform / 平台适配器** | "耳朵和嘴巴":负责收发某个聊天软件的消息 | `astrbot/core/platform/`(每个平台一个适配器) |
| **Provider / 模型提供商** | "大脑供应商":封装各家大模型的调用 | `astrbot/core/provider/` |
| **Agent(执行器)** | "大脑":决定怎么用模型、要不要调工具 | `astrbot/core/agent/`、`astrbot/core/astr_agent_run_util.py` |
| **Star / 插件** | "技能包":响应特定指令或事件的代码 | `astrbot/core/star/`、`astrbot/builtin_stars/` |
| **Pipeline / 流水线** | "流水线":消息从进来到回复经过的一系列处理工序 | `astrbot/core/pipeline/` |
| **WebUI / Dashboard** | 网页控制台,你配置机器人的地方 | `dashboard/`(Vue 前端)+ `astrbot/dashboard/`(后端) |

> 一个不严谨但好懂的类比:AstrBot 像一家餐厅——
> **平台适配器**是服务员(接客/上菜),**流水线**是后厨动线,**Provider** 是食材供应商,
> **Agent** 是主厨,**插件(Star)** 是特色菜谱,想吃什么就加什么菜谱。

## 一条消息大概怎么走?(预告)

这是全项目最核心的一条链路,笔记 09 会详细讲。先看简化版:

```
你在 QQ 发"你好"
   │
   ▼
QQ 适配器 收到消息 ──► 转成统一的内部事件(AstrMessageEvent)
   │
   ▼
事件总线 EventBus ──► 交给 流水线 PipelineScheduler
   │
   ▼
流水线里一层层处理:唤醒检查 → 权限/限流 → 预处理 → 分发
   │
   ├── 如果有插件匹配 → 执行插件代码
   └── 否则 → 调大模型(Provider)→ Agent 生成回复
   │
   ▼
回复结果一路传回 → QQ 适配器把消息发出去
```

## 这个项目支持什么?

- **聊天平台(18+ 种)**:QQ(官方/OneBot)、Telegram、Discord、Slack、飞书、钉钉、微信公众号、企业微信、KOOK、LINE、Misskey、Mattermost、Satori 等,还内置一个网页 ChatUI。
- **大模型(数十种)**:OpenAI、Anthropic、Gemini、DeepSeek、智谱、Moonshot、Ollama(本地)、LM Studio(本地)等;也支持接入 Dify / Coze / 阿里云百炼 这类"Agent 平台"。
- **扩展能力**:插件(Star)、知识库、MCP、Skills、函数调用、定时任务、Agent 沙箱(安全执行代码)等。

## 这份源码的"体检报告"

你在学的这份源码(`AstrBot-master/`)是**开发版主线**,值得先知道:

- 语言/版本:**Python**,`pyproject.toml` 要求 **Python ≥ 3.12**。
- 依赖管理:官方推荐 **uv**(比 pip 更快、更省心的新一代工具)。
- 主要技术栈:FastAPI / Quart(网页与 API)、SQLite + SQLAlchemy(存储)、Loguru(日志)、Pydantic(配置校验)、APScheduler(定时任务)。
- 源码结构:真正的框架代码几乎都在 **`astrbot/`** 一个包内;`dashboard/` 是网页前端(Vue);`docs/` 是文档。
- WebUI 默认地址:`http://localhost:6185`(启动后日志里会打印)。

## 📌 小练习

1. 打开 `AstrBot-master/README_zh.md`,用你自己的话写下:AstrBot 的三个主要功能。
2. 打开 `AstrBot-master/docs/zh/what-is-astrbot.md`,找到那张"架构拓扑图"(需要联网加载图片),试着找到上面表格里的 Platform / Provider 在图中的位置。
3. 什么都不用改,先在文件管理器里看看 `AstrBot-master/astrbot/` 下面有哪些文件夹,猜猜每个是干什么的——笔记 07 会揭晓答案。

## ➡️ 下一步

你已经知道它是谁了,接下来把它跑起来吧:

👉 [02-安装与启动](02-安装与启动.md)
