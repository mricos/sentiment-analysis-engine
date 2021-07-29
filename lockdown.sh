while read line; do
  curl -X POST\
  -H "Content-Type: application/json"\
  -d '{"data": "'"$line"'"}'\
  'localhost:3000/api/nlp'
done < lockdown.txt
