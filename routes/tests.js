import express from "express";
import analyzeSentiments from "./utils/analyze-sentiments.js";

const router = express.Router();

// api/test/empty-array
router.post("/empty-array", function (req, res, next) {
    console.time("Empty Array Test");
    const received = 
	typeof(req.body) === "object" 
	&& Array.isArray(req.body)
	&& !req.body.length
	    ? true
	    : false;
    if (received) {
        console.timeEnd("Empty Array Test");
	res.status(200).json([]);
    } else {
        res.status(500).json({message: "Empty array test failed."});
    }
});

// api/test/analyze/sentiment
router.post("/analyze/sentiment", function(req, res, next) {
    console.time(`Sentiment Analysis of Array of length ${req.body.length}`);
    const dataToAnalyze = 
        typeof(req.body) === "object" 
	&& Array.isArray(req.body) 
	&& req.body.length
	    ? req.body
	    : false;

    // if there's an array of data to analyze
    if (dataToAnalyze) {
        
	const sentiments = dataToAnalyze.map(analyzeSentiments);
        console.timeEnd(`Sentiment Analysis of Array of length ${req.body.length}`);        
	res.status(200).json(sentiments);
    
    } else {
        res.status(400).json({
	    message: "Incorrect data type or no data submitted."
	});    
    }

});

export default router;
