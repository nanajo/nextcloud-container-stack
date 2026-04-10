#!/bin/sh
# nextcloudのリダイレクトURL等を変更するスクリプト。
# nextcloud本体はhttp 80で待ち受けるがリバースプロキシのnginxがhttps 8443で待ち受ける為、この差を吸収する為の処理。

set -eu

CONFIG_FILE="/var/www/html/config/config.php"
OCC="/var/www/html/occ"
DONE_FLAG="/var/www/html/config/.occ-setup-done"

echo "[occ-setup] waiting for Nextcloud config.php..."
while [ ! -f "$CONFIG_FILE" ]; do
  sleep 2
done

if [ -f "$DONE_FLAG" ]; then
  echo "[occ-setup] already applied. skipping."
  exit 0
fi

echo "[occ-setup] waiting for Nextcloud to be installed..."
while :; do
  if su -s /bin/sh www-data -c "php $OCC status 2>/dev/null" | grep -q "installed: true"; then
    break
  fi
  sleep 1
done

echo "[occ-setup] applying system config via occ..."
su -s /bin/sh www-data -c "php $OCC config:system:set trusted_domains 0 --value='${TRUSTED_DOMAIN}'"
su -s /bin/sh www-data -c "php $OCC config:system:set trusted_proxies 0 --value='${TRUSTED_PROXY}'"
su -s /bin/sh www-data -c "php $OCC config:system:set overwritehost --value='${OVERWRITE_HOST}'"
su -s /bin/sh www-data -c "php $OCC config:system:set overwriteprotocol --value='${OVERWRITE_PROTOCOL}'"
su -s /bin/sh www-data -c "php $OCC config:system:set overwrite.cli.url --value='${OVERWRITE_CLI_URL}'"

touch "$DONE_FLAG"
echo "[occ-setup] done."
