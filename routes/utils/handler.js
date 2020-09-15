import { readFile, writeFile } from "fs";


export function getId(path, id, response) {
    readFile(
        path,
	function(err, data) {
	    if (err) throw err;
            const db = JSON.parse(data);
	    const item = db[id];
            if (item) {
		// Update database
		delete db[id];
		const refreshedDb = JSON.stringify(db);
		// Write to database with update
		writeFile(
		    path,
		    refreshedDb,
		    function(err) {
		        if (err) throw err;
		        response.status(200).json(item);
		    }
		);
	
             } else {
	         response.status(404).json({message: `Id ${id} not found.`});
	     }
	 }
    );   
}
