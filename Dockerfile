#VERSION 1.0.1
FROM keboola/base
MAINTAINER Petr Konupek <petr@konupek.cz>

# update
RUN yum -y update

# install base packages
RUN yum -y groupinstall "Development Tools"
RUN yum -y install erlang gcc gcc-c++ kernel-devel-`uname -r` make perl sqlite-devel
RUN yum -y install bzip2 bzip2-devel zlib-devel
RUN yum -y install ncurses-devel readline-devel tk-devel
RUN yum -y install net-tools nfs-utils openssl-devel
RUN yum -y install git screen tmux wget zsh

# fix paths
RUN echo 'Defaults  secure_path=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin' >> /etc/sudoers.d

# install rsyslog v7
RUN wget http://rpms.adiscon.com/v7-stable/rsyslog.repo -O /etc/yum.repos.d/rsyslog.repo
RUN yum -y install rsyslog rsyslog-docs

# install python 2.7
RUN /usr/bin/curl -s 'http://www.python.org/download/releases/' | gawk 'match($0, /The current production versions are <strong>([0-9.]+)<\/strong>/, ary) {print ary[1]}' > PYTHON_VERSION
RUN cat PYTHON_VERSION | { read VERSION; wget -O Python-${VERSION}.tar.xz http://python.org/ftp/python/${VERSION}/Python-${VERSION}.tar.xz && tar -xf Python-${VERSION}.tar.xz; }
RUN cat PYTHON_VERSION | { read VERSION; cd Python-${VERSION} && ./configure --prefix=/usr/local && make && make altinstall; }
RUN rm -rf Python*
RUN ln -s /usr/local/bin/python2.7 /usr/local/bin/python

# bootstrap python setuptools and distribute
RUN /usr/bin/curl -O http://python-distribute.org/distribute_setup.py
RUN /usr/local/bin/python distribute_setup.py
RUN rm -rf distribute_setup.py
RUN easy_install pip