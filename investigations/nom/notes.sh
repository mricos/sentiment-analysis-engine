notes="
The following describes Types and Processes defined and implemented 
by the nodeholder system. 

It takes its inspiration from:
- David Spivak's olog concept
- Tobias Fritz description of Markov Categories
- Evan Patterson's Catlab
"
# Process: process.Stream simulation of stream ingress
# Input: type.path
# Output: type.tweetgen
cat $DATA | \

# Process: process.AddId: add nodeholder id to object 
# Input: type.tweetgen
# Output: type.nom
jq '.+{id: now, type:tweetgen }' | \

# Process: process.AugmentId: add current time to id. 
# Input: type.nom
# Output: type.nom.
jq '.id | tostring + "'".$(date +%s.%N)"'"'
