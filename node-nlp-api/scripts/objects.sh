OBJ_PATH=/home/admin/src/sentiment-analysis-engine/scripts/objects

object-help(){
  echo ' 
reqHash:   nanosecond time stamp at time of creation
$1 type:   string | sentiment 
$2 action: getSentimentFromString 
$3 data:   presumes one data element per line

Number of data elements equals: number of lines.
Ends with double return (ala HTTP)
'

}
object-create(){
   local ts=$(date +%s.%N)
   echo "$ts
$1
$2
$3" > $OBJ_PATH/$ts

echo $ts
}
