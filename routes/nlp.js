import express from "express";
import fs from "fs";
import path from "path";
import { getId, postData } from "./utils/handler.js";
const { dirname } = path;
import analyzeSentiments from "./utils/analyze-sentiments.js";
import { fileURLToPath } from "url";
const router = express.Router();

const __dirname = dirname(fileURLToPath(import.meta.url));
const PATH_TO_SENTIMENTS = path.join(__dirname, "../data/sentiments.json");
const PATH_TO_ORIGINAL = path.join(__dirname, "../data/original.json")
// Possible refactor: PATH_TO_SENTIMENTS = process.env.PATH_TO_SENTIMENTS;
// nh/env - will need for jwt?


router.get("/data/:id", function (req, res, next) {
    // if id is datatype number, use it as a string. Otherwise reject    
    const id = Number(req.params.id) ? req.params.id : false;
    
    if (id) {
        // handles 200 and 404 not found
        getId(PATH_TO_ORIGINAL, id, res); 
    
    } else {
      
        res.status(400).json({message: "Please, provide id."})
    
    }
});

router.get("/analyze/sentiment/:id", function (req, res, next) {
    // if id is datatype number, use it as a string. Otherwise reject
    const id = Number(req.params.id) ? req.params.id : false;

    if (id) {
        // handles 200 and 404 not found
	getId(PATH_TO_SENTIMENTS, id, res);

    } else {
        
        res.status(400).json({message: "Please, provide id."})
    
    }
});

router.post("/analyze/sentiment", function(req, res, next) {

    const dataToAnalyze = 
        typeof(req.body.text) === "string" 
	|| typeof(req.body.text) === "object" && Array.isArray(req.body.text)
	    ? req.body.text
	    : false;

    // if there's data to analyze
    if (dataToAnalyze) {

        // key in the key:value pair of id and data.
	const id = Date.now();
	
	// if the data comes in the form of an array
	if (Array.isArray(dataToAnalyze)) {

	    const sentiments = dataToAnalyze.map(analyzeSentiments);
	    
            postData(
	        PATH_TO_ORIGINAL,
		id,
                {data: dataToAnalyze},
		function(id) {
		    console.log(
		        `ID ${id} data preserved in /data/original.json`
		    );
		}
	    );

	    postData(
	        PATH_TO_SENTIMENTS,
		id,
                { sentiments },
                function(response, id) {
		    console.log(`ID ${id} sent to client.`);
	            console.log("Analysis successful.");
                    response.status(200).json({
                        id
                    });
		},
		res
	    );
            /*
	    fs.readFile(
	        PATH_TO_ORIGINAL,
		function(err, data) {
		    if (err) throw err;

		    // Pull object database from file
		    const db = JSON.parse(data);
		    // Create new key of id with value
		    db[id] = {data: dataToAnalyze};
		    // Transform the object back into a string
		    // in order to write to file
		    const refreshedDb = JSON.stringify(db);

		    // Write to database with update
		    fs.writeFile(
			PATH_TO_ORIGINAL,
			refreshedDb,
		        function(err) {
			    if (err) throw err;
		            console.log(
			        `ID ${id} data preserved in /data/original.json`
			    );
			}
		    );
		}
	    );
            	    
	    fs.readFile(
		PATH_TO_SENTIMENTS,
	        function(err, data) {
	            if (err) throw err;
		    // Pull object database from file	    
	            const db = JSON.parse(data);
		    // Update database
	            db[id] = {sentiments};
		    const refreshedDb = JSON.stringify(db);
	            // Write to database with update
		    fs.writeFile(
			PATH_TO_SENTIMENTS,
			refreshedDb,
		        function(err) {
			    if (err) throw err;
			    console.log(`ID ${id} sent to client.`);
			    console.log("Analysis successful.");
                            res.status(200).json({
                                id
                            });
			}
		    );
		}
	    );
	    */

	} else if (typeof(dataToAnalyze) === "string") {
	    
	    const sentiments = analyzeSentiments(dataToAnalyze);

	    fs.readFile(
	        PATH_TO_ORIGINAL,
		function(err, data) {
		    if (err) throw err;

		    // Pull object database from file
		    const db = JSON.parse(data);
		    // Create new key of id with value
		    db[id] = {data: dataToAnalyze};
		    // Transform the object back into a string
		    // in order to write to file
		    const refreshedDb = JSON.stringify(db);

		    // Write to database with update
		    fs.writeFile(
			PATH_TO_ORIGINAL,
			refreshedDb,
		        function(err) {
			    if (err) throw err;
		            console.log(
			        `ID ${id} data preserved in /data/original.json`
			    );
			}
		    );
		}
	    );
	    
	    fs.readFile(
		PATH_TO_SENTIMENTS,
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
			PATH_TO_SENTIMENTS,
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
