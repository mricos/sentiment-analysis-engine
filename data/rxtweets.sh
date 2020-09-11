nc localhost 3000 | jq '.'
# Todo: figure out how to make jq call sae for each tweet and 
# add sentiment to each JSON object
# write output to stdout is fine, redirect inton out-with-sentiment.json

# Example filter pulling the text field from an Object
# Remember Jq treats Arrays []  and Objects differently

#nc localhost 3000 | jq '.text'
