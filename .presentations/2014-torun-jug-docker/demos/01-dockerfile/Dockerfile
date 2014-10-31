FROM fedora:latest
RUN yum -y install httpd && yum clean all
CMD ["/sbin/httpd", "-D", "FOREGROUND"]
