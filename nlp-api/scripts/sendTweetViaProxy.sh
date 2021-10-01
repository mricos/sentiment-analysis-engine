#saenodeholdercom="$doZ:1029"
send="sae.study-groups.org"
curl -d \
'{"data": "'"$1"'"}' \
-H "Content-Type: application/json" \
-X POST "$send"
