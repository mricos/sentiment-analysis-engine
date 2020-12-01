def add_id(prefix):
  [ .,  [ range(0;length) | {"id": (prefix + tostring) } ] ]
  | transpose | map(add);
