
add_to_db() {
    local key="$1";
    local value="$2";
    local file="$3";

    jq '. + {"'"$key"'": "'"$value"'"}' < "$file" \
	    > tmp.$$.json && mv tmp.$$.json "$file"
}

delete_item_from_db() {
    local key="$1";
    local file="$2";

    jq 'del(."'"$key"'")' < "$file" > tmp.$$.json && mv tmp.$$.json "$file"
}

edit_item_from_db() {
    local key="$1";
    local value="$2";
    local file="$3";

    jq '."'"$key"'" = "'"$value"'"' < "$file" \
	    > tmp.$$.json && mv tmp.$$.json "$file" 
}

get_item_from_db() {
    local key="$1";
    local file="$2";

    jq ".$key" < "$file"
}
