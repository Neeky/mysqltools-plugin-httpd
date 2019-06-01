#!/bin/bash

set -eo pipefail
shopt -s nullglob

file_dir=`dirname $0`
if [ $file_dir -eq '.' ]
then
    file_dir=`pwd`
fi
cd $file_dir

if [ -d /usr/local/apr-1.7.0 ]
then
    echo "apr has been installed."
else
    tar -xvf apr-1.7.0.tar.gz
    cd apr-1.7.0
    ./configure --prefix=/usr/local/apr-1.7.0 && make && make install
    cd ..
fi

if [ -d /usr/local/apr-util-1.6.1 ]
then
    echo "arp-util has been installed ."
else
    tar -xvf apr-util-1.6.1.tar.gz
    cd apr-util-1.6.1
    ./configure --prefix=/usr/local/apr-util-1.6.1 --with-apr=/usr/local/apr-1.7.0 && make && make install
    cd ..
fi

if [ -d /usr/local/httpd-2.4.39 ]
then
    echo "httpd has been installed"
else
    tar -xvf httpd-2.4.39.tar.gz
    cd httpd-2.4.39
    ./configure --prefix=/usr/local/httpd-2.4.39/ --enable-so --enable-rewrite --enable-ssl --enable-cgi --enable-cgid \
      --enable-modules=most --enable-mods-shared=most --enable-mpms-shared=all \
      --with-apr=/usr/local/apr-1.7.0 --with-apr-util=/usr/local/apr-util-1.6.1 && make -j 2 && make install
    cd ..
    cd /usr/local/
    ln -s httpd-2.4.39 httpd
fi

