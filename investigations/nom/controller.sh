#!/bin/bash
# Input: NomIndexObjectStream

# maybe deprecated
#controller-augment() {
#  local response_ids=();
#  local response_data=();

#  for file in $(ls response/); do
#    response_ids+=($(awk "NR>=2&&NR<=2" response/$file));
#    response_data+=($(awk "NR>=3&&NR<=3" response/$file));
#  done
#  echo "completed ids: ${response_ids[*]}"
#  echo "data from response: ${response_data[*]}"

#  local ids=();
#  local data=();
#  while read id
#  do
#    read type
#    read start
#    read stop
#    json="$(awk "NR>=$start&&NR<=$stop" data.nom)";
#    ids+=($id)
    # The string locks each line into one element
#    data+=("$json")
#  done < "/dev/stdin"
 
#  for i in $(seq 0 "${#response_ids[@]}"); do
    # nom-getdata-from-object() $1 = object_number
#    echo "${data[$i]}" | jq '. + '"${response_data[$i]}"''
#  done
  
#}

controller-showtypes(){
  local line_num=0;

  while read line
  do
    (((line_num % 4) == 1)) && echo $line
    ((line_num++))
  done < "/dev/stdin"

  echo "Found $line_num lines."
}

controller-showdata() {
  local line_num=0;

  while read line
  do
    (((line_num % 4) == 3)) && echo $line 
    (((line_num % 4) == 2)) && echo $line
    ((line_num++))
  done < "/dev/stdin"
  

  echo "Found $line_num lines."
}


# RES_ID
# BATCH_ID
# PROC_ID
# DATA  (output of process)
controller-dispatch(){
  local index=()
  while read line
  do
    index+=($line)
  done < "/dev/stdin"  # could default to arg1 ${1:-"/dev/stdin"

  # index is an array of id,type,strart,stop values
  # len(index) = 4*numberOfObjects
  
  #local num_of_objects=$(( ${#index[@]}/4 ));
  local num_of_objects=$(( ${#index[@]}/4 - 1 ));
  local file="data.nom";
    
  #name of file is used in response/
  local batchId=$(readlink data.nom); 
  local ip="$1";
  local port="$2";

  for i in $(seq 0 $num_of_objects)
  do
	local type=$(awk -F'.' '{print $2}' <<< ${index[(($i*4+1))]});
	
    # put this after process/type check for efficiency
    local id=${index[(($i*4+0))]};
	local start=${index[(($i*4+2))]};
	local stop=${index[(($i*4+3))]};

    [ -e process/"$type" ] &&
      local resId=$(date +%s%N) &&
      echo "$resId" > ./response/${resId}batch${batchId} &&
      echo "$id" >> ./response/${resId}batch${batchId} &&
      echo "$batchId" >> ./response/${resId}batch${batchId} &&
      awk "NR>=$start&&NR<=$stop" $file |
      ./process/$type $ip $port >> ./response/${resId}batch${batchId} &
  done
}

controller-test(){
  cat data.nom | ./rd2.sh | controller-dispatch $doZ 1025
}

controller-clear-responses(){
  rm response/* 
}

controller-list-responses(){
  ls response/
}

controller-list-summary(){
  echo 'Filename: {$resId}batch{$batchId}'
  echo "Content: resId,reqId,batchId,data"
  local files=($(ls response)) 
  for file in ${files[@]}
  do
    echo "Filename: $file"
    cat response/$file
    echo ""
  done

}
