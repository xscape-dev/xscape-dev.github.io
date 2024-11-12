/*
This is just a placeholder blank stylesheet so as to support adding custom styles budled with theme's default styles

Read https://github.com/adityatelange/hugo-PaperMod/wiki/FAQs#bundling-custom-css-with-themes-assets for more info
*/
/* # Markdown 风格 */
/* 标题、正文、行内代码 - 颜色 */
:root {
    --primary: #212121;  /* rgb(30, 30, 30); */
    --content: #333333;  /* rgb(31, 31, 31); */
    --code-bg: rgba(175, 184, 193, 0.2); /* rgb(245, 245, 245); */
}
.dark {
    --code-bg: rgba(175, 184, 193, 0.2); /* rgb(55, 56, 62); */
}
/* 链接样式 */
.post-content a {
    color: #0969da;
    box-shadow: none;
    text-decoration: none;
}
.post-content a:hover {
    text-decoration: underline;
}
/* 行内代码 - 左右间距 */
.post-content code {
    margin: unset;
}
/* 代码块 - 最大高度 */
/* .post-content pre code {
 *     max-height: 40rem;
 *     } */
/* 图片居中 */
.post-content img {
    margin: auto;
}
/* 行文风格 */
body {
    font-family: -apple-system, BlinkMacSystemFont, "Avenir Next", Avenir, "Nimbus Sans L", Roboto, Noto, "Segoe UI", Arial, Helvetica, "Helvetica Neue", sans-serif;
    font-size: 1rem;
    line-height: 1.5;
    margin: 0;
}
.post-content {
    padding-top: 1rem;
}
.post-content blockquote {
    color: #808080;
}
.post-content p,
.post-content blockquote,
.post-content figure,
.post-content table {
    margin: 1.15rem 0;
}
.post-content hr {
    margin: 4rem 8rem;
}
.post-content ul,
.post-content ol,
.post-content dl,
.post-content li {
    margin: 0.5rem 0;
}
.post-content h1,
.post-content h2,
.post-content h3,
.post-content h4,
.post-content h5,
.post-content h6 {
    margin-bottom: 1.15rem;
    font-weight: 600;
}
.post-content h1 {
    font-size: 2.6rem;
    margin-top: 4rem;
    border-bottom: 1px solid #ccc;
}
.post-content h2 {
    font-size: 1.8rem;
    margin-top: 4rem;
    border-bottom: 1px solid #ccc;
}
.post-content h3 {
    font-size: 1.6rem;
    margin-top: 2rem;
}
.post-content h4 {
    font-size: 1.4rem;
    margin-top: 1.44rem;
}
.post-content h5 {
    font-size: 1.2rem;
    margin-top: 1.15rem;
}
.post-content h6 {
    font-size: 1rem;
    margin-top: 1rem;
}
/* GitHub 样式的表格 */
.post-content table tr {
    border: 1px solid #979da3 !important;
}
.post-content table tr:nth-child(2n),
.post-content thead {
    background-color: var(--code-bg);
}
.post-content table th {
    border: 1px solid #979da3 !important;
}
.post-content table td {
    border: 1px solid #979da3 !important;
}


