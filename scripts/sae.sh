sae-test(){
 curl -d '{"data":[ "good bad and ugly", "very good", "very bad", "pretty good","could not be better" ]}' -H "Content-Type: application/json" $doZ:1029/api/nlp
echo "";
}
sae-help() {
    echo '
        sae- functions serve to interact with Sentiment Analysis Engine,
	and are used for testing purposes.

	Functions:

	sae-post-data $ip $port $path 
	- Performs a POST request with data piped to it.
	E.g. cat data.json | sae-post-data 123.456.78.910 80 /post-route


	sae-get-data-with-id $ip $port $path $id
	- Performs GET request to specified ip on port with path and id.
	E.g. sae-get-data-with-id 123.456.78.910 80 /path 2


	sae-parse-file $file $specified_property $from $to 
	- Parses through a file of objects and places specified property values
        into an array. You may specify the indices from n to nn. 
        Function produces a data.sae file with a single object with a property 
	of data with an array of the values specified. Function cats the file 
        upon completion.
        E.g. sae-parse-file file_of_objs.json text 0 10       

    '
}

sae-grab-values() {
    local stdin="$2";
    local stdout="$3";

    local property="$4";
    local from="$5";
    local to="$6";
    
    # If a range is specified
    [ -n "$from" ] && [ -n "$to" ] && \
    jq '.' < "$stdin" | jq '.' -s |\
    jq '.[]."'$property'"' |\
    jq '.['$from':'$to']' -s > "$stdout"

    # If there is no range
    [ -z "$from" ] && [ -z "$to" ] && \
    jq '.' < "$stdin" | jq '.' -s |\
    jq '.[]."'$property'"' >> "$stdout"
}

sae-make-raw() {
    local stdin="$2";
    local stdout="$3";

    jq '.' -r < "$stdin" > "$stdout"
}

sae-map-through-data() {
    local stdin="$2";
    local stdout="$3";

    local data="$(jq '.[]' < $stdin)";

    while read line
        do
            echo "$line" >> "$stdout"
        done <<< "$data"
}

sae-post-string(){

    local endpoint="157.245.233.116:1025/api/nlp"
    local json_data='{"data":"'"$1"'"}'

    local res="$(curl -X POST \
         -H "Content-Type: application/json" \
         -H "Authorization: token" \
         -d "$json_data" \
         $endpoint
    echo "")"

    object-create sentiment noun $res
}

sae-post-data() {
    local stdin="$2";
    local stdout="$3";

    local ip="$4";
    local port="$5";
    local path="$6";
    
    while read string
        do
            local data='{"data": '"$string"'}';
            
            curl -X POST \
            -H "Content-Type: application/json" \
            -H "Authorization: token" \
            -d "$data" \
            "$ip:$port$path" >> "$stdout"
        done <<< "$(cat "$stdin")";
}

sae-set-type() {
    local type="$1";
    local nano_hash="$(date +%s.%N)";
    local req_hash=${2:-$nano_hash};
    local data="$(jq '{"type": "'"$type"'", "data": ., "reqHash": "'"$req_hash"'"}')";
    echo "$data"
}

sae-specify-action() {
    jq '. + {"action": "'"$1"'"}'
}

nstatus() {
    nodeholder-app-status $doZ sae sentiment-analysis-engine
}

nstart() {
    nodeholder-app-start $doZ sae sentiment-analysis-engine
}

nstop() {
    nodeholder-app-stop $doZ sae sentiment-analysis-engine
}
