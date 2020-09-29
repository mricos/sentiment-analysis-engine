import express from "express";
import fs from "fs";
import path from "path";
const { dirname } = path;
import { fileURLToPath } from "url";
const router = express.Router();
import analyzeSentiments from "./utils/analyze-sentiments.js";
import baseUrlHandler from "./utils/baseUrl-handler.js";

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

// new code starts here

const actionsTypesLibrary = {
    analyze: {
        text: {
	    sentiment: analyzeSentiments
	}
    },
    lowercase: {
        text: {
	    text: str => str.toLowerCase()
	}
    },
    fetch: {
        transactionId: {
	    sentiment: console.log("Get data from file")    
	}
    }
};

//IP:PORT/api/nlp
router.post("/", function(req, res, next) {
    
    // action: String 
    const action = 
        typeof(req.body.action) === "string" 
	&& req.body.action.length > 0
	&& actionsTypesLibrary[req.body.action]
	    ? req.body.action
	    : false;
    
    // String[]: 2 types /sentiment/analyze/text
    // String: 1 types /text/lowercase/text
    // types: String | String[] && String[].length === 2
    // Where types is a single string: Type => Type
    // Where types is an array of two strings: Type[0] => Type[1] 
    const types = 
        typeof(req.body.types) === "string" 
	&& req.body.types.length > 0
	&& actionsTypesLibrary[action][req.body.types][req.body.types]
	    ? req.body.types
	    : Array.isArray(req.body.types)
	        && req.body.types.length === 2
	        && actionsTypesLibrary[
		    action
		][
		    req.body.types[0]
		][
		    req.body.types[1]
		]
	            ? req.body.types
		    : false;

    const typesIsArray = Array.isArray(types);
    const typesIsString = typeof(types) === "string";

    // reqHash: String | Number	
    const reqHash = 
        typeof(req.body.reqHash) === "string" && req.body.reqHash.length > 0
	|| typeof(req.body.reqHash) === "number"
	    ? req.body.reqHash
	    : false;

    // data: String | String[]
    const data = 
        typeof(req.body.data) === "string" && req.body.data.length > 0 
        || Array.isArray(req.body.data) && req.body.data.length > 0 
            ? req.body.data
            : false;

    // if a correct request body was sent
    if (
        reqHash
	&& types
	&& action
	&& data
    ) {
        const id = process.hrtime().map(n => `${n}`).join(".");  
	const request = {reqHash, data, id};
        
	function handleThen(value) {
	    console.log("value: ", value);
            res.status(200).json({message: "Server hit."});
	}
	
	function handleCatch(err) {
	    console.error("err: ", err);
	    res.status(400).json({message: "Something went wrong."});
	}
	
	if (typesIsArray) {
	    baseUrlHandler.post(
	        `/${types[1]}/${action}/${types[0]}`, 
		request
	    ).then(handleThen)
	    .catch(handleCatch);
	
	    res.status(200).json({
	        reqHash,
		id,
		type: "transactionId"
	    });

	} else if (typesIsString) {
	    baseUrlHandler.post(
	        `/${types}/${action}/${types}`,
		request
	    ).then(handleThen)
	    .catch(handleCatch);

            res.status(200).json({
	        reqHash,
		id,
		type: "transactionId"
	    });
	
	} else {
	    res.status(422).json({message: "Malformed request body."});
	}

    // if the request body is malformed
    } else {
        res.status(422).json({message: "Malformed request body."}); 
    }
});

router.post("/:toType/:action/:fromType", function (req, res, next) {
    // if action === "analyze"
    // else if action === "fetch"
	
    const {
        toType, 
	action, 
	fromType
    } = req.params;
    console.log(`${toType}/${action}/${fromType} `, req.body);

});

export default router;
