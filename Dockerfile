FROM alpine:latest

MAINTAINER kukam "kukam@freebox.cz"

# Install base packages
RUN apk --update --no-cache add bash apache2 \
    && mkdir -p /PWE/webapps/myproject \
    && sed -i 's/^#ServerName.*/ServerName apache/' /etc/apache2/httpd.conf \
    && sed -i 's#PidFile "/run/.*#Pidfile "/run/httpd.pid"#g'  /etc/apache2/conf.d/mpm.conf \
    && sed -i 's/^LoadModule mpm_prefork_module/#LoadModule mpm_prefork_module/' /etc/apache2/httpd.conf \
    && sed -i 's/^#LoadModule mpm_worker_module/LoadModule mpm_worker_module/' /etc/apache2/httpd.conf \
    && sed -i 's#^ErrorLog.*#ErrorLog /dev/stderr\nTransferLog /dev/stdout\n#' /etc/apache2/httpd.conf \
    && rm -fr /var/cache/apk/*

COPY ./fastcgi.conf /etc/apache2/conf.d/fastcgi.conf

EXPOSE 80

CMD ["httpd", "-DFOREGROUND"]
