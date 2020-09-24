import express from "express";
import fs from "fs";
import path from "path";
const { dirname } = path;
import { fileURLToPath } from "url";
const router = express.Router();

const __dirname = dirname(fileURLToPath(import.meta.url));


router.post("/", function(req, res, next) {
    const body = req.body;
    res.status(200).json({ body });
});

export default router;
