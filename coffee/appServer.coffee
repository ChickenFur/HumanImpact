express = require 'express'
app = express()

app.get '/dbpedia', (req, res) ->
  res.send req.query["wikipage"]

app.listen 3000
console.log "Listening on port 3000"