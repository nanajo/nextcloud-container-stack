#!/bin/bash

#------------#
# Preprocess #
#------------#
# パラメータ
APP_NAME="nextcloud-container-stack"
USER_NAME="nextcloud-container-stack"
USER_UID="30001"
GROUP_NAME="nextcloud-container-stack"
GROUP_GID="30001"

# CWD変更
cd $(dirname $0)

#----------#
# Function #
#----------#
# コンテンツの更新
update_file_contents() {
    # テンプレートのアプリケーション名 template-application を正式名称に書き換え
    FILE_LIST="conf.d/env debian/install debian/changelog debian/control template-application.service"
    for FILE_NAME in ${FILE_LIST};
    do
        sed -i "s/template-application/${APP_NAME}/g" ${FILE_NAME}
    done

    # conf.d/env の USER_NAME,USER_UID,GROUP_NAME,GROUP_GID を書き換え
    sed -i "s/^USER_NAME=\"\"$/USER_NAME=\"${USER_NAME}\"/g" conf.d/env
    sed -i "s/^USER_UID=\"\"$/USER_UID=\"${USER_UID}\"/g" conf.d/env
    sed -i "s/^GROUP_NAME=\"\"$/GROUP_NAME=\"${GROUP_NAME}\"/g" conf.d/env
    sed -i "s/^GROUP_GID=\"\"$/GROUP_GID=\"${GROUP_GID}\"/g" conf.d/env

    # postinst, prerm の APP_NAME 書き換え
    sed -i "s/^APP_NAME=\"\"$/APP_NAME=\"${APP_NAME}\"/g" debian/template-application.postinst
    sed -i "s/^APP_NAME=\"\"$/APP_NAME=\"${APP_NAME}\"/g" debian/template-application.prerm

    # systemd ユニットファイルの User, Group, 各パスの書き換え
    sed -i "s/user_name/${USER_NAME}/g" template-application.service
    sed -i "s/group_name/${GROUP_NAME}/g" template-application.service
    sed -i "s/template-application/${APP_NAME}/g" template-application.service

    # メトリクス収集用のpodman-exporter, alloyのコンテナ名の書き換え
    sed -i  "s/container_name: podman-exporter/container_name: ${APP_NAME}_podman-exporter/g" compose.d/container-compose.yml
    sed -i  "s/container_name: alloy/container_name: ${APP_NAME}_alloy/g" compose.d/container-compose.yml
}

# ファイル名の更新
update_file_name(){
    FILE_LIST="template-application.service debian/template-application.postinst debian/template-application.prerm"
    for OLD_NAME in ${FILE_LIST};
    do
        NEW_NAME=${OLD_NAME/template-application/${APP_NAME}}
        mv ${OLD_NAME} ${NEW_NAME}
    done
}


#------#
# main #
#------#
update_file_contents
update_file_name