import analyzeSentiments from "./utils/analyze-sentiments.js"; 

const text = process.argv[2];

const sentiment = analyzeSentiments(text)

console.log({sentiment});
