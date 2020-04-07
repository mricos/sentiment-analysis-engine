curl -d \
'{"text": "'"$1"'", "key": "'"$2"'", "language": "'"$3"'"}' \
-H "Content-Type: application/json" \
-X POST "localhost:3000/api/nlp/s-analyzer"
