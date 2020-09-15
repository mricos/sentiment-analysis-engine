jq '{key: "key", text: .text, language: "en"}' < "$1" > transformed-data.json 
jq -s '.' < transformed-data.json > data-array.json
