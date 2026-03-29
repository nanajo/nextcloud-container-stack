#!/bin/sh
# nextcloud開始時のカスタムEntrypointスクリプト。
# DBのパスワードを環境変数ではなくpodman secretで処理するため。

set -eu
export MYSQL_PASSWORD="$(cat /run/secrets/nextcloud_db_user_pw)"
exec /entrypoint.sh apache2-foreground