'use strict'

define [
  'backbone'
  'backbone.marionette'
], (Backbone) ->

  App = new Backbone.Marionette.Application()

  App.addInitializer ->
    console.log 'marionette enabled'

  return App
