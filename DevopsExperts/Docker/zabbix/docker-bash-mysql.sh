#docker network create zabbix-net
docker run --name mysql --net zabbix-net -p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=password \
-e MYSQL_USER=zabbix \
-e MYSQL_PASSWORD=zabbix \
-d mysql
#------------------------------------
mysql -uroot -ppassword -h 172.23.242.202 -e 'GRANT ALL PRIVILEGES ON `%zabbix%`.* TO 'zabbix';'