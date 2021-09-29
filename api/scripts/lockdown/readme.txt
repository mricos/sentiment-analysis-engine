These are the lockdown files that describe the interface
to the Sentiment Analysis Engine.

Files are named with the Nodeholder extension convention
of obj-type.file-type. Eg data.sentiment.sae implies
the data can be read by the sentiment analysis engine
and objects found in the file are of type=sentiment.

For example:

data.sentiment.sae:

  
  "type":"sentiment",
  "data":[ array of sentiment values ]
}
