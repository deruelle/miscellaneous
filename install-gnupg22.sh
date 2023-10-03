#!/bin/bash
# ---------
# Script to build and install GnuPG 2.2.x

GNUPG_VER=2.2.15

apt-get update
apt-get -y install libgnutls-dev bzip2 make gettext texinfo gnutls-bin libgnutls28-dev build-essential libbz2-dev zlib1g-dev libncurses5-dev libsqlite3-dev libldap2-dev || apt-get -y install libgnutls28-dev bzip2 make gettext texinfo gnutls-bin build-essential libbz2-dev zlib1g-dev libncurses5-dev libsqlite3-dev libldap2-dev
mkdir -p /var/src/gnupg-$GNUPG_VER && cd /var/src/gnupg-$GNUPG_VER
gpg --list-keys
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 249B39D24F25E3B6 04376F3EE0856959 2071B08A33BD3F06 8A861B1C7EFD60D9

LIBGPG_ERROR_VER=1.36
LIBGCRYPT_VER=1.8.4
LIBKSBA_VER=1.3.5
LIBASSUAN_VER=2.5.3
NPTH_VER=1.6
PINENTRY_VER=1.1.0

wget -c https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-$LIBGPG_ERROR_VER.tar.gz && \
wget -c https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-$LIBGPG_ERROR_VER.tar.gz.sig && \
wget -c https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-$LIBGCRYPT_VER.tar.gz && \
wget -c https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-$LIBGCRYPT_VER.tar.gz.sig && \
wget -c https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-$LIBASSUAN_VER.tar.bz2 && \
wget -c https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-$LIBASSUAN_VER.tar.bz2.sig && \
wget -c https://www.gnupg.org/ftp/gcrypt/libksba/libksba-$LIBKSBA_VER.tar.bz2 && \
wget -c https://www.gnupg.org/ftp/gcrypt/libksba/libksba-$LIBKSBA_VER.tar.bz2.sig && \
wget -c https://www.gnupg.org/ftp/gcrypt/npth/npth-$NPTH_VER.tar.bz2 && \
wget -c https://www.gnupg.org/ftp/gcrypt/npth/npth-$NPTH_VER.tar.bz2.sig && \
wget -c https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-$PINENTRY_VER.tar.bz2 && \
wget -c https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-$PINENTRY_VER.tar.bz2.sig && \
wget -c https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GNUPG_VER.tar.bz2 && \
wget -c https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GNUPG_VER.tar.bz2.sig && \
gpg --verify libgpg-error-$LIBGPG_ERROR_VER.tar.gz.sig && tar -xzf libgpg-error-$LIBGPG_ERROR_VER.tar.gz && \
gpg --verify libgcrypt-$LIBGCRYPT_VER.tar.gz.sig && tar -xzf libgcrypt-$LIBGCRYPT_VER.tar.gz && \
gpg --verify libassuan-$LIBASSUAN_VER.tar.bz2.sig && tar -xjf libassuan-$LIBASSUAN_VER.tar.bz2 && \
gpg --verify libksba-$LIBKSBA_VER.tar.bz2.sig && tar -xjf libksba-$LIBKSBA_VER.tar.bz2 && \
gpg --verify npth-$NPTH_VER.tar.bz2.sig && tar -xjf npth-$NPTH_VER.tar.bz2 && \
gpg --verify pinentry-$PINENTRY_VER.tar.bz2.sig && tar -xjf pinentry-$PINENTRY_VER.tar.bz2 && \
gpg --verify gnupg-$GNUPG_VER.tar.bz2.sig && tar -xjf gnupg-$GNUPG_VER.tar.bz2 && \
cd libgpg-error-$LIBGPG_ERROR_VER && ./configure && make && make install && cd ../ && \
cd libgcrypt-$LIBGCRYPT_VER && ./configure && make && make install && cd ../ && \
cd libassuan-$LIBASSUAN_VER && ./configure && make && make install && cd ../ && \
cd libksba-$LIBKSBA_VER && ./configure && make && make install && cd ../ && \
cd npth-$NPTH_VER && ./configure && make && make install && cd ../ && \
cd pinentry-$PINENTRY_VER && ./configure --enable-pinentry-curses --disable-pinentry-qt4 && \
make && make install && cd ../ && \
cd gnupg-$GNUPG_VER && ./configure && make && make install && \
echo "/usr/local/lib" > /etc/ld.so.conf.d/gpg2.conf && ldconfig -v && \
echo "Complete!!!"
