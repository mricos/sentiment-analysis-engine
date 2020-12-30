saenodeholdercom="$doZ:1029"
echo $saenodeholdercom
curl -d \
'{"data": "'"$1"'"}' \
-H "Content-Type: application/json" \
-X POST "$saenodeholdercom/api/nlp"
