PORT=${PORT:-3000}
while read line; do
  curl -X POST\
  -H "Content-Type: application/json"\
  -d '{"data": "'"$line"'"}'\
  'localhost:'"$PORT"'/api/nlp'
done < lockdown.txt
