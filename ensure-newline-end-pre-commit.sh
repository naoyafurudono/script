#!/bin/sh

# ステージされた追加/変更ファイル一覧を取得
files=$(git diff --cached --name-only --diff-filter=AM)

# 末尾改行を補完する処理
for f in $files; do
    if [ -f "$f" ] && git grep -Iq . -- "$f"; then  # テキストファイルのみ対象
        if [ "$(tail -c1 "$f")" != "" ] && [ "$(tail -c1 "$f")" != $'\n' ]; then
            echo >> "$f"      # 末尾に改行を追加
            git add "$f"      # 修正をステージに追加
        fi
    fi
done

# 変更がない場合、コミットを中止
if git diff --cached --exit-code > /dev/null; then
    echo "No changes left to commit after fixing newline issues."
    exit 1  # コミットを中断
fi

exit 0  # 通常のコミット続行
