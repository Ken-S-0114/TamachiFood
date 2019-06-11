# TamachiLunch

田町の飲食店をランダムに表示するアプリ

# 開発環境

サポートする開発環境は以下の通りです

* Xcode 10.2.1
* Swift 5.0

# 初期設定

## ツールの導入
- Bundler を使って cocoapods を管理
- ライブラリのインストール
  - `$ bundle exec pod install`
- 以下２つビルド時に実行
  - SwiftFormat
    - `$ Pods/SwiftFormat/CommandLineTool/swiftformat . --exclude Carthage,Pods --trimwhitespace nonblank-lines --stripunusedargs closure-only --disable strongOutlets,trailingCommas`
  - SwiftLint
    - `$ swiftlint autocorrect --format`
    - `$ swiftlint`
