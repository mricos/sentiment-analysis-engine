curl -d '{"review": "'"$1"'"}' -H "Content-Type: application/json" \
-X POST "localhost:3000/api/nlp/s-analyzer"
