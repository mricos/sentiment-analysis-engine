import aposToLexForm from "apos-to-lex-form";
import natural from "natural";
import SpellCorrector from "spelling-corrector";
import sw from "stopword";

const spellCorrector = new SpellCorrector();
spellCorrector.loadDictionary();

export default function(text) {
	console.time("Sentiment Analysis");
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
	console.timeEnd("Sentiment Analysis");
        return sentiment.toFixed(4); 
}
