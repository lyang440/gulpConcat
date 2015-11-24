'use strict'

express = require('express')
bodyParser = require('body-parser')
base = require('./base.coffee')

app = express()
app.use bodyParser.json()
app.all '/uop', base.controller
app.listen 9100, -> console.log 'listen at port 9100 success'