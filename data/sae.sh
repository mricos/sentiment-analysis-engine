sae-parse-file() {
    jq . < "$1"
}

sae-post-data() {
    curl -X POST \
    -H "Content-Type: application/json" \
    -d @- \
    "157.245.233.116:1025/api/nlp/analyze/sentiment"
}

sae-get-data-with-id() {
    local id="$1";
    curl "157.245.233.116:1025/api/nlp/analyze/sentiment/$id"
}
