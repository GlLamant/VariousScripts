############声明环境变量########################################################
declare g_curPath=""                                # 当前脚本所在的目录
declare g_logPath="."                               # 日志路径
declare g_logFile="test.log"                        # 日志文件
################################################################################
# Function: init_path
# Description: 初始化脚本所在的目录及脚本名
# Parameter:
#   input:
#   N/A
#   output:
#   N/A
# Return: 0 -- success; not 0 -- failure
# Others: N/A
################################################################################
init_path()
{
    cd "$(dirname "${BASH_SOURCE-$0}")"
    g_curPath="${PWD}"
    g_scriptName="$(basename "${BASH_SOURCE-$0}")"
    g_setup_tool_package_home="$(dirname "${g_curPath}")"
    cd - >/dev/null
}

################################################################################
# Function: init_log
# Description: 初始化preset日志文件
# Parameter:
#   input:
#   N/A
#   output:
#   N/A
# Return: 0 -- success; not 0 -- failure
# Others: N/A
################################################################################
init_log()
{
    [ -d ${g_logPath} ] || mkdir -p ${g_logPath}
    [ -f ${g_logPath}/${g_logFile} ] || touch "${g_logPath}/${g_logFile}"
    chmod 600 "${g_logPath}/${g_logFile}"
}

################################################################################
# Function: main
# Description: 主函数
# Parameter:
#   input:
#   N/A
#   output:
#   N/A
# Return: 0 -- success; not 0 -- failure
# Others: N/A
################################################################################
main()
{  
    # 如果不是root用户，则退出
    # if [ $(id -u) -ne 0 ] ; then
    # echo ${LINENO}
    #     echo  "ERROR: Only super user can execute this script."
    #     return 1
    # fi
    
    showLog_info "${LINENO}" "start to preSet"
    
    # 如果用户环境上不存在运行用户，则创建运行用户，如果已存在，则判断是否属于${RUN_USER_GROUP}组，如果不属于则报错退出
    id -u ${RUN_USER} > /dev/null 2>&1
    if [ $? -ne 0 ] ; then
        :
## ...这里省略了中间部分操作
    fi

    showLog_info "${LINENO}" "success to finish test."
    return 0
}

# ---------------------------------------------------------------------------- #
#                        获取当前路径,初始化日志文件                           #
# ---------------------------------------------------------------------------- #
init_path
cd "${g_curPath}"
init_log

# ---------------------------------------------------------------------------- #
#                                   导入头文件                                 #
# ---------------------------------------------------------------------------- #
. "${g_curPath}/../foundation/log.sh" || { echo "[${g_scriptName}:${LINENO}] ERROR: Failed to load ${g_curPath}/log.sh."; exit 1;}


# ---------------------------------------------------------------------------- #
#                                 脚本开始运行                                 #
# ---------------------------------------------------------------------------- #
main "$@"
ret=$?

#在操作系统日志中记录审计日志
syslog "manager" "test.sh" "$ret" "User root do some test"
exit $ret