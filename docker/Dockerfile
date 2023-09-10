FROM ubuntu:16.04
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV TZ=Asia/Seoul
ENV PYTHON_VERSION=3.7
ENV PYTHON_SUB_VERSION=6
ENV USER_NAME=user

RUN apt-get update && apt-get -y install sudo
RUN adduser --disabled-password --gecos "" ${USER_NAME} && echo "${USER_NAME}:${USER_NAME}" | chpasswd && adduser ${USER_NAME} sudo && echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USER_NAME}

RUN sudo apt-get install -y vim
RUN sudo apt-get install -y net-tools
RUN sudo apt-get install -y wget
RUN sudo apt-get install -y libcurl4-openssl-dev libssl-dev libfreetype6-dev libpng-dev libffi-dev pkg-config libxml2-dev libxmlsec1-dev
RUN sudo apt-get install -y libtiff5-dev libjpeg8-dev libopenjp2-7-dev zlib1g-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python3-tk libharfbuzz-dev libfribidi-dev libxcb1-dev
RUN sudo apt-get install -y libhdf5-dev hdf5-tools libsqlite3-dev libbz2-dev unixodbc-dev libmpc-dev libmpfr-dev libedit-dev llvm-8-dev

RUN sudo apt-get install -y build-essential
RUN sudo apt-get install -y software-properties-common
RUN sudo apt-get install -y cmake
RUN sudo apt-get install -y git

RUN sudo add-apt-repository ppa:deadsnakes/ppa
RUN sudo add-apt-repository ppa:ubuntu-toolchain-r/test
RUN sudo apt-get update
RUN sudo apt-get install -y gcc-9 g++-9
RUN sudo rm -f /usr/bin/gcc
RUN sudo ln -s /usr/bin/gcc-9 /usr/bin/gcc
RUN sudo ln -s /usr/bin/llvm-config-8 /usr/bin/llvm-config

RUN mkdir /tmp/Python
WORKDIR /tmp/Python
RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}.${PYTHON_SUB_VERSION}/Python-${PYTHON_VERSION}.${PYTHON_SUB_VERSION}.tar.xz
RUN tar xvf ./Python-${PYTHON_VERSION}.${PYTHON_SUB_VERSION}.tar.xz

WORKDIR /tmp/Python/Python-${PYTHON_VERSION}.${PYTHON_SUB_VERSION}
RUN ./configure
RUN sudo make altinstall
RUN sudo rm -rf /tmp/Python

RUN sudo ln -s /usr/local/bin/python${PYTHON_VERSION} /usr/local/bin/python
RUN sudo ln -s /usr/local/bin/pip${PYTHON_VERSION} /usr/local/bin/pip
RUN sudo apt-get install -y python-setuptools python3-dev python-augeas swig dialog

WORKDIR /home/${USER_NAME}
RUN wget https://bitbucket.org/eunjeon/mecab-ko/downloads/mecab-0.996-ko-0.9.2.tar.gz
RUN tar xvfz mecab-0.996-ko-0.9.2.tar.gz
RUN rm -f mecab-0.996-ko-0.9.2.tar.gz

WORKDIR /home/${USER_NAME}/mecab-0.996-ko-0.9.2
RUN ./configure --build=aarch64-unknown-linux-gnu
RUN sudo make
RUN sudo make check
RUN sudo make install
RUN sudo ldconfig

WORKDIR /home/${USER_NAME}
COPY ./config/pip_install.sh ./pip_install.sh
COPY ./config/additional_pip_install.sh ./additional_pip_install.sh
RUN sudo chmod 755 ./pip_install.sh
RUN sudo chmod 755 ./additional_pip_install.sh

RUN sudo ./pip_install.sh
RUN sudo ./additional_pip_install.sh

COPY ./python_package_list.txt ./python_package_list.txt
COPY ./compare_package_list.py ./compare_package_list.py

RUN sudo pip cache purge
RUN python -m notebook --generate-config
ADD ./config/jupyter_notebook_config.py /home/${USER_NAME}/.jupyter/jupyter_notebook_config.py
RUN sudo chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}

RUN wget "https://www.wfonts.com/download/data/2016/06/13/malgun-gothic/malgun.ttf"
RUN sudo mv malgun.ttf /usr/share/fonts/truetype/

RUN mkdir /home/${USER_NAME}/workspace
WORKDIR /home/${USER_NAME}/workspace

EXPOSE 8889