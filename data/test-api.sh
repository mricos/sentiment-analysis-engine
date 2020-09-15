# use: ./test-api.sh > test.results

source ./sae.sh

echo "POST array to API" >> test.results
sae-parse-file text-array.json | sae-post-data 157.245.233.116 1025 \
	/api/nlp/analyze/sentiment > api.results
array_id="$(jq '.id' < api.results)"
echo -e "ID received for array data: $array_id\n" >> test.results

echo "GET sentiments for array:$array_id" >> test.results
sae-get-data-with-id 157.245.233.116 1025 \
	/api/nlp/analyze/sentiment "$array_id" > api.results
array_sentiment="$(jq '.sentiments' < api.results)";
echo -e "Sentiments for array: $array_sentiment\n" >> test.results

echo "GET original data for array:$array_id" >> test.results
sae-get-data-with-id 157.245.233.116 1025 \
	/api/nlp/data "$array_id" > api.results
original_array="$(jq '.data' < api.results)" >> test.results
echo "Original array data for array:$array_id" >> test.results
echo "$original_array" >> test.results

echo -e "\n\n" >> test.results

echo "POST string to API" >> test.results
sae-parse-file text-array.json | sae-post-data 157.245.233.116 1025 \
	/api/nlp/analyze/sentiment > api.results
string_id="$(jq '.id' < api.results)"
echo -e "ID received for string data: $string_id\n" >> test.results

echo "GET sentiment for string:$string_id" >> test.results
sae-get-data-with-id 157.245.233.116 1025 \
	/api/nlp/analyze/sentiment "$string_id" > api.results
string_sentiment="$(jq '.sentiments' < api.results)";
echo -e "Sentiment for string: $string_sentiment\n" >> test.results

echo "GET original data for string:$string_id" >> test.results
sae-get-data-with-id 157.245.233.116 1025 \
    /api/nlp/data "$string_id" > api.results
original_string="$(jq '.data' < api.results)";
echo "Original string data for string:$string_id" >> test.results
echo "$original_string" >> test.results

rm api.results
