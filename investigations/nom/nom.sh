#!/bin/bash
nom-getid(){
  local index=$1
  local da2+=($da)
  echo ${da2[*]}
  echo "${da2[ (($index*4 + 0)) ]}"
}

nom-get-all() {
  local prop="$1";
  local line_index=1;
    
  local file=$(readlink data.nom);
  local response_data=($(cat response/$file));

  for line in "${response_data[@]}"; do
    ((line_index % 2 == 0)) && echo "$line" | jq '.'"$prop"'' 
    ((line_index++))
  done
}

nom-link-to-data() {
  # links program specific file to user specific data
  local poid="$1";
  local poid_index="$2";
  ln -sf "$poid" data.nom
  ln -sf "$poid_index" data.index
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
  awk "NR>=$1&&NR<=$2" data.nom
}

nom-map(){
  jq "[.[] | $1]"
}

nom-get-data(){
  jq '.data'
}