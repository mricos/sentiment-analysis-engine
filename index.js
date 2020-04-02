/*jslint
    node
*/
import express from "express";
import path from "path";
const {dirname} = path;
import {fileURLToPath} from "url";
import cookieParser from "cookie-parser";
import logger from "morgan";

import indexRouter from "./routes/index.js";
import nlpRouter from "./routes/nlp.js";

const app = express();
const __dirname = dirname(fileURLToPath(import.meta.url));

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({extended: false}));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, "public")));

app.use("/", indexRouter);
app.use("/api/nlp", nlpRouter);

export default app;
