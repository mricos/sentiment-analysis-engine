import express from "express";
import fs from "fs";
import createSentiments from "./utils/create-sentiments.js";

const router = express.Router();

router.post("/analyze/sentiment", function(req, res, next) {

    const dataToAnalyze = 
        typeof(req.body.text) === "string" 
	|| typeof(req.body.text) === "object" && Array.isArray(req.body.text)
	    ? req.body.text
	    : false;

    console.log("Here is the data: ", dataToAnalyze);

    // if there's data to analyze
    if (dataToAnalyze) {

	// if the data comes in the form of an array
	if (Array.isArray(dataToAnalyze)) {

	    const sentiments = dataToAnalyze.map(createSentiments);
	
	    fs.readFile(
		"./data/sentiments.json",
	        function(err, data) {
	            if (err) throw err;
		    
	            const currentSentiments = JSON.parse(data);
	            const id = Date.now();
		    console.log(
	                "read file. currentSentiments: ", 
			currentSentiments
		    );
		    console.log("id: ", id);
		    
	            currentSentiments[id] = {sentiments};

	            fs.writeFile(
	                "../data/sentiments.json", 
			currentSentiments,
		        function(err) {
			    if (err) throw err;
                            console.log("../data/sentiments.json written to")

                            res.status(200).json({
                                id
                            });
			}
		    )
		}
	    );

	} else if (typeof(dataToAnalyze) === "string") {
	    
	    const sentiment = createSentiments(dataToAnalyze);
	    
	    res.status(200).json({
	        timestamp: new Date(),
		sentiment
	    });
	
	} else {
	    res.status(400).json({
	        message: "Incorrect data type provided."
	    });
	}
    
    } else {
        res.status(400).json({
	    message: "Incorrect data type or no data submitted."
	});    
    }
        
});

export default router;
