'use strict'

Q = require('q')
fs = require('fs-extra')
url = require('url')
path = require('path')
request = require('request')
exec = require('exec')
config = require './config.coffee'
qRequest = Q.nbind(request, request)
qFsOutput = Q.nbind(fs.outputFile, fs)
qFsRead = Q.nbind(fs.readFile, fs)
qExec = Q.nbind(exec, exec)

module.exports =
  downloadFile: (fileURL) ->
    return Q.Promise (resolve, reject, notify) ->
      URL = url.parse(fileURL)
      filePath = "#{config.resourcePath}/#{path.basename(URL.path)}"

      qRequest(fileURL).then (resp) ->
        res =
          path: filePath
          body: resp[1]

        resolve(res)

      .catch (err) ->
        console.error 'request file failed: ', err
        reject(err)

  writeFile: (filePath, data) ->
    return Q.Promise (resolve, reject, notify) ->
      qFsOutput(filePath, data).then ->
        console.log filePath, "write done"
        resolve(filePath)
      .catch (err) ->
        console.error 'write file failed: ', err
        reject(err)

  readFile: ->
    return Q.Promise (resolve, reject, notify) ->
      filePath = "#{config.mainFile}"
      qFsRead(filePath, 'utf8').then (data) ->
        console.log 'read done'
        resolve(data)
      .catch (err) ->
        console.error 'read file failed: ', err
        reject(err)

  gulpFile: ->
    return Q.Promise (resolve, reject, notify) ->
      qExec('node_modules/.bin/gulp').then ->
        console.log 'gulp file success'
        resolve()
      .catch (err) ->
        console.error 'gulp file failed: ', err
        reject(err)

  cleanFile: ->
    return Q.Promise (resolve, reject, notify) ->
      qExec('node_modules/.bin/gulp clean').then ->
        console.log 'clean file success'
        resolve()
      .catch (err) ->
        console.error 'clean file failed: ', err
        reject(err)

