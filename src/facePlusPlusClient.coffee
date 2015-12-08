qs      = require 'qs'
path    = require 'path'
config  = require 'config'
request = require 'superagent'
Promise = require 'bluebird'

{API_KEY, API_SECRET} = config.get 'FACE_PP'
console.log config.get 'FACE_PP'


module.exports = class FacePlusPlusClient
  constructor: ->

  get: (path, params) ->
    url = "https://apius.faceplusplus.com/v2#{path}?api_secret=#{API_SECRET}&api_key=#{API_KEY}"
    optional = qs.stringify params
    url += "&#{optional}"
    console.log "=======================> FacePlusPlusClient Get"
    console.log url

    return new Promise (resolve, reject) =>
      request
      .get(url)
      .end (err, res) ->
        return reject err unless res.statusCode is 200

        console.log res.text
        result = JSON.parse res.text

        return resolve result
