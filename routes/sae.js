import express from "express";
const router = express.Router();
import path from "path";

// http://IP:PORT/sae
router.get("/", function(req, res, next) {
    res.sendFile("index.html", {root: path.join(__dirname, "./public")})    
});

export default router;
