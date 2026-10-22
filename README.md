# WezTerm 中文用户手册

面向 Windows 与跨平台用户的 [WezTerm](https://wezterm.org) **社区中文手册**（非官方翻译 / 非官方文档）。

- 在线阅读：https://gradient30.github.io/wezterm-handbook-zh/
- 官方文档：https://wezterm.org
- 仓库：https://github.com/gradient30/wezterm-handbook-zh

## 本地开发

```bash
npm ci
npm run docs:dev
```

## 构建

```bash
npm run docs:build
```

输出目录：`docs/.vitepress/dist`。

## 部署（GitHub Pages）

当前 Pages 源为 **`gh-pages` 分支**（已验证可访问）。

```bash
./scripts/deploy-gh-pages.sh
```

可选：将仓库根目录的 `deploy-pages.workflow.yml.example` 复制为 `.github/workflows/deploy.yml`（需具备 `workflow` scope 的凭据，或在 GitHub 网页创建），再将 Settings → Pages → Source 设为 **GitHub Actions**。

## 许可

手册正文以 MIT 许可发布。WezTerm 本身及其官方文档版权归属其各自作者。
