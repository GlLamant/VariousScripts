#!/bin/bash

function fn_a() {
    # echo ${#FUNCNAME[@]}          # 获取调用链上的函数个数
    # echo ${#FUNCNAME}             # 获取调用链上的函数个数
    # echo ${FUNCNAME[0]}           # ${FUNCNAME[0]}表示当前函数名称
    # echo ${FUNCNAME[1]}           # ${FUNCNAME[1]}表示调用当前函数的函数名称
    func_size=${#FUNCNAME}
    func_chain=""
    for ((i=${func_size}-1; i>=0; i--)) 
    do
        cur_func_name=${FUNCNAME[${i}]}
        if test -z ${func_chain}; then
            func_chain="${cur_func_name}"
        else
            func_chain="${func_chain}->${cur_func_name}"
        fi
        echo ${FUNCNAME[${i}]}
    done;

    echo 
    echo func_chain: ${func_chain}
}

function fn_b() {
    fn_a
}

function fn_c() {
    fn_b
}

# fn_c