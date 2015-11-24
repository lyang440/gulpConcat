'use strict'

url = require('url')
path = require('path')
base64url = require('base64url')
process = require './process.coffee'
Q = require('q')

module.exports =
  allFile: (fileArray) ->
    return Q.Promise (resolve, reject, notify) ->
      for file in fileArray
        process.downloadFile(file).then (result) ->
          console.log "downloadFile then"
          process.writeFile(result.path, result.body).then (filePath) ->
            resolve()
            console.log filePath, "writeFile then"

  controller: (req, resp) ->
    date = new Date()
    console.log 'start time',date.getTime()
    result =
      'code': 400
      'message': 'fail'

    if req.body == undefined
      result.code = 400
      result.message = 'body undefined'
      resp.jsonp result

    param = req.body
    if param.src == undefined
      result.code = 400
      result.message = 'body.src undefined'
      resp.jsonp result

    originUrl = param.src.url
    fileUrl = String(param.cmd)
    urlArray = fileUrl.split('/')
    fileArray = []

    for item, index in urlArray
      if index == 0 then fileArray.push originUrl
      else
        fileArray.push(base64url.decode(item))

    module.exports.allFile(fileArray).then ->
      console.log 'readFile'
      process.gulpFile().then ->
        process.readFile().then (data) ->
          console.log 'readFile then'
          resp.send data
          process.cleanFile()
          console.log 'sendfile done'
          console.log 'end time',date.getTime()