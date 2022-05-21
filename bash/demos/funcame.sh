#!/bin/bash

function fn_a() {
    # echo ${#FUNCNAME[@]}          # 获取调用链上的函数个数
    # echo ${#FUNCNAME}             # 获取调用链上的函数个数
    # echo ${FUNCNAME[0]}           # ${FUNCNAME[0]}表示当前函数名称
    # echo ${FUNCNAME[1]}           # ${FUNCNAME[1]}表示调用当前函数的函数名称
    func_size=${#FUNCNAME}
    for ((i=${func_size}-1; i>=0; i--)) 
    do
        echo ${FUNCNAME[${i}]}
    done;
}

function fn_b() {
    fn_a
}

function fn_c() {
    fn_b
}

# fn_c