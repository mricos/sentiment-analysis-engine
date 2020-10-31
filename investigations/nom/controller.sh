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

controller-dispatch(){
  local index=()
  while read line
  do
    index+=($line)
  done < "/dev/stdin"

  # index is an array of id,type,strart,stop values
  # len(index) = 4*numberOfObjects
  
  #local num_of_objects=$(( ${#index[@]}/4 ));
  local num_of_objects=$(( ${#index[@]}/4 - 1 ));
  for i in $(seq 0 $num_of_objects)
  do
	local id=${index[(($i*4+0))]};
	local type=$(awk -F'.' '{print $2}' <<< ${index[(($i*4+1))]});
	local start=${index[(($i*4+2))]};
	local stop=${index[(($i*4+3))]};
    local file="data.nom";
    
    #local resId=$(date +%s%N);
    ## Copies name of file and uses it in response/
    local resId=$(readlink data.nom);

    local ip="$1";
    local port="$2";

    [ -e process/"$type" ] &&  
      echo "$id" >> ./response/$resId &&
      awk "NR>=$start&&NR<=$stop" $file |
      ./process/$type $ip $port >> ./response/$resId

    #Zach's refactored code above#
    ##############################################################
    #if [[ $type == "process.jsonStringToJsonSentiment" ]]; then
    #echo $resId > ./responses/$resId
    #echo $id >> ./responses/$resId
    #  local process=$(echo $(awk "NR>=$start&&NR<=$stop" $file)  |
    #  ./jsonStringToJsonSentiment $doZ 1025 >> ./responses/$resId &)
    #  local outputObject="{id: "$id", parent: "$resId"}";
    #  echo "$outputObject" > ./responses/$resId
    #fi

    #if [[ $type == "process.stringToJsonSentiment" ]]; then
    #  echo $(awk "NR>=$start&&NR<=$stop" $file)  |
    #        ./stringToJsonString |
    #        ./jsonStringToJsonSentiment $doZ 1025  > ./responses/$id &
    #fi
    #if [[ $type == "process.jsonStringArrayToJsonSentiment" ]]; then
    #  echo $(awk "NR>=$start&&NR<=$stop" $file)  |
    #        ./stringToJsonString |
    #        ./jsonStringToJsonSentiment $doZ 1025  > ./responses/$id &
    #fi

  done
}
