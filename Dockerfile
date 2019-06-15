FROM python:2.7.15-stretch

WORKDIR /
RUN mkdir -p /data/db /data/log /data/aria2/download && \
    touch /data/aria2/aria2.session

RUN git clone https://github.com/abbeyokgo/PyOne.git --depth=1; \
    mv ./PyOne /root/PyOne
COPY aria2.conf /data/aria2/

WORKDIR /root/PyOne/

RUN sed -i "s@http://deb.debian.org@http://mirrors.163.com@g" /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y curl redis-server aria2 && \
    pip install -r requirements.txt

RUN cp self_config.py.sample self_config.py && \
    curl https://www.mongodb.org/static/pgp/server-3.6.asc | apt-key add - && \
    echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/3.6 main" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /	
COPY start.sh /
RUN chmod +x /start.sh

EXPOSE 80

ENTRYPOINT ["/run.sh"]