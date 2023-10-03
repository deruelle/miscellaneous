#!/bin/bash
# ---------
# Script to download sources, build and install GnuPG 2.x.x

# Set version of new gpg
GNUPG_VER=2.4.0

sudo apt-get update
sudo apt-get -y install libgnutls-dev bzip2 make gettext texinfo gnutls-bin libgnutls28-dev build-essential libbz2-dev \
zlib1g-dev libncurses5-dev libsqlite3-dev libldap2-dev || apt-get -y install libgnutls28-dev bzip2 make gettext texinfo \
gnutls-bin build-essential libbz2-dev zlib1g-dev libncurses5-dev libsqlite3-dev libldap2-dev
mkdir -p /var/src/gnupg-$GNUPG_VER && cd /var/src/gnupg-$GNUPG_VER
gpg --list-keys
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 249B39D24F25E3B6 04376F3EE0856959 2071B08A33BD3F06
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 8A861B1C7EFD60D9 5B80C5754298F0CB55D8ED6ABCEF7E294B092E28
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 6DAA6E64A76D2840571B4902528897B826403ADA
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys AC8E115BF73E2D8D47FA9908E98E9B2D19C6C8BD
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 02F38DFF731FF97CB039A1DA549E695E905BA208

# Set versions of current helper tools necessary for gpg
LIBGPG_ERROR_VER=1.46
LIBGCRYPT_VER=1.10.1
LIBKSBA_VER=1.6.3
LIBASSUAN_VER=2.5.5
NTBTLS_VER=0.3.1
NPTH_VER=1.6
PINENTRY_VER=1.2.1
GPGME_VER=1.18.0
SCUTE_VER=1.7.0

# Download source code for each tool.
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
wget -c https://www.gnupg.org/ftp/gcrypt/ntbtls/ntbtls-$NTBTLS_VER.tar.bz2 && \
wget -c https://www.gnupg.org/ftp/gcrypt/ntbtls/ntbtls-$NTBTLS_VER.tar.bz2.sig && \
wget -c https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-$PINENTRY_VER.tar.bz2 && \
wget -c https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-$PINENTRY_VER.tar.bz2.sig && \
wget -c https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-$GPGME_VER.tar.bz2 && \
wget -c https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-$GPGME_VER.tar.bz2.sig && \
wget -c https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GNUPG_VER.tar.bz2 && \
wget -c https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GNUPG_VER.tar.bz2.sig && \
# Getting Scute from git, since the old 1.7.0 release has a bug which fails if certain tools aren't installed.
git clone git://git.gnupg.org/scute.git
mv scute scute-$SCUTE_VER

# Verify everything but Scute
gpg --verify libgpg-error-$LIBGPG_ERROR_VER.tar.gz.sig && tar -xzf libgpg-error-$LIBGPG_ERROR_VER.tar.gz && \
gpg --verify libgcrypt-$LIBGCRYPT_VER.tar.gz.sig && tar -xzf libgcrypt-$LIBGCRYPT_VER.tar.gz && \
gpg --verify libassuan-$LIBASSUAN_VER.tar.bz2.sig && tar -xjf libassuan-$LIBASSUAN_VER.tar.bz2 && \
gpg --verify libksba-$LIBKSBA_VER.tar.bz2.sig && tar -xjf libksba-$LIBKSBA_VER.tar.bz2 && \
gpg --verify npth-$NPTH_VER.tar.bz2.sig && tar -xjf npth-$NPTH_VER.tar.bz2 && \
gpg --verify ntbtls-$NTBTLS_VER.tar.bz2.sig && tar -xjf ntbtls-$NTBTLS_VER.tar.bz2 && \
gpg --verify pinentry-$PINENTRY_VER.tar.bz2.sig && tar -xjf pinentry-$PINENTRY_VER.tar.bz2 && \
gpg --verify gpgme-$GPGME_VER.tar.bz2.sig && tar -xjf gpgme-$GPGME_VER.tar.bz2 && \
gpg --verify gnupg-$GNUPG_VER.tar.bz2.sig && tar -xjf gnupg-$GNUPG_VER.tar.bz2 && \

# Compiling and installing
cd libgpg-error-$LIBGPG_ERROR_VER && ./configure && make && sudo make install && cd ../ && \
cd libgcrypt-$LIBGCRYPT_VER && ./configure && make && sudo make install && cd ../ && \
cd libassuan-$LIBASSUAN_VER && ./configure && make && sudo make install && cd ../ && \
cd libksba-$LIBKSBA_VER && ./configure && make && sudo make install && cd ../ && \
cd npth-$NPTH_VER && ./configure && make && sudo make install && cd ../ && \
cd ntbtls-$NTBTLS_VER && ./configure && make && sudo make install && cd ../ && \

# Had to disable pinentry-efl as it expects openssl 1.1 which has been replaced by openssl 3.
cd pinentry-$PINENTRY_VER && ./configure --enable-pinentry-curses --disable-pinentry-qt4 --disable-pinentry-efl && \
make && sudo make install && cd ../ && \
cd gpgme-$GPGME_VER && ./configure && make && sudo make install && cd ../ && \
cd scute-$SCUTE_VER && ./autogen.sh && ./configure --enable-maintainer-mode && make && sudo make install && cd ../ && \
cd gnupg-$GNUPG_VER && ./configure && make && sudo make install && \

sudo echo "/usr/local/lib" > /etc/ld.so.conf.d/gpg2.conf && sudo ldconfig -v && \
echo "Complete!!!"
