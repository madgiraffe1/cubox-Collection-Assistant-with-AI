# PopClip Webhook 扩展

一个简单的 PopClip 扩展，可以快速将选中的文本发送到指定的 Webhook 地址。

这个扩展是从一个为 Cubox 设计的旧版本修改而来，使其成为一个通用的工具。

## 功能特性

-   捕获选中的文本，并将其发送到你提供的任何 Webhook URL。
-   数据以 JSON 格式发送，结构如下：`{"foo": "bar", "content": "这里是选中的文本"}`。

## 安装方法

1.  请确保你的 macOS 上已经安装了 [PopClip](https://www.popclip.app)。
2.  双击 `Cubox.popclipext` 文件（或目录）来安装此扩展。

## 配置说明

在使用前，你必须为扩展配置你的个人 Webhook URL。

1.  在 `Cubox.popclipext` 目录中，你会找到一个名为 `config.sh.example` 的文件。
2.  复制这个文件，并将副本重命名为 `config.sh`。
3.  使用文本编辑器打开新的 `config.sh` 文件。
4.  将文件中的占位符 `PASTE_YOUR_WEBHOOK_URL_HERE` 替换成你自己的真实 Webhook URL。
5.  保存文件。

完成以上步骤后，扩展就准备就绪了。在屏幕上选中任意文本，PopClip 的工具条中就会出现 Cubox 图标。点击它，选中的文本就会被发送到你配置的 Webhook。

## 致开发者

本扩展使用一个简单的 Shell 脚本 (`save.sh`) 来发送 POST 请求。它需要你的系统上装有 `curl` 以及 `jq` 或 `python3`，用于创建 JSON 数据。如果需要，你可以很轻松地修改这个脚本来改变 JSON 的结构。 