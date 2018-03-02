FROM alpine:latest

MAINTAINER kukam "kukam@freebox.cz"

RUN apk --update --no-cache add bash apache2-proxy \
    && mkdir -p /PWE/webapps/myproject \
    && sed -i 's/^#ServerName.*/ServerName localhost/' /etc/apache2/httpd.conf \
    && sed -i 's/^LoadModule mpm_prefork_module/#LoadModule mpm_prefork_module/' /etc/apache2/httpd.conf \
    && sed -i 's/^#LoadModule mpm_event_module/LoadModule mpm_event_module/' /etc/apache2/httpd.conf \
    && sed -i 's/^#LoadModule slotmem_shm_module/LoadModule slotmem_shm_module/' /etc/apache2/httpd.conf \
    && sed -i 's#^ErrorLog.*#ErrorLog /dev/stderr\nTransferLog /dev/stdout\n#' /etc/apache2/httpd.conf \
    && sed -i 's#PidFile "/run/.*#Pidfile "/run/httpd.pid"#g'  /etc/apache2/conf.d/mpm.conf \
    && rm -fr /var/cache/apk/*

COPY ./fastcgi.conf /etc/apache2/conf.d/fastcgi.conf

EXPOSE 80

CMD ["httpd", "-DFOREGROUND"]
