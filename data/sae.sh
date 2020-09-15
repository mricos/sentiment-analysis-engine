sae-parse-file() {
    jq . < "$1"
}

sae-post-data() {
    local ip="$1";
    local port="$2";
    local path="$3"
    curl -s -X POST \
    -H "Content-Type: application/json" \
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
