add_client_account() {
    local client="$1";
    local key="$2";
    
    jq '. + {"'"$client"'": "'"$key"'"}' < clients.json \
	    > tmp.$$.json && mv tmp.$$.json clients.json
    
    jq '. + {"'"$key"'": 1}' < authorization.json \
	    > tmp.$$.json && mv tmp.$$.json authorization.json
}

delete_client_account() {
    local client="$1";

    local key="$(jq '."'$client'"' < clients.json)"
    
    jq -r 'del(.'$key')' < authorization.json \
	    > tmp.$$.json && mv tmp.$$.json authorization.json

    jq 'del(.'$client')' < clients.json \
	    > tmp.$$.json && mv tmp.$$.json clients.json
}
