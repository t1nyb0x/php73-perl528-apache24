FROM centos:7.6.1810

# install necesasry packages
RUN set -x && \
    yum install -y epel-release && \
    yum install -y screen gcc git wget openssl curl && \
    yum install -y gmp-devel libc-client-devel bzip2-devel enchant-devel libwebp-devel libXpm-devel openldap openldap-devel php-pspell aspell-devel readline-devel libtidy-devel libxslt-devel libxml2-devel openssl-devel curl-devel libjpeg-devel libpng-devel freetype-devel autoconf && \
    yum install -y uw-imap-devel perl perl-cgi httpd httpd-devel postgresql-devel mysql-devel && \
    yum remove -y libzip libzip-devel && \
# reinstall libzip
    wget -q https://nih.at/libzip/libzip-1.2.0.tar.gz && \
    tar -zxf libzip-1.2.0.tar.gz && \
    cd libzip-1.2.0 && \
    ./configure && \
    make && \
    make install && \
    cd ../ && \
    rm -f libzip-1.2.0.tar.gz && \
    rm -rf libzip-1.2.0 && \
# install perl
    cd /usr/local/src && \
    wget -q https://www.cpan.org/src/5.0/perl-5.28.1.tar.gz && \
    tar -xzf ./perl-5.28.1.tar.gz && \
    cd ./perl-5.28.1 && \
    ./Configure -des -Dprefix=/usr/local/perl -Dusethreads -Uversiononly && \
    make && make install && \
    cd ../ && \
    rm -f ./perl-5.28.1.tar.gz && \
    rm -rf ./perl-5.28.1 && \
# create symbolic link
    cd /usr/bin && mv perl perl.old && \
    ln -s /usr/local/perl/bin/perl /usr/bin/perl && \
    cd / && \
    ln -s /usr/lib64/libc-client.so /usr/lib/libc-client.so && \
    cp -frp /usr/lib64/libldap* /usr/lib/ && \
# install php
    wget -q http://php.net/distributions/php-7.3.1.tar.gz && \
    tar -zxf php-7.3.1.tar.gz && \
    cd ./php-7.3.1 && \
    ./buildconf --force && \
    export LDFLAGS=-llber && \
    ./configure \
    --prefix=/usr/local/php \
    --with-config-file-path=/usr/local/php/etc \
    --with-config-file-scan-dir=/usr/local/php/conf.d \
    --with-sqlite3 \
    --with-pdo-sqlite \
    --with-mysqli=mysqlnd \
    --with-pdo-mysql=mysqlnd \
    --enable-posix \
    --enable-pcntl \
    --enable-shmop \
    --enable-sysvshm \
    --enable-sysvsem \
    --enable-sysvmsg \
    --enable-phar \
    --enable-zip \
    --with-zlib \
    --with-zlib-dir \
    --with-bz2 \
    --with-gd \
    --enable-gd-jis-conv \
    --with-webp-dir \
    --with-jpeg-dir \
    --with-png-dir \
    --with-xpm-dir \
    --with-freetype-dir \
    --enable-exif \
    --enable-json \
    --enable-libxml \
    --with-libxml-dir \
    --enable-xml \
    --enable-xmlreader \
    --enable-xmlwriter \
    --enable-simplexml \
    --with-pear \
    --with-xsl \
    --enable-dom \
    --enable-soap \
    --enable-wddx \
    --with-xmlrpc \
    --enable-ctype \
    --enable-filter \
    --with-pcre-regex \
    --with-pcre-jit \
    --with-enchant \
    --with-pspell \
    --enable-fileinfo \
    --enable-mbstring \
    --with-iconv \
    --enable-hash \
    --with-openssl \
    --enable-bcmath \
    --with-gmp \
    --enable-session \
    --enable-sockets \
    --enable-ftp \
    --with-curl \
    --with-ldap \
    --with-ldap-sasl \
    --with-imap \
    --with-kerberos \
    --with-imap-ssl \
    --enable-calendar \
    --with-gettext \
    --with-tidy \
    --with-readline \
    --enable-tokenizer \
    --enable-opcache \
    --enable-cli \
    --enable-cgi \
    --enable-fpm \
    --enable-phpdbg \
    --with-apxs2=/usr/bin/apxs \
    --with-mysqli=mysqlnd \
    --with-pgsql=/usr/local/pgsql \
    --enable-mysqlnd \
    --with-pdo-mysql=mysqlnd \
    --with-pdo-pgsql=/usr/local/pgsql \
    --without-libzip && \
    make && make install && \
    cp php.ini-production /usr/local/php/etc/php.ini && \
    echo export PATH=$PATH:/usr/local/php/bin >> /etc/profile && source /etc/profile && \
    cd ../ && \
    rm -r ./php-7.3.1 && \
    rm -rf ./php-7.3.1.tar.gz && \
# install perl modules
    yum install -y perl-devel && \
    cd /bin && curl -LO http://xrl.us/cpanm && \
    chmod +x cpanm && \
    cpanm HTML::Entities \
    Scalar::Util  \
    CGI::Cookie \
    DBI \
    DBD::mysql \
    DBD::Pg \
    Image::Size \
    File::Spec \
    LWP::UserAgent \
    parent && \
    systemctl enable httpd