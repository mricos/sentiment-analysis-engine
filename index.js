/* jslint
    node
*/
import express from "express";
import cookieParser from "cookie-parser";
import logger from "morgan";
//import authorizer from "./utils/auth.js";

import nlpRouter from "./routes/nlp.js";
import testRouter from "./routes/tests.js";

const app = express();

app.use(logger("dev"));
app.use(express.json({limit: "25mb"}));
//app.use(express.urlencoded({limit: "25mb", extended: false}));
app.use(cookieParser());

app.use("/api/nlp", nlpRouter);
//app.use("/api/test", testRouter);

export default Object.freeze(app);
