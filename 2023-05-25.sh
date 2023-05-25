# 変数
OMEKA_PATH=/home/bitnami/htdocs/omeka_s0525

## ハイフンは含めない
DBNAME=omeka_s0525
VERSION=4.0.1

#############

set -e

mkdir $OMEKA_PATH

# Omekaのダウンロード
wget https://github.com/omeka/omeka-s/releases/download/v$VERSION/omeka-s-$VERSION.zip
unzip -q omeka-s-$VERSION.zip

mv omeka-s/* $OMEKA_PATH

# .htaccessの移動
mv omeka-s/.htaccess $OMEKA_PATH

# 不要なフォルダの削除
rm -rf omeka-s
rm omeka-s-$VERSION.zip

# 元からあったindex.htmlを削除（もし存在すれば）
if [ -e $OMEKA_PATH/index.html ]; then
  rm $OMEKA_PATH/index.html
fi

# データベースの作成

cat <<EOF > sql.cnf
[client]
user = root
password = $(cat /home/bitnami/bitnami_application_password)
host = localhost
EOF

mysql --defaults-extra-file=sql.cnf -e "create database $DBNAME";

# Omeka Sの設定

cat <<EOF > $OMEKA_PATH/config/database.ini
user = root
password = $(cat bitnami_application_password)
dbname = $DBNAME
host = localhost
EOF

# sudo chown -R daemon:daemon $OMEKA_PATH/files
# sudo apt install imagemagick -y
sudo apt install --no-install-recommends libvips-tools -y

# Module

cd $OMEKA_PATH/modules

wget https://github.com/Daniel-KM/Omeka-S-module-EasyAdmin/releases/download/3.4.10/EasyAdmin-3.4.10.zip
unzip EasyAdmin-3.4.10.zip
rm EasyAdmin-3.4.10.zip
wget https://github.com/Daniel-KM/Omeka-S-module-Log/releases/download/3.4.15/Log-3.4.15.zip
unzip Log-3.4.15.zip
rm Log-3.4.15.zip
wget https://github.com/Daniel-KM/Omeka-S-module-Generic/releases/download/3.4.43/Generic-3.4.43.zip
unzip Generic-3.4.43.zip
rm Generic-3.4.43.zip
wget https://github.com/Daniel-KM/Omeka-S-module-IiifServer/releases/download/3.6.13/IiifServer-3.6.13.zip
unzip IiifServer-3.6.13.zip
rm IiifServer-3.6.13.zip
wget https://github.com/Daniel-KM/Omeka-S-module-ImageServer/releases/download/3.6.13/ImageServer-3.6.13.zip
unzip ImageServer-3.6.13.zip
rm ImageServer-3.6.13.zip

sudo chown -R daemon:daemon $OMEKA_PATH/files
sudo chown -R daemon:daemon $OMEKA_PATH/modules
sudo chown -R daemon:daemon $OMEKA_PATH/themes