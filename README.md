# Karukaya（カルカヤ）

AI CLI（Claude Code、Codex など）で開発する人のための、軽いデスクトップエディタです。
AI が書き換えたファイルをすぐに見つけ、差分を確かめ、次の指示を出せます。

**今はベータ版です。** 動きや画面が予告なく変わることがあります。不具合や気付いたことは、Karukaya を教えてくれた人に知らせてください。

## ダウンロード

[Releases](https://github.com/digileap-jp/karukaya-releases/releases/latest) から、使っている OS のファイルをダウンロードしてください。

| OS | ファイル |
|---|---|
| Windows 11 | `Karukaya_<版>_x64-setup.exe` |
| Mac（Apple シリコン・Intel のどちらも） | `Karukaya_<版>_universal.dmg` |
| Linux（Ubuntu 22.04 以降・Debian） | `Karukaya_<版>_amd64.deb` |

新しい版が出ても、自動では知らせません。ときどき Releases を見てください。

## 入れ方

Karukaya には、まだ電子署名をしていません。そのため、最初に開くときに OS が警告を出します。次の手順で進めてください。

### Windows

1. `Karukaya_<版>_x64-setup.exe` を開く
2. 「Windows によって PC が保護されました」と出たら、「詳細情報」を押し、「実行」を押す
3. あとはセットアップの案内に従う

消すときは、「設定」→「アプリ」→「インストールされているアプリ」から Karukaya をアンインストールします。

### Mac

**ターミナルで入れる（おすすめ）**：次の 1 行を実行します。最新の版を「アプリケーション」に入れ、最初に開くときの警告も出ません。新しい版にするときも、同じ 1 行を実行します（Karukaya を閉じてから）。

```bash
curl -fsSL https://raw.githubusercontent.com/digileap-jp/karukaya-releases/main/install-mac.sh | sh
```

途中で「ターミナルで karukaya . と打って起動できるようにしますか？」と聞かれます。`y` を押すと、Mac のパスワードを聞かれます。中で何をしているかは [install-mac.sh](install-mac.sh) で読めます。

**ブラウザでダウンロードして入れる**：

1. `Karukaya_<版>_universal.dmg` を開き、Karukaya を「アプリケーション」にドラッグする
2. 「アプリケーション」の Karukaya を開く。「開けません」「Apple は検証できませんでした」と出たら、「完了」（または「OK」）で閉じる
3. 「システム設定」→「プライバシーとセキュリティ」を開き、下のほうの「"Karukaya" は Mac を保護するためにブロックされました」の横の「このまま開く」を押す
4. もう一度出る確認で「このまま開く」を押し、Mac のパスワードを入れる

2 回目からは、普通に開けます。うまくいかないときは、ターミナルで次を実行してから開いてください。

```bash
xattr -dr com.apple.quarantine /Applications/Karukaya.app
```

### Linux

```bash
sudo apt install ./Karukaya_<版>_amd64.deb
```

アプリの一覧から Karukaya を開けます。消すときは `sudo apt remove karukaya` です。

## ターミナルから起動する

フォルダに移って `karukaya .` と打つと、そのフォルダを Karukaya で開けます。`karukaya src/main.ts` のようにファイルも開けます。

- **Windows**：セットアップで使えるようになります。セットアップの後に開いたターミナルで使ってください（Windows Terminal は、アプリごと開き直します）
- **Mac**：Karukaya のメニューの「Karukaya」→「ターミナルから起動できるようにする…」を一度押します（Mac のパスワードを聞かれます）
- **Linux**：`.deb` を入れると使えます

## 利用条件

- Karukaya の著作権は、合同会社DigiLeap（DigiLeap LLC）にあります
- 個人・仕事のどちらでも、無料で使えます
- Karukaya のファイルを、ほかの人に配ったり、ほかの場所に置いたりしないでください。使いたい人には、このページを教えてください
- 中身を解析したり、作り変えたりしないでください
- Karukaya は「そのまま」の形で提供します。動作やファイルの内容について、DigiLeap は保証せず、使ったことで起きた損害に責任を負いません。大事なファイルは、Git などで控えを取りながら使ってください
- この条件は、予告なく変えることがあります

Karukaya が使っているライブラリのライセンスは、各版の Releases にある `THIRD-PARTY-NOTICES.txt` と、アプリの中の同じ名前のファイルにあります。

© 2026 DigiLeap LLC
