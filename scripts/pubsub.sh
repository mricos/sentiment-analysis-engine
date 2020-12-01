# Source this file

# Array that will contain all registered events
EVENTS=()
STREAM="$(cat ./data/biden-trump.tweetgen)"; # TWEETGEN

# Actions

# tweetgen -> json_array
pseudo-filter() {
   STREAM="$(echo $STREAM | jq '.text' | jq -s '.')";
}

stream-filter() {
    jq '.text' | jq -s '.'
}

# json_array -> 
pseudo-extract() {
    local from="$2";
    local to="$3";

    STREAM="$(echo $STREAM | jq '.['$from':'$to']')";
    echo "$STREAM"
}

stream-extract(){
    local from="$1";
    local to="$2";
    jq ".[$from:$to]"
}

stream-extract-broken(){
    local from="$2";
    local to="$3";
    while read line
    do
        echo $line
     	echo $line | jq '.['$from':'$to']'
    done < "/dev/stdin" 
}

subscribe "filter" "pseudo-filter"
subscribe "extract" "pseudo-extract"
publish "filter"
publish "extract" 0 3


# @desc   :: Registers an event
# @param  :: string $1 - The name of the event. Basically an alias for a function name
# @param  :: string $2 - The name of the function to be called
function subscribe() {
    EVENTS+=("${1};${2}")
}

#
# @desc   :: Public an event
# @param  :: string $1 - The name of the event being published
#
function publish() {
for event in ${EVENTS[@]}; do
    local IFS=";"
    read -r -a event <<< "$event"
    if [[  "${event[0]}" ==  "${1}" ]]; then
	${event[1]} "$@"
    fi
done
}

#
# Register our events and the functions that handle them
#
# subscribe "grab" "sae-grab-values" 
# subscribe "map" "sae-map-through-data"
# subscribe "post" "sae-post-data"
# subscribe "make-raw" "sae-make-raw"
# subscribe "get" "sae-get-data"

#
# Execute our events
#
# 
# {
#   reqHash:NTS
#   type:
#   action:
#   data:
#}

#NTS
#TYPE
#ACTION
#DATA
#

reqHash=$(date +%s.%N)
#publish grab ./data/biden-trump.tweetgen ./transformed/grabbed "text" 0 1 
#publish map ./transformed/grabbed ./transformed/mapped
#publish post ./transformed/mapped ./transformed/post-response \
#    157.245.233.116 1025 /api/nlp
#publish grab ./transformed/post-response ./transformed/post-sentiments "sentiment"
