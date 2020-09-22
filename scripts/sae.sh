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

sae-post-data() {
    local ip="$1";
    local port="$2";
    local path="$3"
    curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: token" \
    -d @- \
    "$ip:$port$path"
}

sae-get-data-with-id() {
    local ip="$1";
    local port="$2";
    local path="$3";
    local id="$4";
    curl -s "$ip:$port$path/$id"
}


sae-parse-file() {
    jq '.' -s < $1 | jq '.[]."'$2'"' | jq '.['$3':'$4']' -s > data.$$
    data_for_sae="$(cat ./data.$$)"

    echo '{"data": '"$data_for_sae"'}' > data.sae
    rm ./data.$$
    cat ./data.sae
}
