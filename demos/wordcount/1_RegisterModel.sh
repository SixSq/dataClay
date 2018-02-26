#!/bin/bash
TOOLSPATH=../../tool/dClayTool.sh
DATACLAYLIB=../../tool/lib/dataclayclient.jar

# Minimum set of required variables
APP=Wordcount
SRCPATH="src/model"
STUBSPATH="stubs"



##### Checks and derived variables definition

# Check dataClay lib
if [ ! -f $DATACLAYLIB ]; then
	echo "[ERROR] dataClay client lib (or link) not found at $DATACLAYLIB."
	exit -1
fi

# Check toolspath
if [ ! -f $TOOLSPATH ]; then
	echo "[ERROR] Bad tools path. Edit TOOLSPATH script variable to change it."
	exit -1
fi
# Local variables
if [ ! -z $1 ]; then
	NAMESPACE=$1
else
	NAMESPACE="${APP}NS"
fi
USER=${APP}User
PASS=${APP}Pass
DATASET=${APP}DS

printMsg() {
	printf "\n******\n***** $1 \n******\n "
}


##### dClayTools-based script

printMsg "Register account"
$TOOLSPATH NewAccount $USER $PASS

printMsg "Create dataset and grant access to it"
$TOOLSPATH NewDataContract $USER $PASS $DATASET $USER

printMsg "Compile and register model"
TMPBINPATH=`mktemp -d`
javac -cp lib/dataclayclient.jar `find $SRCPATH | grep java` -d $TMPBINPATH
$TOOLSPATH NewModel $USER $PASS $NAMESPACE $TMPBINPATH java
rm -Rf $TMPBINPATH

printMsg "Get stubs"
mkdir -p $STUBSPATH
rm -Rf $STUBSPATH/*
$TOOLSPATH GetStubs $USER $PASS $NAMESPACE $STUBSPATH
