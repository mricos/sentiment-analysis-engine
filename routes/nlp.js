import express from "express";
import fs from "fs";
import path from "path";
const { dirname } = path;
import { fileURLToPath } from "url";
const router = express.Router();
import analyzeSentiments from "./utils/analyze-sentiments.js";

const __dirname = dirname(fileURLToPath(import.meta.url));

const typesLibrary = {
    "text": true,
    "transactionId": true
};

const actionsLibrary = {
    "sentiment": analyzeSentiments,
    "capitalize": text => text.toUpperCase()
};

router.post("/", function(req, res, next) {
    
    // check if data type is string and if it's a type in the library
    const type = 
        typeof(req.body.type) === "string" 
	&& req.body.type.length > 0
	&& typesLibrary[req.body.type]
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
	&& actionsLibrary[req.body.action]
	    ? req.body.action
	    : false;
    
    // check if data type is string or array
    const data = 
        typeof(req.body.data) === "string" && req.body.data.length > 0 
        || Array.isArray(req.body.data) && req.body.data.length > 0 
            ? req.body.data
            : false;

    if (
        data
	&& (type || action)
	&& reqHash
    ) {
        // creates array of nanoseconds, 
        // chooses second option, 
	// turns to string
        const id = process.hrtime()[1].toString();
        const transformedData = 
            Array.isArray(data) 
	        ? data.map(actionsLibrary[action])
	        : typeof(data) === "string" 
		    ? actionsLibrary[action](data)
	            : "Not correct data type";
	
	console.log("Here is the transformed data: ", transformedData);

        res.status(200).json({
	    reqHash, 
	    type: "transactionId",
	    id
	});

    } else {
        res.status(422).json({
	    message: "Request requires data (string or array of strings), type (string), action (string), and reqHash (string or number)"
	});
    }
});

export default router;
