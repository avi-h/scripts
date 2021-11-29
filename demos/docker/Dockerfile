FROM ubuntu:latest
RUN apt-get update -y
RUN apt-get install vim ssh bash-completion net-tools -y
RUN service ssh start
EXPOSE 22
CMD [ "/usr/sbin/sshd","-D"]