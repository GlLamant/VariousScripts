#!/bin/bash

# This script shows how to commentate the lines

. ../foundation/foundation.sh

echo single line comment as below
# A line starts with '#' is commentated
lay_fn_new_line

echo 1st way to commentate multiple lines
# line 1
# line 2
# line 3
lay_fn_new_line

echo 2nd way to commnentate multiple lines
<<2nd_way_to_commentate_multi_lines
    line 1
    line 2
    line 3
2nd_way_to_commentate_multi_lines