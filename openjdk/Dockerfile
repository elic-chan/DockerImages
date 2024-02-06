FROM debian:buster

LABEL maintainer="wephoon<wephoon@outlook.com>"

ENV JAVA_HOME=/usr/local/openjdk-8

ENV PATH=/usr/local/openjdk-8/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV JAVA_VERSION=8u322

RUN set -xe \
       && /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' > /etc/timezone \
       && { echo '#/bin/sh'; echo 'echo "$JAVA_HOME"'; } > /usr/local/bin/docker-java-home && chmod +x /usr/local/bin/docker-java-home && [ "$JAVA_HOME" = "$(docker-java-home)" ] \
       # && mv /etc/apt/sources.list /etc/apt/sources.list.bak \
       # && sed -i "s@http://ftp.debian.org@https://repo.huaweicloud.com@g" /etc/apt/sources.list \
       # && sed -i "s@http://deb.debian.org@https://repo.huaweicloud.com@g" /etc/apt/sources.list \
       # && sed -i "s@http://security.debian.org@https://repo.huaweicloud.com@g" /etc/apt/sources.list \
       # && { echo 'deb http://mirrors.aliyun.com/debian/ buster main non-free contrib'; echo 'deb-src http://mirrors.aliyun.com/debian/ buster main non-free contrib'; echo 'deb http://mirrors.aliyun.com/debian-security buster/updates main'; echo 'deb-src http://mirrors.aliyun.com/debian-security buster/updates main'; echo 'deb http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib'; echo 'deb-src http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib'; echo 'deb http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib'; echo 'deb-src http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib'; } > /etc/apt/sources.list \
       # && { echo 'deb http://mirrors.aliyun.com/debian/ buster main non-free contrib'; echo 'deb http://mirrors.aliyun.com/debian-security buster/updates main'; echo 'deb http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib'; echo 'deb http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib'; } > /etc/apt/sources.list \
       && apt-get update \
       && apt-get --no-install-recommends -yq install locales ca-certificates wget unzip \
       && localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 \
       && cd \
       && arch="$(dpkg --print-architecture)" \
       && case "$arch" in 	\	
              'amd64') downloadUrl='https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases/download/jdk8u322-b06/OpenJDK8U-jdk_x64_linux_8u322b06.tar.gz'; ;; 	\	
              'arm64') downloadUrl='https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases/download/jdk8u322-b06/OpenJDK8U-jdk_aarch64_linux_8u322b06.tar.gz'; ;; 		\
              *) echo >&2 "error: unsupported architecture: '$arch'"; exit 1 ;; 	\
              esac 	\
       && wget --progress=dot:giga -O openjdk.tgz "$downloadUrl" \
       && mkdir -p "$JAVA_HOME" \
       && tar --extract --file openjdk.tgz --directory "$JAVA_HOME" --strip-components 1 --no-same-owner \
       && rm openjdk.tgz* \
       && find "$JAVA_HOME/lib" -name '*.so' -exec dirname '{}' ';' | sort -u > /etc/ld.so.conf.d/docker-openjdk.conf \
       && ldconfig \
       && apt-get autoremove \
       && apt-get clean \
       && rm -rf /var/lib/apt/lists/* 

ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8

CMD ["/bin/bash"]