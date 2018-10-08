#!/bin/sh

ps -ef | grep SocketTest | grep -v grep | awk '{print $2}' | xargs kill

exit 0

