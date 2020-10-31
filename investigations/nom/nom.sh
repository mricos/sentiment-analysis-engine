#!/bin/bash
nom-getid(){
  local index=$1
  local da2+=($da)
  echo ${da2[*]}
  echo "${da2[ (($index*4 + 0)) ]}"
}

nom-getids-from-index() {
  local line_num=0;
  while read line
  do
    (((line_num % 4) == 0)) && echo $line
    ((line_num++))
  done < ${1:-"/dev/stdin"}
}

nom-info(){
  local index=()
  while read line; do
   index+=($line)
  done < /dev/stdin
  
  echo ${index[(($1*4+0))]}
  echo ${index[(($1*4+1))]}
  echo ${index[(($1*4+2))]}
  echo ${index[(($1*4+3))]}
  echo "Data is: "
  echo $(nom-get-data ./data.nom ${index[(($1*4+2))]} ${index[(($1*4+3))]} )
}

nom-getdata(){
  awk "NR>=$2&&NR<=$3" $1
}

nom-map(){
  jq "[.[] | $1]"
}

nom-get-data(){
  jq '.data'
}
