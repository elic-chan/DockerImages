#!/bin/bash
set -eo pipefail
shopt -s nullglob

##这个脚本是用来定义金仓数据库docker镜像构建的入口点脚本，主要用于检查和初始化数据库

# 消息提醒，参考了mysql的
kdb_log() {
	local type="$1"; shift
	# accept argument string or stdin
	local text="$*"; if [ "$#" -eq 0 ]; then text="$(cat)"; fi
	local dt; dt="$(date --rfc-3339=seconds)"
	printf '%s [%s] [Entrypoint]: %s\n' "$dt" "$type" "$text"
}
kdb_note() {
	kdb_log Note "$@"
}
kdb_warn() {
	kdb_log Warn "$@" >&2
}
kdb_error() {
	kdb_log ERROR "$@" >&2
	exit 1
}

# 检查是否入口重复执行
_is_sourced() {
	# https://unix.stackexchange.com/a/215279
	[ "${#FUNCNAME[@]}" -ge 2 ] \
		&& [ "${FUNCNAME[0]}" = '_is_sourced' ] \
		&& [ "${FUNCNAME[1]}" = 'source' ]
}


# 定义变量和检查数据库初始化情况
docker_check_database(){
	declare -g DATABASE_ALREADY_EXISTS
	if [ -d "$@/base" ];then
		kdb_note "检测到数据库实例已存在，跳过数据库初始化。"
		DATABASE_ALREADY_EXISTS='true'
	fi
}

##初始化数据库
docker_init_db(){
	if [ -z "$KDB_ROOT_USER" ]; then
		KDB_ROOT_PASSWORD="SYSTEM"
		kdb_warn "数据库管理员用户被指定为：SYSTEM"
	fi	
	if [ -z "$KDB_ROOT_PASSWORD" ]; then
		KDB_ROOT_PASSWORD="kingbase"
		kdb_warn "数据库管理员密码被指定为：kingbase"
	fi
	if [ -z "$KDB_ENCODING" ]; then
		KDB_ENCODING="UTF8"
		kdb_warn "数据库字符集被指定为：UTF8"
	fi
	if [ -z "$KDB_CASE_SENSITIVITY" ]; then
		KDB_CASE_SENSITIVITY="--case-insensitive"
		kdb_warn "数据库字符被指定为：大小写不敏感"
	fi
	initdb -U ${KDB_ROOT_USER} -W ${KDB_ROOT_PASSWORD} -E ${KDB_ENCODING} ${KDB_CASE_SENSITIVITY} -D /var/lib/kingbase
	# ${KDB_HOME}/ES/Server/bin/initdb --encoding=${KDB_ENCODING} -D ${KDB_DATA_DIR}
	# initdb --encoding=${KDB_ENCODING} -D /var/lib/kingbase
	kdb_note "数据库初始化已完成。"
}

##执行脚本
_main(){
	# 如果run时只输入了参数，则为此参数添加命令sys_ctl
	if [ "${1:0:1}" = '-' ]; then
		set -- sys_ctl "$@"
	fi
	
	# 如果传递进来的第一个参数是sys_ctl，则执行以下步骤
	if [ "$1" = 'sys_ctl' ]; then
		kdb_note "Entrypoint script for Kingbase Server ${DBVERSION} started."
		docker_check_database "$3"

		# 切换至kingbase用户重新执行脚本
		if [ "$(id -u)" = "0" ]; then
			kdb_note "切换至用户 'kingbase'"
			exec gosu kingbase "$BASH_SOURCE" "$@"
		fi

		if [ -z "$DATABASE_ALREADY_EXISTS" ]; then
			docker_init_db
		fi
	fi
	# 启动数据库
	exec "$@"
}

if ! _is_sourced; then
	_main "$@"
fi
