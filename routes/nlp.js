import express from "express";
import fs from "fs";
import path from "path";
const { dirname } = path;
import createSentiments from "./utils/create-sentiments.js";
import { fileURLToPath } from "url";
const router = express.Router();
const __dirname = dirname(fileURLToPath(import.meta.url));

const PATHTODB = path.join(__dirname, "../data/sentiments.json");

router.get("/analyze/sentiment/:id", function (req, res, next) {
    const id = req.params.id 
    console.log("Here is id: ", id);
    console.log("Datatype of id: ", typeof(id));

    fs.readFile(
        PATHTODB,
	function(err, data) {
	    if (err) throw err;
            const db = JSON.parse(data);
	    console.log("Here is the current db: ", db)
	}
    );
    
});

router.post("/analyze/sentiment", function(req, res, next) {

    const dataToAnalyze = 
        typeof(req.body.text) === "string" 
	|| typeof(req.body.text) === "object" && Array.isArray(req.body.text)
	    ? req.body.text
	    : false;

    console.log("Here is the data from POST: ", dataToAnalyze);

    // if there's data to analyze
    if (dataToAnalyze) {

	// if the data comes in the form of an array
	if (Array.isArray(dataToAnalyze)) {

	    const sentiments = dataToAnalyze.map(createSentiments);
	    
	    fs.readFile(
		PATHTODB,
	        function(err, data) {
	            if (err) throw err;
		    // Pull object database from file	    
	            const db = JSON.parse(data);
	            const id = Date.now();
		    // Update database
	            db[id] = {sentiments};
		    const refreshedDb = JSON.stringify(db);
	            // Write to database with update
		    fs.writeFile(
			PATHTODB,
			refreshedDb,
		        function(err) {
			    if (err) throw err;
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
