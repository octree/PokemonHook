# Readme

__文章推出收到了 Ingress 的玩家炮轰，本身我就是技术交流的目的，于是我删掉了 ipa，开源了关键代码。有兴趣的人自己搞吧。__

- 把我提供的 zip 中 libLocationFaker 用 codesign 重新签名
- 把 .app 放到 Payload 文件夹，压缩成 .ipa
- 用 codesign / fastlane / iresign 等工具重新签名
- iTunes / iTools / Xcode 安装 ipa，推荐用 Xcode 安装，大多数安装失败会提示原因。
