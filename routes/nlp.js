import express from "express";
import fs from "fs";
import path from "path";
const { dirname } = path;
import { fileURLToPath } from "url";
const router = express.Router();

const __dirname = dirname(fileURLToPath(import.meta.url));


router.post("/", function(req, res, next) {
    console.log("Here is the req.body", req.body);
});

export default router;
