#基础镜像
FROM debian:bullseye

LABEL maintainer="wephoon<wephoon@outlook.com>"

#达梦数据库的路径
ARG DM_HOME_PATH=/home/dmdba
ARG DM_INSTALL_PATH=${DM_HOME_PATH}/dmdbas
ARG DM_DATA_PATH=${DM_INSTALL_PATH}/data
ARG DM_SERVER_BIN=${DM_INSTALL_PATH}/bin

ADD docker-entrypoint.sh ${DM_HOME_PATH}/
RUN groupadd dinstall && useradd -g dinstall -m -d ${DM_HOME_PATH} -s /bin/bash dmdba

WORKDIR ${DM_HOME_PATH}

#下载并安装达梦数据库
RUN set -xe \
      && /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' > /etc/timezone \
      # && mv /etc/apt/sources.list /etc/apt/sources.list.bak \
      # && { echo 'deb http://mirrors.aliyun.com/debian/ bullseye main non-free contrib'; echo 'deb-src http://mirrors.aliyun.com/debian/ bullseye main non-free contrib'; echo 'deb http://mirrors.aliyun.com/debian-security/ bullseye-security main'; echo 'deb-src http://mirrors.aliyun.com/debian-security/ bullseye-security main'; echo 'deb http://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib'; echo 'deb-src http://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib'; echo 'deb http://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib'; echo 'deb-src http://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib'; } > /etc/apt/sources.list \
      && apt-get update \
      && apt-get --no-install-recommends -yq install locales ca-certificates unzip libssl-dev procps wget \
      && localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 \
      && arch="$(dpkg --print-architecture)" \
      #   && case "$arch" in 	\	
      #         'amd64') downloadUrl='ftp://120.77.245.173/dmdba/8/amd64/'; ;; 	\	
      #         'arm64') downloadUrl='ftp://120.77.245.173/dmdba/8/arm64/'; ;; 		\
      #         *) echo >&2 "error: unsupported architecture: '$arch'"; exit 1 ;; 	\
      #         esac 	\
      #   && wget --progress=dot:giga -r -np -nd -nH --ftp-user=wephoon_ftp --ftp-password=wephoon2022 "$downloadUrl" \
      && wget --progress=dot:giga -r -np -nd -nH http://175.178.160.52:8090/$arch/dm8.zip \
      && unzip ${DM_HOME_PATH}/dm8.zip -d ${DM_HOME_PATH} \
      && mkdir -p ${DM_DATA_PATH} \
      && chown -Rf dmdba:dinstall ${DM_HOME_PATH} \
      && chmod +x ${DM_HOME_PATH}/docker-entrypoint.sh \
      && chmod +x ${DM_SERVER_BIN}/dminit \
      && chmod +x ${DM_SERVER_BIN}/dmserver \
      && rm -rf ${DM_HOME_PATH}/dm8.zip \
      && apt-get remove --autoremove -y unzip \
      && apt-get autoremove \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/* 

USER dmdba
#开放端口
EXPOSE 5236

VOLUME [ "/home/dmdba/dmdbas/data" ]

ENV PAGE_SIZE=16
ENV CASE_SENSITIVE=0
ENV CHARSET=0
ENV SYSDBA_PWD=SYSDBA@0924

#运行达梦数据库
ENTRYPOINT [ "/home/dmdba/docker-entrypoint.sh" ]









