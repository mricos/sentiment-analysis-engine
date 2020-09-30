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


sae-map-through-data() {
    local data="$(jq '.[]')";

    while read line
        do
            echo "$line"
        done <<< "$data" 
}

sae-post-data() {
    local ip="$1";
    local port="$2";
    local path="$3";
    
    while read string
        do
	    local data="$(echo '{"data": '"$string"'}')";
           # echo "$ip"
           # echo "$port"
           # echo "$path"
           # echo "$data"
            echo "$ip:$port$path"
            curl -X POST \
            -H "Content-Type: application/json" \
            -H "Authorization: token" \
            -d "$data"
            "$ip:$port$path";
        done 
}

sae-get-data-with-id() {
    local ip="$1";
    local port="$2";
    local path="$3";
    local id="$4";
    curl -s "$ip:$port$path/$id"
}


sae-grab-values() {
    local data="$(jq '.' -s | jq '.[]."'$1'"' | jq '.['$2':'$3']' -s)";
    echo "$data"
}

sae-set-type() {
    local type="$1";
    local nano_hash="$(date +%N)";
    local req_hash=${2:-$nano_hash};
    local data="$(jq '{"type": "'"$type"'", "data": ., "reqHash": "'"$req_hash"'"}')";
    echo "$data"
}

sae-specify-action() {
    jq '. + {"action": "'"$1"'"}'
}

test-sae() {
    cat /home/admin/src/sentiment-analysis-engine/data/biden-trump.tweetgen \
    | sae-grab-values text 0 11 \
    | sae-set-type text \
    | sae-specify-action sentiment \
    | sae-post-data 157.245.233.116 1025 /api/nlp
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
