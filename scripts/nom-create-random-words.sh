nom-create-random-words() {
  local amount="$1"; # amount of words to create
  local words=($(cat "$2")); # $2: file from which to find words
  local len="${#words[@]}"; # generate indices from 0 to len
  ((len--)) # zero-indexed
  local random_words=();
  while [[ "$amount" > 0 ]]; do
    # generates random index 
    # uses random index to append word from words array to random_words
    local i="$(shuf -i 0-$len -n 1)";
    random_words+=("${words[$i]}");
    ((amount--))
  done
  echo "${random_words[*]}"
}
