# Sentiment Analysis Engine

Provides positive, negative, or neutral classification for a sample of  English language text.

Current version is based off of [Natural](https://github.com/NaturalNode/natural), the node-based NLP library.

## Versions

There are two current versions of this application. One deployed through Vercel which can be found [here](https://sentiment-analysis-engine.vercel.app/)

The other version can be found in the directory titled ```node-nlp-api``` which can be run locally as an API on your local machine. Most tools associated with this project are written in Nodejs or bash.

## Install of node-nlp-api
```bash
git clone https://gitlab.com/zoverlvx/sentiment-analysis-engine.git

cd sentiment-analysis-engine/node-nlp-api && npm i
```

## Run
```bash
npm start 
```

## API

To request sentiment analysis from the API\
Send POST to localhost:PORT/api/nlp\
PORT defaults to 3000 if PORT is not in environment

Request
```js
{
    data: String|String[] 
}
```

Response
```js
{
    sentiment: Sentiment|Sentiment[]
}
```

Example Request:
```bash
curl -X POST \
-H "Content-Type: application/json" \
-d '{"data": ["good", "bad", "beautiful"]}'\
localhost:3000/api/nlp
```

This API is currently equipped with stress tests.
The script ```test``` will use text examples from ```lockdown.txt```
in order to test the response rate of the API.


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

