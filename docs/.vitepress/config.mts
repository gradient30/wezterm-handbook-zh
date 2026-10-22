import { defineConfig } from 'vitepress'

export default defineConfig({
  lang: 'zh-Hans',
  title: 'WezTerm 中文手册',
  description: '面向 Windows 与跨平台用户的 WezTerm 社区中文使用手册（非官方）',
  base: '/wezterm-handbook-zh/',
  cleanUrls: true,
  lastUpdated: true,

  head: [
    ['meta', { name: 'theme-color', content: '#3c82f6' }],
    ['meta', { name: 'og:type', content: 'website' }],
    ['meta', { name: 'og:title', content: 'WezTerm 中文手册' }],
    ['meta', { name: 'og:description', content: 'WezTerm 社区中文用户手册（非官方）' }],
  ],

  themeConfig: {
    logo: undefined,
    siteTitle: 'WezTerm 中文手册',
    outline: { label: '本页目录', level: [2, 3] },
    lastUpdated: { text: '最后更新' },
    darkModeSwitchLabel: '外观',
    lightModeSwitchTitle: '切换到浅色模式',
    darkModeSwitchTitle: '切换到深色模式',
    sidebarMenuLabel: '菜单',
    returnToTopLabel: '回到顶部',
    docFooter: { prev: '上一页', next: '下一页' },
    search: {
      provider: 'local',
      options: {
        translations: {
          button: { buttonText: '搜索', buttonAriaLabel: '搜索文档' },
          modal: {
            displayDetails: '显示详细列表',
            resetButtonTitle: '清除查询',
            backButtonTitle: '返回',
            noResultsText: '没有找到相关结果',
            footer: {
              selectText: '选择',
              navigateText: '切换',
              closeText: '关闭',
            },
          },
        },
      },
    },
    nav: [
      { text: '手册', link: '/guide/install' },
      { text: '独家功能', link: '/guide/features' },
      { text: '配方', link: '/guide/recipes' },
      { text: 'AI 编程', link: '/guide/ai-coding' },
      { text: 'FAQ', link: '/guide/faq' },
      { text: '官方文档', link: 'https://wezterm.org' },
    ],
    sidebar: [
      {
        text: '入门',
        items: [
          { text: '介绍', link: '/' },
          { text: '安装与入门', link: '/guide/install' },
          { text: '配置文件', link: '/guide/config' },
        ],
      },
      {
        text: '使用',
        items: [
          { text: '外观与标签栏', link: '/guide/appearance' },
          { text: '快捷键与滚动', link: '/guide/keys-scroll' },
          { text: '分屏与标签', link: '/guide/panes-tabs' },
          { text: '特有便捷性与独家功能', link: '/guide/features' },
          { text: '玩法与配方', link: '/guide/recipes' },
          { text: 'AI 编程使用方案', link: '/guide/ai-coding' },
        ],
      },
      {
        text: '进阶',
        items: [
          { text: 'CLI 与进阶', link: '/guide/cli' },
          { text: '转义序列（概要）', link: '/guide/escape-sequences' },
          { text: '常见问题 FAQ', link: '/guide/faq' },
          { text: '参考链接', link: '/guide/references' },
        ],
      },
    ],
    socialLinks: [
      { icon: 'github', link: 'https://github.com/gradient30/wezterm-handbook-zh' },
    ],
    footer: {
      message: '社区中文手册 · 非官方翻译 · 内容基于 wezterm.org',
      copyright: '请以 <a href="https://wezterm.org" target="_blank" rel="noreferrer">官方文档</a> 为准',
    },
    editLink: {
      pattern: 'https://github.com/gradient30/wezterm-handbook-zh/edit/main/docs/:path',
      text: '在 GitHub 上编辑此页',
    },
  },
})
