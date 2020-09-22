# use: ./test-api.sh > test.results

source ./sae.sh

IP=157.245.233.116;
PORT=1025;
DATA=/home/admin/src/sentiment-analysis-engine/data/biden-trump.tweetgen

echo "POST array to API" >> test.results
sae-parse-file $DATA text 0 5 | sae-post-data $IP $PORT \
	/api/nlp/analyze/sentiment > api.results
array_id="$(jq '.id' < api.results)"
echo -e "ID received for array data: $array_id\n" >> test.results

echo "GET sentiments for array:$array_id" >> test.results
sae-get-data-with-id $IP $PORT \
	/api/nlp/analyze/sentiment "$array_id" > api.results
array_sentiment="$(jq '.sentiments' < api.results)";
echo -e "Sentiments for array: $array_sentiment\n" >> test.results

echo "GET original data for array:$array_id" >> test.results
sae-get-data-with-id $IP $PORT \
	/api/nlp/data "$array_id" > api.results
original_array="$(jq '.data' < api.results)" >> test.results
echo "Original array data for array:$array_id" >> test.results
echo "$original_array" >> test.results

echo -e "\n\n" >> test.results

echo "POST string to API" >> test.results
sae-parse-file $DATA text 0 10 | sae-post-data $IP $PORT \
	/api/nlp/analyze/sentiment > api.results
string_id="$(jq '.id' < api.results)"
echo -e "ID received for string data: $string_id\n" >> test.results

echo "GET sentiment for string:$string_id" >> test.results
sae-get-data-with-id $IP $PORT \
	/api/nlp/analyze/sentiment "$string_id" > api.results
string_sentiment="$(jq '.sentiments' < api.results)";
echo -e "Sentiment for string: $string_sentiment\n" >> test.results

echo "GET original data for string:$string_id" >> test.results
sae-get-data-with-id $IP $PORT \
    /api/nlp/data "$string_id" > api.results
original_string="$(jq '.data' < api.results)";
echo "Original string data for string:$string_id" >> test.results
echo "$original_string" >> test.results

echo -e "\n\n" >> test.results
echo "POST an array above the length limit" >> test.results
sae-parse-file $DATA text 0 52 | sae-post-data $IP $PORT \
	/api/nlp/analyze/sentiment > api.results
error_code="$(cat api.results)"
echo "ERROR: $error_code" >> test.results

rm api.results
