saenodeholdercom="$doZ:1025"
echo $saenodeholdercom
curl -d \
'{"data": "'"$1"'"}' \
-H "Content-Type: application/json" \
-X POST "$saenodeholdercom/api/nlp"
