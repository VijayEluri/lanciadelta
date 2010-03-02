#!/bin/sh

#
# Copyright (C) 2009 Funambol, Inc.  All rights reserved.
#

# Setting CMD_HOME
# resolving links - $0 could be a softlink
PRG="$0"

while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done

PRGDIR=`dirname "$PRG"`

CMD_HOME=`cd "$PRGDIR/.." ; pwd`

#
# If JAVA_HOME points to a jdk, it is taken to launch the client, it the java
# command in the path is used.
#
JAVA_CMD=bin/java

if [ ! -f "$JAVA_HOME/$JAVA_CMD" ]
then
    JAVA_CMD="java"
fi

if [ -f "$JAVA_HOME/$JAVA_CMD" ]
then
    JAVA_CMD="$JAVA_HOME"/$JAVA_CMD
fi


# Setting classpath
cd "$CMD_HOME/lib"
for jarfile in *.jar; do export CLASSPATH=$CLASSPATH:lib/$jarfile; done
export CLASSPATH=ext:$CLASSPATH
cd "$CMD_HOME"


LANG=en_US.UTF-8

echo "Using $JAVA_CMD"
$JAVA_CMD "$@" com.funambol.lanciadelta.LanciaDeltaShell
