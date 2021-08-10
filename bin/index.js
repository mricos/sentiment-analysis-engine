/* jslint
    node
*/

import express from "express";
import cookieParser from "cookie-parser";
import logger from "morgan";
//import authorizer from "../utils/auth.js";

import nlpRouter from "../routes/nlp.js";
//import saeRouter from "../routes/sae.js";

const app = express();

app.use(logger("dev"));
app.use(express.json({limit: "25mb"}));
//app.use(express.urlencoded({limit: "25mb", extended: false}));
app.use(cookieParser());

//app.use("/sae", saeRouter);
app.use("/api/nlp", nlpRouter);

export default Object.freeze(app);
