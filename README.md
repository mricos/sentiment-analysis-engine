# Sentiment Analysis Engine

Provides positive, negative, or neutral classification for a sample of  English language text.

Current version is based off of [Natural](https://github.com/NaturalNode/natural), the node-based NLP library.

## API
Summary

Text -> Id
Id -> Sentiment
Id -> Text


To request analysis from the API
POST 
/api/nlp/analyze/sentiment


Request
```js
{
    text: String|String[] 
}

```

Response
```js
{
    id: ID
}

```


To request finished analysis
POST 
/api/nlp/analyze/sentiment/:id

Request
```js
{
    id: ID
}
```

Response
```js
{
    sentiment: Sentiment|Sentiment[]        
}
```


To request original data
POST
/api/nlp/data/:id

Request
```js
{
    id: ID
}
```

Response
```js
{
    data: Text|Text[]        
}
```


## 12 Factors

|Factor| Implementation Strategy|
|---|---|
|Codebase|Gitlab|
|Dependencies|npm & custom shell scripting & env for dependency isolation|
|Config|Store keys in .env file|
|Backing services|Twitter API & Google Translate API, no file-based io. Investigating [reload module at runtime](https://stackoverflow.com/questions/26633901/reload-module-at-runtime)|
|Build, release, run|Use npm build system and GitLab CI/CD|
|Processes|Shell script kicks off 2 processes: static server and API endpoint|
|Port binding| All ports are defined in .env and added at build time|
|Concurreny | Define a shell script to start and stop processes via GitLab CI/CD|
|Disposability|Handle SIGTERM and possibly handle events with a task queue.|
|Dev/prod parity|No database, 2 branches: dev and master, daily merges, smaill team, dev tools all Unix|
|Logs|All output to stdout, aggregated by process management script|
|Admin processes|Support a REPL, support remote shell commands, separate admin dir|
## References
- [12 Factor](https://12factor.net/)
- [12 factor slides](https://peterlyons.com/twelve-factor-nodejs/#/16)
- [twelve-factor methodology used at cloud.gov](https://github.com/adborden/twelve-factor-nodejs)
- [Ben Awad on CI/CD clean-up video](https://www.youtube.com/watch?v=CYlUcIH3dPg)
- [Spacy](https://spacy.io/)
- [Natural Language Processing](https://en.wikipedia.org/wiki/Natural_language_processing)




## TODO
- ~~Give Mike permissions~~
- ~~Specify 12 factors used under references~~
- ~~Add a link to Spacy~~
- Find a couple good articles on NLP
- Respond to requests with netcat (nc)
