# Sentiment Analysis Engine

Provides positive, negative, or neutral classification for a sample of  English language text.

Current version is based off of [Natural](https://github.com/NaturalNode/natural), the node-based NLP library.

## API
To query the API
```js
{
    key: "system assigned key value",
    text: "English sentence or word",
    language: "en"
}
```

Response
```js
{
    sentiment: "positive | negative | neutral"
}
```
## 12 Factors

|Factor| Implementation Strategy|
|---|---|
|Codebase|Gitlab|
|Dependencies|npm & custom shell scripting & env for dependency isolation|
|Config|Store keys in .env file|
|Backing services|Twitter API & Google Translate API, no file-based io. Investigating [reload module at runtime](https://stackoverflow.com/questions/26633901/reload-module-at-runtime)|




## References
- [12factor](https://12factor.net/)




## TODO
- ~~Give Mike permissions~~
- Specify 12 factors used under references
- Add a link to Spacy
- Find a couple good articles on NLP
- Respond to requests with netcat (nc)