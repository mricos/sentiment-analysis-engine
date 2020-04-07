import express from "express";
import aposToLexForm from "apos-to-lex-form";
import natural from "natural";

import SpellCorrector from "spelling-corrector";
import sw from "stopword";

const router = express.Router();

const spellCorrector = new SpellCorrector();
spellCorrector.loadDictionary();

router.post("/s-analyzer", function(req, res, next) {
    const text = typeof(req.body.text)
        === "string" && req.body.text.length > 0
        ? req.body.text
        : false;
    const key = typeof(req.body.key)
        === "string"
        ? req.body.key
        : false;
    const language = typeof(req.body.language)
        === "string"
        ? req.body.language
        : false;
    if (
        text
        && key
        && language
    ) {
        const lexedReview = aposToLexForm(text);
        const casedReview = lexedReview.toLowerCase();
        const alphaOnlyReview = casedReview
            .replace(/[^a-zA-Z\s]+/g, "");
        const {WordTokenizer} = natural;
        const tokenizer = new WordTokenizer();
        const tokenizedReview = tokenizer
            .tokenize(alphaOnlyReview);

        tokenizedReview.forEach(function(word, index) {
            tokenizedReview[index] = spellCorrector.correct(word);
        });

        const filteredReview = sw.removeStopwords(tokenizedReview);

        const {SentimentAnalyzer, PorterStemmer} = natural;
        const analyzer = new SentimentAnalyzer(
            "English",
            PorterStemmer,
            "afinn"
        );
        const sentiment = analyzer.getSentiment(filteredReview);

        res.status(200).json({sentiment});
    }

    // handles if no text or incorrect type
    if (
        !text
        && key
        && language
    ) {
        res.status(400).json({
            "error": "Please, provide text to analyze."
        });
    }
});

export default router;
