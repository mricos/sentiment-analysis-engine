#######################
# Nodeholder Object Model Format 001
# POID=filename aka Batch ID
# 
# Repeated Stanzas:
# ID
# TYPE
# DATA (arbitrary length followed by newline
# 
#######################


#######################
# nom.index Format 001 
# Repeaded stanzas:
# ID
# TYPE
# DATA_LINE_START
# DATA_LINE_END
#
#######################

#######################
# Response Format 001 
# Currently only on stanza per file
#
# RES_ID
# REQ_ID   # response type from process type
# BATCH_ID
# DATA  (output of process)
#######################
source ../nom.sh

# Input:     data.nom
# Output     Indexed version on standard out
# Reference: data.nom.index
nom-test-nomToIndex(){
  cat data.nom | process/nomToIndex | diff data.index -
}

# Input:     data.nom
# Output:    response/{POIDs}
# Reference: lockdown data file needs to be created.
nom-test-nom-dispatch(){
  cat data.nom | process/nomToIndex | nom-dispatch $doZ 1025
}

# Input:     response/*.nom
# Outut:     no lockdown files yet
# Reference: Should be 
nom-test-response-to-summary(){
   nom-summary 
}

# Input:     response/*.nom
# Outut:     no lockdown files yet
# Reference: Should be 
nom-test-find(){
   nom-find sentiment
}

nom-find(){
  nom-get-all-data | grep $1
}

nom-get-all-data(){
  for poid in response/*; do
      awk 'NR>3' $poid # returns just data to stdout
  done 
}

