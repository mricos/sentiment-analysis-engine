nom-create-random-intArray() {
  local len="$1"; # length of array to create
  local maxLimit="$2"; # generate ints from 0 to maxLimit
  ((maxLimit--)) # zero-indexed
  local int_array=();
  while [[ "$len" > 0 ]]; do
    int_array+=($((1 + $RANDOM % "$2")))
    ((len--))
  done
  int_array=("[""${int_array[@]}""]")
  echo "${int_array[*]}" | tr ' ' ','
}
