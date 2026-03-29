#!/bin/bash
#------------#
# Preprocess #
#------------#

# 環境変数のロード
set -a
source /usr/share/${APP_NAME}/conf.d/env
source /etc/${APP_NAME}/custom.env
set +a

cd ${USER_HOME_DIR}

#----------#
# Function #
#----------#

# 汎用エラー
err() {
    echo "$1" 1>&2
    exit 1
}

# podman.sock の無効化
disable_podman_sock() {
    systemctl --user disable --now podman.socket
}

# コンテナ停止
stop_container() {
    podman compose -f ${APP_DIR_ROOT}/compose.d/container-compose.yml down
}

#------#
# main #
#------#
source /usr/share/${APP_NAME}/scripts/include/stop
disable_podman_sock
stop_container