require "colors"
express = require "express"

$ = require "core.js"
$.ext(require("fs"))

VIEW_DIR = "view"
PUBLIC_DIR = "public"

module.exports = app = express()

configure = ->
  cfg = $.readFileSync("#{@get('env')}.json").toString()
  $.extend @settings, JSON.parse(cfg)

  @use(express.bodyParser())
  @use(express.logger('short'))
  @use(@router)
  @use(express.favicon())
  @use(express.static(PUBLIC_DIR))
  @use (req, res) ->
    res.statusCode = 404
    throw new Error('Not Found')
  @use(express.errorHandler())
    
  app.set("views", VIEW_DIR)
  app.set('layout', 'layout')
  @engine('mu', require("hogan-express"))
  app.set("view engine", "mu")

configure.call(app)

app.get "/", (req, res) ->
  res.render "about" 

app.listen(app.get("server port"), app.get("server interface"))
console.log "listen #{app.get('server port')}".green

