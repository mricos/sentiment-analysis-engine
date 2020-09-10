import express from "express";
import createSentiments from "./utils/create-sentiments.js";

const router = express.Router();

// String[] -> Sentiment[] 

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

router.post("/analyze/sentiment", function(req, res, next) {

    const dataToAnalyze = 
        typeof(req.body) === "object" 
	&& Array.isArray(req.body) 
	&& req.body.length
	    ? req.body
	    : false;

    // if there's an array of data to analyze
    if (dataToAnalyze) {
        
	const sentiments = dataToAnalyze.map(createSentiments);
        
	res.status(200).json(sentiments);
    
    } else {
        res.status(400).json({
	    message: "Incorrect data type or no data submitted."
	});    
    }
        
});

export default router;
