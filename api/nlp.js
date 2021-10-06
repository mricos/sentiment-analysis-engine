import analyzeSentiments from "../lib/analyze-sentiments.js";

// http://IP:PORT/api/nlp
export default function(req, res) {
    
    // data: String
    const data = 
        typeof(req.body.data) === "string" || Array.isArray(req.body.data) 
	        ? req.body.data 
	        : false;

    // if data is String
    if (typeof(data) === "string") {
	    
        const sentiment = analyzeSentiments(data);
        
        res.status(200).json({
	        sentiment
	    });

    // if data is Array
    } else if (Array.isArray(data)) {

        const sentiment = data.map(analyzeSentiments);

        res.status(200).json({
            sentiment
        });

    } else {
        
        res.status(400).json({
	        message: "Incorrect request body data type.",
		data: req.body.data
	    });
    }
}
