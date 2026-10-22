# 心动名单：可上线版本

这个版本是真正共享数据版本：

- 玩家从数据库读取最新人物列表
- 玩家提交会保存到 Supabase
- 80% 及以上自动进入该玩家的仓库
- 仓库格子数量动态生成
- “随机一个”只从仓库里抽
- 编辑模式暗号：`kisskissme`
- 编辑模式直接批量 TXT 编辑：每行一个人物
- 保存后所有玩家刷新即可看到新列表
- 编辑模式可查看最近 100 条玩家提交

## 1. 创建 Supabase

1. 打开 https://supabase.com/ 创建免费项目。
2. 进入 SQL Editor。
3. 把 `supabase_setup.sql` 全部复制进去运行。
4. 到 Project Settings / API 找到：
   - Project URL
   - anon / publishable key

## 2. 配置 index.html

搜索：

```js
const SUPABASE_URL = "PASTE_YOUR_SUPABASE_URL_HERE";
const SUPABASE_ANON_KEY = "PASTE_YOUR_SUPABASE_ANON_KEY_HERE";
```

换成你自己的 Project URL 和 anon/publishable key。

## 3. GitHub Pages 发布

1. 新建 GitHub repository。
2. 上传 `index.html`。
3. Settings > Pages。
4. 选择 Deploy from a branch。
5. Branch 选 `main`，目录 `/ (root)`。
6. 保存，等 GitHub 生成网址。

## 编辑模式

首页选择“编辑模式”，暗号：

`kisskissme`

## 大类（可折叠分组）

编辑模式里用 `#` 开头的一行写大类名，下面的人物都属于这个大类：

```
# Part 1
人物 A
人物 B

# Part 2
人物 C
```

玩家页面每个大类是一个可折叠区块，第一个默认展开；点「这部分完成，下一部分」会收起当前、展开下一个。不写 `#` 就是原来的普通列表。

已经上线的旧数据库需要先在 Supabase SQL Editor 运行一次 `supabase_add_categories.sql`。

## 改暗号

以后如果想改，在 Supabase SQL Editor 运行：

```sql
update public.app_config
set value = crypt('你的新暗号', gen_salt('bf'))
where key = 'editor_code_hash';
```
