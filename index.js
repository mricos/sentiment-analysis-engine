/* jslint
    node
*/
import express from "express";
import cookieParser from "cookie-parser";
import logger from "morgan";

import nlpRouter from "./routes/nlp.js";
import testRouter from "./routes/tests.js";

const app = express();

app.use(logger("dev"));
app.use(express.json({limit: "25mb"}));
//app.use(express.urlencoded({limit: "25mb", extended: false}));
app.use(cookieParser());

function auth(req, res, next) {
    console.log("req.headers.authorization: ", req.headers.authorization);
    console.log("process.env.AUTH_KEY: ", process.env.AUTH_KEY);
}

app.use("/api/nlp", auth, nlpRouter);
//app.use("/api/test", testRouter);

export default Object.freeze(app);
