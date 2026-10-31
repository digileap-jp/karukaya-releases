#!/bin/sh
# Karukaya を Mac に入れる・最新の版にする。配布用のリポジトリ（digileap-jp/karukaya-releases）に置き、
# ターミナルで次のように実行してもらう（docs/release.md）。
#
#   curl -fsSL https://raw.githubusercontent.com/digileap-jp/karukaya-releases/main/install-mac.sh | sh
#
# Releases の最新の .dmg をダウンロードし、/Applications/Karukaya.app に置く。
# ターミナル（curl）でダウンロードしたものには、ブラウザと違って「インターネットから来た」印
# （com.apple.quarantine）が付かないので、最初に開くときに「プライバシーとセキュリティ」で許可しなくてよい。
# 望めば、ターミナルで `karukaya .` と打てるように /usr/local/bin/karukaya も置く。
set -eu

REPO="digileap-jp/karukaya-releases"
APP="Karukaya.app"
DEST="/Applications"
COMMAND="/usr/local/bin/karukaya"

say() { printf '%s\n' "$*"; }
fail() {
  printf 'エラー：%s\n' "$*" >&2
  exit 1
}

[ "$(uname -s)" = "Darwin" ] || fail "これは Mac 用です。Windows・Linux は https://github.com/$REPO を見てください"

if pgrep -x karukaya >/dev/null 2>&1; then
  fail "Karukaya が開いています。閉じてから、もう一度実行してください"
fi

# 最新の版と、Mac 用の .dmg の URL（jq がない Mac でも動くように、grep と sed で取り出す）
json=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest") ||
  fail "最新の版を調べられませんでした。ネットにつながっているか確かめてください"
version=$(printf '%s\n' "$json" | grep -o '"tag_name": *"[^"]*"' | head -n 1 | sed 's/.*"\([^"]*\)"$/\1/')
url=$(printf '%s\n' "$json" | grep -o '"browser_download_url": *"[^"]*_universal\.dmg"' | head -n 1 | sed 's/.*"\(https:[^"]*\)"$/\1/')
[ -n "$url" ] || fail "最新の版（$version）に Mac 用のファイルが見つかりませんでした"

tmp=$(mktemp -d)
mnt="$tmp/mnt"
cleanup() {
  if [ -d "$mnt" ]; then
    hdiutil detach -quiet "$mnt" 2>/dev/null || true
  fi
  rm -rf "$tmp"
}
trap cleanup EXIT
trap 'exit 130' INT TERM

say "Karukaya $version をダウンロードしています…"
curl -fL --progress-bar -o "$tmp/Karukaya.dmg" "$url" || fail "ダウンロードできませんでした"
mkdir "$mnt"
hdiutil attach -nobrowse -readonly -quiet -mountpoint "$mnt" "$tmp/Karukaya.dmg" ||
  fail "ダウンロードしたファイルを開けませんでした"
[ -d "$mnt/$APP" ] || fail "ダウンロードしたファイルに $APP が入っていませんでした"

# 「アプリケーション」は、管理者のユーザーならパスワードなしで書ける。書けなければ sudo で。
sudo=""
[ -w "$DEST" ] || sudo="sudo"
# 先に別の名前でコピーしてから入れ替える（途中で失敗しても、前の版が消えないように）。
$sudo rm -rf "$DEST/.$APP.new"
$sudo ditto "$mnt/$APP" "$DEST/.$APP.new" || fail "$DEST にコピーできませんでした"
$sudo xattr -dr com.apple.quarantine "$DEST/.$APP.new" 2>/dev/null || true
$sudo rm -rf "$DEST/$APP"
$sudo mv "$DEST/.$APP.new" "$DEST/$APP"
say "Karukaya $version を $DEST に入れました。Launchpad か「アプリケーション」から開けます"

# ターミナルから起動するコマンド。中身は Karukaya のメニュー「ターミナルから起動できるようにする…」で
# 置くものと同じ（crates/core/src/platform/cli.rs の mac_command_script。テストで同じか確かめている）。
command_script() {
  cat <<'EOF'
#!/bin/sh
# Karukaya をターミナルから起動する（例：karukaya .）。
# Karukaya のメニュー「ターミナルから起動できるようにする…」で置いたもの。消してもアプリには影響しない。
n=$#
for arg in "$@"; do
  case "$arg" in
    -*) continue ;;
    /*) ;;
    *) arg="$PWD/$arg" ;;
  esac
  set -- "$@" "$arg"
done
shift "$n"
exec open -b 'jp.digileap.karukaya' "$@"
EOF
}

# もう同じものがあれば何もしない。聞けない（ターミナルがない）ときも何もしない。
if [ -f "$COMMAND" ] && [ "$(cat "$COMMAND")" = "$(command_script)" ]; then
  exit 0
fi
if ! { : </dev/tty; } 2>/dev/null; then
  exit 0
fi
say ""
say "ターミナルで karukaya . と打って起動できるようにしますか？"
printf '（%s を置きます。Mac のパスワードを聞かれます）[y/N] ' "$COMMAND"
read -r answer </dev/tty || answer=""
case "$answer" in
  [yY]*)
    command_script >"$tmp/karukaya"
    sudo mkdir -p /usr/local/bin &&
      sudo cp "$tmp/karukaya" "$COMMAND" &&
      sudo chmod 755 "$COMMAND" ||
      fail "$COMMAND を置けませんでした"
    say "置きました。フォルダに移って karukaya . と打つと、そのフォルダを開けます"
    ;;
  *)
    say "置きませんでした。あとで Karukaya のメニュー「Karukaya」→「ターミナルから起動できるようにする…」からも置けます"
    ;;
esac
