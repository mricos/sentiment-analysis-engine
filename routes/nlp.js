import express from "express";
import fs from "fs";
import path from "path";
const { dirname } = path;
import { fileURLToPath } from "url";
const router = express.Router();
import analyzeSentiments from "./utils/analyze-sentiments.js";

const __dirname = dirname(fileURLToPath(import.meta.url));
const PATH_TO_SENTIMENTS = path.join(__dirname, "../data/sentiments");

function getSentiments(
    path,
    reqHash,
    response
) {
    fs.readFile(
        `${path}/${reqHash}.json`,
	 function (err, data) {
	     if (err) {
	         console.error(err);
		 return;
	     } else if (data) {
	         const fileData = JSON.parse(data);
		 response.status(200).json({
		     reqHash: fileData.reqHash, 
	             type: fileData.type, 
	             data: fileData.data
		 });
	     } 
	 }
    );
}

// Specifies the allowed types and what actions may be performed
const typesActionsLibrary = {
    text: {
        sentiment: analyzeSentiments,
	capitalize: text => text.toUpperCase()
    },
    transactionId: getSentiments
};

router.post("/", function(req, res, next) {
    
    // check if data type is string and if it's a type in the library
    const type = 
        typeof(req.body.type) === "string" 
	&& req.body.type.length > 0
	&& typesActionsLibrary[req.body.type]
	    ? req.body.type
	    : false;

    // check if hash is a string or a number	
    const reqHash = 
        typeof(req.body.reqHash) === "string" && req.body.reqHash.length > 0
	|| typeof(req.body.reqHash) === "number"
	    ? req.body.reqHash
	    : false;

    // check if action is a string and is in the action library 
    const action = 
        typeof(req.body.action) === "string" 
	&& req.body.action.length > 0
	&& typesActionsLibrary[req.body.type][req.body.action]
	    ? req.body.action
	    : false;
    
    // check if data type is string or array
    const data = 
        typeof(req.body.data) === "string" && req.body.data.length > 0 
        || Array.isArray(req.body.data) && req.body.data.length > 0 
            ? req.body.data
            : false;

    // if the request body is constructed correctly
    if (
	(type || action)
	&& reqHash
    ) {
        // if type is text and action is sentiment
	if (type && action) {
	    // creates array of nanoseconds, 
            // chooses second option, 
	    // turns to string
            const id = process.hrtime()[1].toString();
            const transformedData = 
                Array.isArray(data) 
	            ? data.map(typesActionsLibrary[type][action])
	            : typeof(data) === "string" 
		        ? typesActionsLibrary[type][action](data)
	                : "Not correct data type";
	
	    fs.writeFile(
	        `${PATH_TO_SENTIMENTS}/${reqHash}.json`,
	        JSON.stringify({
	            reqHash, 
		    type: "sentiment", 
		    data: transformedData, 
	        }),
	        function (err) {
	            if (err) {
		        console.error(err);
		    }  
	        }
	    );
        
	    res.status(200).json({
	        reqHash, 
	        type: "transactionId",
	        id
	    });
	
	} else if (type) {
	    // Specific type only has one action response.
            // Read reqHash file from path and respond accordingly
	    typesActionsLibrary[type](
	        PATH_TO_SENTIMENTS,
		reqHash,
		res
	    );
	} else {
            res.status(400).json({message: "Type or action is invalid."})	
	}

    } else {
        res.status(422).json({
	    message: "Request requires data (string or array of strings), type (string), action (string), and reqHash (string or number)"
	});
    }
});

export default router;
