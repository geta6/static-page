'use strict'

require.config
  baseUrl: '/config'

  paths:
    'moment': '../vendor/moment/moment'
    'jquery': '../vendor/jquery/dist/jquery'
    'lodash': '../vendor/lodash/dist/lodash'
    'bootstrap': '../vendor/bootstrap/dist/js/bootstrap'

require [
  'app'
], (App) ->
  App.start()
