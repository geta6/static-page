'use strict'

require.config
  baseUrl: '/config'

  paths:
    'moment': '../vendor/moment'
    'jquery': '../vendor/jquery'
    'underscore': '../vendor/lodash'
    'bootstrap': '../vendor/bootstrap'
    'backbone': '../vendor/backbone'
    'backbone.wreqr': '../vendor/backbone.wreqr'
    'backbone.babysitter': '../vendor/backbone.babysitter'
    'backbone.marionette': '../vendor/backbone.marionette'

require [
  'app'
], (App) ->
  App.start()
