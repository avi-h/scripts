#docker network create zabbix-net
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