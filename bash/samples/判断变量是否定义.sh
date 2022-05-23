#!/bin/bash

if test ${var+y}; then
    echo not defined var, and \${var+y} == true
else
    echo not defined var, and \${var+y} == false
fi

var=1
if test ${var+y}; then
    echo defined var == ${var}, and \${var+y} == true
else
    echo defined var == ${var}, and \${var+y} == false
fi