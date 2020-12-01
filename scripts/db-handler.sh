
add_to_db() {
    local key="$1";
    local value="$2";
    local file="$3";
    # json file to stdin
    # adds key:value to object
    # rewrites file
    jq '. + {"'"$key"'": "'"$value"'"}' < "$file" \
	    > tmp.$$.json && mv tmp.$$.json "$file"
}

delete_item_from_db() {
    local key="$1";
    local file="$2";
    # json file to stdin
    # deletes key and value
    # rewrites file
    jq 'del(."'"$key"'")' < "$file" > tmp.$$.json && mv tmp.$$.json "$file"
}

edit_item_from_db() {
    local key="$1";
    local value="$2";
    local file="$3";
    # json file to stdin 
    # specifies key and changes value
    # rewrites file
    jq '."'"$key"'" = "'"$value"'"' < "$file" \
	    > tmp.$$.json && mv tmp.$$.json "$file" 
}

get_item_from_db() {
    local key="$1";
    local file="$2";
    # json file to stdin
    # gets specific key:value pair from file
    jq ".$key" < "$file"
}
