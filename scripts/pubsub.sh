   #!/usr/bin/env bash

    #
    # Save the path to this script's directory in a global env variable
    #
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    #
    # Array that will contain all registered events
    #
    EVENTS=()

    # Actions

    #function analyze-for-sentiment() {
        
    #}
    
    function action1() {
        echo "Action #1 was performed ${2}"
    }

    function action2() {
        echo "Action #2 was performed"
    }

    #
    # @desc   :: Registers an event
    # @param  :: string $1 - The name of the event. Basically an alias for a function name
    # @param  :: string $2 - The name of the function to be called
    # @param  :: string $3 - Full path to script that includes the function being called
    #
    function subscribe() {
        EVENTS+=("${1};${2};${3}")
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
     subscribe "grab" "sae-grab-values" "${DIR}" # what's the use of this?
     subscribe "map" "sae-map-through-data" "${DIR}"
     subscribe "post" "sae-post-data" "${DIR}"
     subscribe "make-raw" "sae-make-raw" "${DIR}"
     subscribe "get" "sae-get-data" "${DIR}"

    #
    # Execute our events
    #
     publish grab ./data/biden-trump.tweetgen ./transformed/recent "text" 0 3
     publish map ./transformed/recent ./transformed/mapped
     #publish post ./transformed/mapped ./transformed/final \
         #157.245.233.116 1025 /api/nlp
     publish make-raw ./transformed/mapped ./transformed/raw
     #publish get ./transformed/recent ./transformed/final \
         #157.245.233.116 1025 /api/nlp
     #publish grab ./transformed/final ./transformed/sentiments "sentiment"
