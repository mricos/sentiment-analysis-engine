read-data() {

    ## regex for an id
    local re_id="^[0-9]+([.][0-9]+)?$";

    ## regex for a type
    local re_type="^[a-zA-Z]+([.][a-zA-Z]+)?$";

    ## main type
    local type="";

    ## buffer
    local buffer="";

    while read line
        do
            ## if it's an id
            if [[ $line =~ $re_id ]]; then
                echo "Id: $line"
            ## if it's a type
            elif [[ $line =~ $re_type ]]; then
                type="$(cut -d. -f1 <<< $line)";
                echo "Main type: $type"
                echo "Secondary type: $(cut -d. -f2 <<< $line)"
            ## if it's the end of the object
            elif [[ $line == "}" ]]; then
                buffer+="$line"
                echo "Main type used: $type"
                jq ".$type" <<< "$buffer"
            else buffer+="$line"
            fi
        done < "$1"
}

read-data $1
