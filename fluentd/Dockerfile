FROM fluent/fluentd:v1.11-1

USER root

RUN apk add --no-cache --update --virtual .build-deps \
        sudo build-base ruby-dev \
        geoip-dev geoip libmaxminddb automake autoconf libtool libc6-compat \
 && apk add geoip \
 && sudo gem install fluent-plugin-elasticsearch fluent-plugin-grok-parser fluent-plugin-geoip \
 && sudo gem sources --clear-all \
 && apk del .build-deps \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

USER fluent
