FROM debian:bullseye-slim

LABEL maintainer="wephoon<wephoon@outlook.com>"

RUN groupadd -r kingbase && useradd -r -g kingbase kingbase

RUN set -eux; \
	cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
	echo 'Asia/Shanghai' > /etc/timezone; \
	# sed -i "s@http://deb.debian.org@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list \
	DEBIAN_FRONTEND=noninteractive apt-get update; \
	DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -yq install locales ca-certificates wget unzip gnupg; \
	rm -rf /var/lib/apt/lists/*; \	
	localedef -c -f UTF-8 -i zh_CN zh_CN.utf8

ENV GOSU_VERSION=1.16
RUN set -eux; \
	savedAptMark="$(apt-mark showmanual)"; \
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
	gpgconf --kill all; \
	rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	chmod +x /usr/local/bin/gosu; \
	gosu --version; \
	gosu nobody true

ENV DBVERSION=V008R003C002B0320
ENV KDB_HOME=/opt/kingbase 
RUN set -eux; \
	rm -rf $KDB_HOME && mkdir -p $KDB_HOME/data; \
    arch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	filename=kdb_"$arch"_linux_8.7.3.zip; \
	wget --progress=dot:giga -r -np -nd -nH -O ES.zip "https://raw.githubusercontent.com/elic-chan/DockerImages/main/kingbase/packages/$filename"; \
	unzip ES.zip -d $KDB_HOME; \
	rm -rf ES.zip; \
	/bin/cp -r $KDB_HOME/ES/Server/bin /usr/local/bin/kdb ; \
	chmod +x /usr/local/bin/kdb/* ; \
	find "$KDB_HOME/ES/Server/lib" -name '*.so' -exec dirname '{}' ';' | sort -u > /etc/ld.so.conf.d/docker-kingbase.conf; \
	/sbin/ldconfig; \
	chown -Rf kingbase:kingbase $KDB_HOME; \
	chmod 1777 $KDB_HOME/data; 

VOLUME [ "$KDB_HOME/data" ]

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x usr/local/bin/docker-entrypoint.sh && ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "docker-entrypoint.sh" ]

EXPOSE 54321
CMD ["sys_ctl", "-D", "$KDB_HOME/data", "-l", "$KDB_HOME/data/kdb.log", "start"]


