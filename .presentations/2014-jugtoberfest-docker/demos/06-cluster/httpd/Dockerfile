FROM fedora:latest

RUN yum -y update && yum clean all
RUN yum -y install httpd mod_cluster && yum clean all 

RUN sed -i "s|LoadModule proxy_balancer_module|#LoadModule proxy_balancer_module|" /etc/httpd/conf.modules.d/00-proxy.conf  

ADD mod_cluster.conf /etc/httpd/conf.d/mod_cluster.conf

EXPOSE 80

CMD ["/sbin/httpd", "-DFOREGROUND"]
