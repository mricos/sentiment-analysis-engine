#!/bin/bash
nom-getid(){
  local index=$1
  local da2+=($da)
  echo ${da2[*]}
  echo "${da2[ (($index*4 + 0)) ]}"
}

# new
nom-get-all-datatype-from-batch() {
  local datatype="$1";
  local batch_id="$2";
  local line_num=0;

  for file in $(ls response/);
  do
    [ "$(echo $file | awk -F'batch' '{ print $2 }')" == "$batch_id" ] && 
    while read line; do
      (((line_num % 4) == 3)) && echo $line | jq '.'"$datatype"''
      ((line_num++))
    done < "response/$file"
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

# new
nom-get-responses-from-batch() {
  local batch_id="$1";

  for file in $(ls response/);
  do
    [ "$(echo $file | awk -F'batch' '{ print $2 }')" == "$batch_id" ] && 
    echo "$file" | awk -F'batch' '{ print $1 }' 
  done

  #awk 'FNR == 1{ print FILENAME }' \
  #response/1604513539276085335batch1604091136178378045 | 
  #cut -d'/' -f2 | 
  #awk -F'batch' '{ print $1 }'

  #awk 'FNR == 1{ print FILENAME }' \
  #response/1604513539276085335batch1604091136178378045 | 
  #cut -d'/' -f2 | 
  #awk -F'batch' '{ print $2 }'
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
