/* jslint
    node
*/
import express from "express";
import cookieParser from "cookie-parser";
import logger from "morgan";
import nlpRouter from "./routes/nlp-mike.js";

const app = express();
import cors from "cors";;

app.use(cors());
app.use(logger("dev"));
app.use(express.json({limit: "25mb"}));
app.use(cookieParser());
app.use("/", nlpRouter);
export default Object.freeze(app);
