FROM centos:7

RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y wget libpcre3-dev build-essential libssl-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN wget http://nginx.org/download/nginx-1.13.5.tar.gz && \
    tar -zxvf nginx-1.*.tar.gz && \
    cd nginx-1.* && \
    ./configure --prefix=/opt/nginx --user=nginx --group=nginx --with-http_ssl_module --with-ipv6 --with-threads --with-stream --with-stream_ssl_module && \
    make && make install && \
    cd .. && rm -rf nginx-1.*

# nginx user
RUN adduser --system --no-create-home --disabled-login --disabled-password --group nginx

# config dirs
RUN mkdir /opt/nginx/conf/devops-http-conf && mkdir /opt/nginx/conf/devops-stream-conf

ADD nginx.conf /opt/nginx/conf/nginx.conf

WORKDIR /

EXPOSE 80 443

CMD ["/opt/nginx/sbin/nginx", "-g", "daemon off;"]
