import express from "express";

const router = express.Router();

// String[] -> Sentiment[] 

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
