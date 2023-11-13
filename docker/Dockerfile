FROM ubuntu:16.04
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV TZ=Asia/Seoul
ENV USER_NAME=user
ENV PYTHON_VERSION=3.7
ENV PYTHON_SUB_VERSION=4
ENV JAVA_VERSION 8
ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk-arm64/jre
ENV PATH $PATH:$JAVA_HOME/bin

RUN apt-get update
RUN apt-get install -y openjdk-${JAVA_VERSION}-jdk
RUN apt-get install -y sudo vim net-tools wget git
RUN apt-get install -y libcurl4-openssl-dev libssl-dev libfreetype6-dev libpng-dev libffi-dev pkg-config libxml2-dev libxmlsec1-dev
RUN apt-get install -y libtiff5-dev libjpeg8-dev libopenjp2-7-dev zlib1g-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python3-tk libharfbuzz-dev libfribidi-dev libxcb1-dev
RUN apt-get install -y libhdf5-dev hdf5-tools libsqlite3-dev libbz2-dev unixodbc-dev libmpc-dev libmpfr-dev libedit-dev llvm-8-dev

RUN apt-get install -y build-essential software-properties-common make cmake
RUN apt-get install -y python-pydot python-pydot-ng graphviz
RUN ln -s /usr/bin/llvm-config-8 /usr/bin/llvm-config

RUN adduser --disabled-password --gecos "" ${USER_NAME} && echo "${USER_NAME}:${USER_NAME}" | chpasswd && adduser ${USER_NAME} sudo && echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN mkdir /home/${USER_NAME}/Python

WORKDIR /home/${USER_NAME}/Python
RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}.${PYTHON_SUB_VERSION}/Python-${PYTHON_VERSION}.${PYTHON_SUB_VERSION}.tar.xz
RUN tar xvf ./Python-${PYTHON_VERSION}.${PYTHON_SUB_VERSION}.tar.xz

WORKDIR /home/${USER_NAME}/Python/Python-${PYTHON_VERSION}.${PYTHON_SUB_VERSION}
RUN ./configure
RUN make altinstall
RUN rm -rf /home/${USER_NAME}/Python/

RUN ln -s /usr/local/bin/python${PYTHON_VERSION} /usr/local/bin/python
RUN ln -s /usr/local/bin/pip${PYTHON_VERSION} /usr/local/bin/pip
RUN apt-get install -y python-setuptools python3-dev python-augeas swig dialog

WORKDIR /home/${USER_NAME}
RUN wget https://bitbucket.org/eunjeon/mecab-ko/downloads/mecab-0.996-ko-0.9.2.tar.gz
RUN tar xvfz mecab-0.996-ko-0.9.2.tar.gz
RUN rm -f mecab-0.996-ko-0.9.2.tar.gz

WORKDIR /home/${USER_NAME}/mecab-0.996-ko-0.9.2
RUN ./configure --build=aarch64-unknown-linux-gnu
RUN make
RUN make check
RUN make install
RUN ldconfig

WORKDIR /home/${USER_NAME}
RUN wget https://bitbucket.org/eunjeon/mecab-ko-dic/downloads/mecab-ko-dic-2.1.1-20180720.tar.gz
RUN tar xvfz mecab-ko-dic-2.1.1-20180720.tar.gz
RUN rm -f mecab-ko-dic-2.1.1-20180720.tar.gz

WORKDIR /home/${USER_NAME}/mecab-ko-dic-2.1.1-20180720
RUN ./configure 
RUN make
RUN make install

WORKDIR /home/${USER_NAME}
RUN git clone https://bitbucket.org/eunjeon/mecab-python-0.996.git

WORKDIR /home/${USER_NAME}/mecab-python-0.996
RUN python setup.py build
RUN python setup.py install

WORKDIR /home/${USER_NAME}
COPY ./config/pip_install.sh ./pip_install.sh
COPY ./config/additional_pip_install.sh ./additional_pip_install.sh
RUN chmod 755 ./pip_install.sh
RUN chmod 755 ./additional_pip_install.sh

RUN ./pip_install.sh
RUN rm -rf /tmp/*
RUN ./additional_pip_install.sh
RUN pip cache purge

COPY ./python_package_list.txt ./python_package_list.txt
COPY ./compare_package_list.py ./compare_package_list.py
RUN python -m notebook --generate-config
ADD ./config/jupyter_notebook_config.py /home/${USER_NAME}/.jupyter/jupyter_notebook_config.py
RUN chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}

RUN wget "https://www.wfonts.com/download/data/2016/06/13/malgun-gothic/malgun.ttf"
RUN mv malgun.ttf /usr/share/fonts/truetype/

RUN mkdir -p /workspace/Jupyter
RUN chown -R user:user /workspace/Jupyter/

USER ${USER_NAME}
WORKDIR /workspace/Jupyter

EXPOSE 8889