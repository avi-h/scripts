docker network create zabbix-net
docker run --name mysql --net zabbix-net -p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=1q2w3e4r \
-e MYSQL_USER=zabbix \
-e MYSQL_PASSWORD=zabbix \
-e MYSQL_DATABASE=zabbix \
-d mysql
#------------------------------------
