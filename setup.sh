#!/bin/sh

# データベースファルの作成

sqlite3 docManager/lib/databases/docManager.db < docManager/lib/databases/docManager.sql

# パスワードファイルの作成(不要)

#htpasswd -c -b .htpasswd admin admin
#htpasswd -b .htpasswd user user
#htpasswd -b .htpasswd guest guest

mv .htpasswd /var/www/

# ファイル属性の変更

chmod 755 docManager/*.rb
chmod 777 docManager/files
chmod 777 docManager/lib/databases
chmod 777 docManager/lib/databases/docManager.db

