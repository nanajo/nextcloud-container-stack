#!/bin/bash

#------------#
# Preprocess #
#------------#

# 環境変数のロード
set -a
source /usr/share/${APP_NAME}/conf.d/env
source /etc/${APP_NAME}/custom.env
set +a

# podman.sock 制御用環境変数
export XDG_RUNTIME_DIR="/run/user/${USER_UID}"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${USER_UID}/bus"

cd ${USER_HOME_DIR}

#----------#
# Function #
#----------#

# 汎用エラー
err() {
    echo "$1" 1>&2
    exit 1
}

# カスタムデータディレクトリのアップデート
update_custom_data_dir_path() {
    if [ -z "${APP_DATA_DIR:-}" ]; then
        export APP_DATA_DIR="${DATA_DIR_ROOT}/appdata"
    fi
}

# podman.sock の有効化
enable_podman_sock() {
    systemctl --user enable --now podman.socket
}

# コンテナの起動
run_container() {
    podman compose -f ${APP_DIR_ROOT}/compose.d/container-compose.yml up -d
}



#------#
# main #
#------#
# カスタムデータディレクトリ設定のロード
update_custom_data_dir_path
# パッケージ別カスタムスクリプトの読み込み
source /usr/share/${APP_NAME}/scripts/include/start
# podman.sock の有効化
enable_podman_sock
# コンテナスタックの起動
run_container