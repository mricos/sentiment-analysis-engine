#!/bin/bash

# stdin: Nodeholder object Notation to index
# stdout: (id,type,data_start,data_stop) x number of objects
# See bottom of file for usage.

# Convert index file to Bash array: 
# index=($(cat data.nom | ./rd2.sh)) 

# Get  2nd id:
# > echo ${index[((1*4+0))]}

# Get  3rd type:
# > echo ${index[((2*4+1))]}

# Get  3rd start:
# > echo ${index[((2*4+2))]}

# Get  3rd stop:
# > echo ${index[((2*4+3))]}

debug=0
state="NOT_IN_OBJECT" # can be LINE_1, LINE_2, DATA
count=0 # line number

# array len = number of objects after parsing
# id, type, start, stop, id2, type2, start2, stop2, ...
index=()  

# Id: first line
# type: second line
# data: until blank line 

while read line
do
    if [[ "$state" == "DATA" && "$line" == "" ]];
    then
        state="NOT_IN_OBJECT"
        data_ends+=($count)
        index+=($count)
        echo $count
        ((debug))  &&  echo "data_end: $count" >&2
        echo ""
    fi	

    (( count++ ))

    if [[ "$state" == "DATA" && "$line" != "" ]];
    then
        state="DATA"
        ((debug))  && echo "$line" >&2
    fi	

    if [[ "$state" == "LINE_2" && "$line" != "" ]];
    then
        state="DATA"
        data_starts+=($count)
        index+=($count)
        echo $count
        ((debug)) && echo "data_start: $count" >&2
        ((debug)) && echo "$line" >&2

    fi	

    if [[ "$state" == "LINE_1" && "$line" != "" ]];
    then
        ((debug)) && echo "type: $line" >&2
        echo "$line"
        types+=($line)
        state="LINE_2"
        index+=($line)
    fi	

    if [[ "$state" == "NOT_IN_OBJECT" && "$line" != "" ]];
    then
        ((debug)) && echo "id: $line" >&2
        echo "$line"
        state="LINE_1"
        index+=($line)
    fi	

done < "${1:-/dev/stdin}"

if [[ "$state" == "DATA" ]];
then
    ((debug)) && echo "IN DATA AT END" >&2
    index+=($count)
    echo "$count"
fi	
