#docker network create zabbix-net
docker run --name mysql --net zabbix-net -p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=1q2w3e4r \
-e MYSQL_USER=zabbix \
-e MYSQL_PASSWORD=zabbix \
-d mysql
#------------------------------------
mysql -uroot -p1q2w3e4r -h 172.23.242.202 -e 'GRANT ALL PRIVILEGES ON `%zabbix%`.* TO 'zabbix';'
#----------------------------------------
docker run --name zabbix-srv --net zabbix-net -p 10051:10051 \
-e DB_SERVER_HOST=mysql \
-e MYSQL_USER=zabbix \
-e MYSQL_PASSWORD=zabbix \
-d zabbix/zabbix-server-mysql
#---------------------------------------
docker run --name zabbix-web --net zabbix-net -p 88:8080 \
-e DB_SERVER_HOST=zabbix-srv \
-e MYSQL_USER=zabbix \
-e MYSQL_PASSWORD=zabbix \
-e ZBX_SERVER_HOST=zabbix-srv \
-e PHP_TZ=Asia/Jerusalem \
-d zabbix/zabbix-web-apache-mysql