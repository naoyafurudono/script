#!/bin/sh

# pre-commit hookとして実行することで、コミットされる全てのファイルの末尾に改行が含まれることを保証します

# ステージされた追加/変更ファイル一覧を取得
files=$(git diff --cached --name-only --diff-filter=AM)
for f in $files; do
    # ファイルが存在し、かつテキストファイルの場合のみ処理
    if [ -f "$f" ] && git grep -Iq . -- "$f"; then
        # ファイルの最後の1バイトを取得し改行かチェック
        if [ "$(tail -c1 "$f")" != "" ] && [ "$(tail -c1 "$f")" != $'\n' ]; then
            echo >> "$f"         # 改行を末尾に追加
            git add "$f"         # 変更をステージに追加
        fi
    fi
done
