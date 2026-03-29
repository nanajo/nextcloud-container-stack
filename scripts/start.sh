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
    echo -e "$1" 1>&2
    exit 1
}

# カスタムデータディレクトリのアップデート
update_custom_data_dir_path() {
    if [ -z ${CUSTOM_APP_DATA_DIR} ]; then
        export APP_DATA_DIR="${CUSTOM_APP_DATA_DIR}"
    fi
}

# podman.sock の有効化
enable_podman_sock() {
    if [ "${ENABLE_PODMAN_SOCK}" == "true" ]; then
        systemctl --user enable --now podman.socket
    elif [ "${ENABLE_PODMAN_SOCK}" == "false" ]; then
        systemctl --user disable --now podman.socket
    else
        err "[ERR] Syntax error: Valid value for ENABLE_PODMAN_SOCK is true or false."
    fi
}



# コンテナの起動
run_container() {
    podman compose -f ${APP_DIR_ROOT}/compose.d/container-compose.yml up -d
}

#------#
# main #
#------#
source /usr/share/${APP_NAME}/scripts/include/start
update_custom_data_dir_path
enable_podman_sock
run_container