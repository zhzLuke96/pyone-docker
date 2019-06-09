FROM alpine

COPY aria2.conf /data/aria2/
COPY run.sh /

RUN mkdir -p /PyOne /data/db /data/log /data/aria2/download && \
    touch /data/aria2/aria2.session && \
    chmod +x /run.sh


RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    apk update

# python3
RUN RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

RUN apk add aria2 sudo curl git bash mongodb redis python3-dev gcc libc-dev linux-headers musl-dev

RUN git clone https://github.com/abbeyokgo/PyOne.git; \
    cd /PyOne; \
    pip install -r requirements.txt
        
RUN cd /PyOne; \
    cp self_config.py.sample config.py; \
    cp supervisord.conf.sample supervisord.confi

EXPOSE 80
ENTRYPOINT ["/run.sh"]