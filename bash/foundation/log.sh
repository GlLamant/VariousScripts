#!/bin/bash

################################################################################
## Reference: https://haosuwei.github.io/2018/04/17/shell-log-tool.html
################################################################################ 

################################################################################
# Function: logDef
# Description: 记录到日志文件
# Parameter:
#   input:
#   N/A
#   output:
#   N/A
# Return: 0 -- success; not 0 -- failure
# Others: 该函数是最低层日志函数，不会被外部函数直接调用
################################################################################
logDef()
{
    # 调用日志打印函数的函数名称
    local funcName="$1"
    shift

    # 打印的日志级别
    local logLevel="$1"
    shift

    # 外部调用日志打印函数时所在的行号
    local lineNO="$1"
    shift
    
    if [ -d "${g_logPath}" ] ; then
        # 打印时间、日志级别、日志内容、脚本名称、调用日志打印函数的函数、打印时的行号及脚本的进程号
        local logTime="$(date -d today +'%Y-%m-%d %H:%M:%S')"
        printf "[${logTime}] ${logLevel} $* [${g_scriptName}(${funcName}):${lineNO}]($$)\n" \
            >> "${g_logPath}/${g_logFile}" 2>&1
    fi

    return 0
}

################################################################################
# Function: log_error
# Description: 对外部提供的日志打印函数：记录EEROR级别日志到日志文件
# Parameter:
#   input:
#   N/A
#   output:
#   N/A
# Return: 0 -- success; not 0 -- failure
# Others: N/A
################################################################################
log_error()
{
    # FUNCNAME是shell的内置环境变量，是一个数组变量，其中包含了整个调用链上所有
    # 的函数名字，通过该变量取出调用该函数的函数名
    logDef "${FUNCNAME[1]}" "ERROR" "$@"
}

################################################################################
# Function: log_info
# Description: 对外部提供的日志打印函数：记录INFO级别日志到日志文件
# Parameter:
#   input:
#   N/A
#   output:
#   N/A
# Return: 0 -- success; not 0 -- failure
# Others: N/A
################################################################################
log_info()
{
    # FUNCNAME是shell的内置环境变量，是一个数组变量，其中包含了整个调用链上所有
    # 的函数名字，通过该变量取出调用该函数的函数名
    logDef "${FUNCNAME[1]}" "INFO" "$@"
}

################################################################################
# Function: showLog
# Description: 记录日志到文件并显示到屏幕
# Parameter:
#   input:
#   N/A
#   output:
#   N/A
# Return: 0 -- success; not 0 -- failure
# Others: 该函数是低层日志函数，不会被外部函数直接调用
################################################################################
showLog()
{
    # 把日志打印到日志文件。FUNCNAME是shell的内置环境变量，是一个数组变量，其中
    # 包含了整个调用链上所有的函数名字，通过该变量取出调用该函数的函数名
    logDef "${FUNCNAME[2]}" "$@"

    # 如果是EEROR日志级别，则显示在屏幕上要带前缀：ERROR
    if [ "$1" = "ERROR" ]; then
        echo -e "ERROR:$3"
    elif [ "$1" = "WARN" ];then
        echo -e "WARN: $3"
    else
        echo -e "$3"
    fi
}

################################################################################
# Function: showLog_error
# Description: 对外部提供的日志打印函数：记录ERROR级别日志到文件并显示到屏幕
# Parameter:
#   input:
#   N/A
#   output:
#   N/A
# Return: 0 -- success; not 0 -- failure
# Others: N/A
################################################################################
showLog_error()
{
    showLog ERROR "$@"
}

################################################################################
# Function: showLog_info
# Description: 对外部提供的日志打印函数：记录INFO级别日志到文件并显示到屏幕
# Parameter:
#   input:
#   N/A
#   output:
#   N/A
# Return: 0 -- success; not 0 -- failure
# Others: N/A
################################################################################
showLog_info()
{
    showLog INFO "$@"
}

################################################################################
# Function: syslog
# Description: Important operation must record to syslog
# Parameters  : $1 is component name ; $2 is filename ; $3 is status ; $4 is message
# Return: 0 -- success; not 0 -- failure
# Others: N/A
################################################################################
function syslog()
{
    local component=$1
    local filename=$2
    local status=$3
    local message=$4

    if [ "$3" -eq "0" ]; then
        status="success"
    else
        status="failed"
    fi

    which logger >/dev/null 2>&1
    [ "$?" -ne "0" ] && return 0;

    login_user_ip="$(who -m | sed 's/.*(//g;s/)*$//g')"
    execute_user_name="$(whoami)"
    logger -p local0.notice -i "${component};[${filename}];${status};${login_user_ip};${execute_user_name};${message}"
    return 0
}