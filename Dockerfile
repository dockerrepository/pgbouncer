FROM alpine:latest AS build_stage

MAINTAINER nielsonnas@gmail.com

RUN apk --update add git python py-pip build-base automake libtool m4 autoconf libevent-dev openssl-dev c-ares-dev
RUN pip install docutils
RUN ln -s /usr/bin/rst2man.py /bin/rst2man

RUN git clone https://github.com/pgbouncer/pgbouncer.git /src/pgbouncer
RUN cd /src/pgbouncer && git checkout pgbouncer_1_7_2

WORKDIR /src/pgbouncer
RUN mkdir /pgbouncer
RUN git submodule init
RUN git submodule update
RUN ./autogen.sh
RUN ./configure --prefix=/pgbouncer --with-libevent=/usr/lib
RUN make
RUN make install


FROM alpine:latest
RUN apk --update add libevent openssl c-ares
WORKDIR /
RUN ls /
COPY --from=build_stage /pgbouncer /opt/pgbouncer
RUN ln -s /opt/pgbouncer/bin/pgbouncer /bin/pgbouncer
ADD entrypoint.sh /
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]