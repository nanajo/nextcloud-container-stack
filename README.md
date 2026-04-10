# Usage
1. init.sh のパラメータを設定して実行
2. debian/changelogの日付とVersion stringを変更
3. container-compose.ymlを完成させ、dpkg-buildpackage -us -uc でdebをビルド