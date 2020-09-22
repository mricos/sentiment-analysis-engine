#sae-parse-file() {
#    jq . < "$1"
#}

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
