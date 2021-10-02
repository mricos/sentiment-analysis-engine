export default function (req, res) {
    res.status(200).send(
        "Welcome to SAE!\nPlease, post text to `/api/nlp` for sentiment analysis."
    );
}
