import express from "express";

const app = express();

app.use(express.static("dashboard"));

const server = app.listen(8000, function() {
    const host = server.address().address;
    const port = server.address().port;
    console.log({host, port});  
    console.log("SAE dashboard listening on http://%s:%s", host, port);
});
