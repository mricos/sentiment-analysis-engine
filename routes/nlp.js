import express from "express";
import fs from "fs";
import path from "path";
import createSentiments from "./utils/create-sentiments.js";

const router = express.Router();
const __dirname = dirname(fileURLToPath(import.meta.url));

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
	    const pathToDb = path.join(__dirname, "data/sentiments.json");
	    console.log("Path to db: ", pathToDb);
	    fs.readFile(
		pathToDb,
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
			pathToDb,
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
