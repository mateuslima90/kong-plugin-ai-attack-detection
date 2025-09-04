FROM kong:3.3.0-alpine
USER root

RUN mkdir -p /usr/local/kong \
    && chown -R kong:0 /usr/local/kong \
    && chmod -R g=u /usr/local/kong




RUN apk add build-base lua5.1-dev wget

RUN wget --progress=dot:giga https://luarocks.org/releases/luarocks-3.12.2.tar.gz \
    && tar xf luarocks-3.12.2.tar.gz

WORKDIR /luarocks-3.12.2

RUN ./configure --prefix=/usr/local --with-lua-include=/usr/include/ \
    && make \
    && make install

RUN luarocks --version

RUN apk add --no-cache \
      build-base \
      lua5.1-dev \
      luarocks \
      git \
      unzip \
      openssl-dev


COPY *.rockspec /custom-plugins/
WORKDIR /custom-plugins
COPY kong /custom-plugins/kong
RUN luarocks make *.rockspec

USER kong
