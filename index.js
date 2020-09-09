/* jslint
    node
*/
import express from "express";
// import path from "path";
// const {dirname} = path;
// import {fileURLToPath} from "url";
import cookieParser from "cookie-parser";
import logger from "morgan";

import indexRouter from "./routes/index.js";
import nlpRouter from "./routes/nlp.js";

const app = express();
// const __dirname = dirname(fileURLToPath(import.meta.url));
// console.log("Here is import.meta.url: ", import.meta.url);
// console.log("Here is dirname: ", __dirname);

app.use(logger("dev"));
app.use(express.json({limit: "25mb"}));
app.use(express.urlencoded({limit: "25mb", extended: false}));
app.use(cookieParser());
// app.use(express.static(path.join(__dirname, "public")));

app.use("/", indexRouter);
app.use("/api/nlp", nlpRouter);

export default Object.freeze(app);
