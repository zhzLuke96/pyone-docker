FROM alpine:latest

COPY aria2.conf /data/aria2/
COPY run.sh ~/

RUN mkdir -p /root/PyOne /data/db /data/log /data/aria2/download && \
    touch /data/aria2/aria2.session && \
    chmod +x ~/run.sh


RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.9/main" > /etc/apk/repositories && \
    # apk update && \
    apk add aria2 sudo curl python py-pip git bash mongodb redis

RUN git clone https://github.com/abbeyokgo/PyOne.git; \
	cd PyOne; \
	pip install -r requirements.txt; \
	pip install gunicorn eventlet; \
    cp self_config.py.sample config.py; \
	cp supervisord.conf.sample supervisord.conf
	
EXPOSE 80
ENTRYPOINT ["run.sh"]
