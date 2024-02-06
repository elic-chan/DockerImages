#!/bin/bash

DM_HOME_PATH=/home/dmdba
DM_INSTALL_PATH=${DM_HOME_PATH}/dmdbas
DM_DATA_PATH=${DM_INSTALL_PATH}/data
DM_SERVER_BIN=${DM_INSTALL_PATH}/bin

check_is_init() {
  declare -g DATABASE_ALREADY_EXISTS
  if [ $(ls ${DM_DATA_PATH} | wc -l) -eq 0 ];then
    DATABASE_ALREADY_EXISTS='false'
  else
    DATABASE_ALREADY_EXISTS='true'
  fi
}

db_init(){
  cd ${DM_SERVER_BIN}
  ./dminit PATH=${DM_DATA_PATH} PAGE_SIZE=${PAGE_SIZE} CASE_SENSITIVE=${CASE_SENSITIVE} CHARSET=${CHARSET} SYSDBA_PWD=${SYSDBA_PWD}
}

check_is_init
if [ "${DATABASE_ALREADY_EXISTS}"x = "false"x ];then
	chown -Rf dmdba:dinstall ${DM_DATA_PATH}
	db_init
	if [ $? -ne 0 ];then
		echo "initdb failed"
		exit 1
	fi
fi


${DM_SERVER_BIN}/dmserver ${DM_DATA_PATH}/DAMENG/dm.ini -noconsole