time jq .[$1:$2] < $3 | curl -X POST -H "Content-Type: application/json" -d @- "157.245.233.116:1025/api/test/analyze/sentiment" | jq '.'
