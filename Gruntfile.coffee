'use strict'

util = require 'util'
coffeelint = require 'coffeelint'
{reporter} = require 'coffeelint-stylish'

module.exports = (grunt) ->

  (require 'jit-grunt')(grunt)

  process.env.NODE_ENV = if 'build' in grunt.cli.tasks then 'production' else 'development'

  isProduction = process.env.NODE_ENV is 'production'

  grunt.registerTask '_build_js', [
    'coffee', 'coffeelint'
  ]

  grunt.registerTask '_build_css', [
    'stylus', 'csslint'
  ]

  grunt.registerTask '_build', [
    'clean', 'copy', '_build_js', '_build_css', 'jade'
  ]

  grunt.registerTask 'build', [
    '_build', 'requirejs'
  ]

  grunt.registerTask 'default', [
    '_build', 'connect', 'watch'
  ]

  grunt.initConfig
    clean:
      site: files: [{
        expand: true
        src: ['public/*', '!public/vendor']
      }]

    copy:
      site:
        files: [{
          expand: yes
          cwd: 'assets'
          src: ['*', '**/*', '!**/*.{jade,coffee,styl}']
          dest: 'public'
          filter: 'isFile'
        }]

    coffee:
      site:
        options:
          sourceMap: yes
        files: [{
          expand: yes
          cwd: 'assets'
          src: [ '*.coffee', '**/*.coffee' ]
          dest: 'public'
          filter: 'isFile'
          ext: '.js'
        }]

    stylus:
      site:
        options:
          compress: isProduction
          linenos: !isProduction
          firebug: !isProduction
          'include css': true
        files:
          'public/application.css': [
            'assets/styles/**/*.styl'
            '!assets/styles/**/_*.styl'
          ]

    jade:
      site:
        files: [{
          expand: yes
          cwd: 'assets'
          src: [ '*.jade', '**/*.jade', '!templates/*' ]
          dest: 'public'
          filter: 'isFile'
          ext: '.html'
        }]
      options:
        pretty: !isProduction

    requirejs:
      site:
        options:
          baseUrl: 'public/config'
          mainConfigFile: 'public/config.js'
          out: 'public/application.js'
          include: [ '../config' ]
          optimize: 'uglify2'
          wrap: yes
          name: '../vendor/almond/almond'
          skipModuleInsertion: no
          generateSourceMaps: yes
          preserveLicenseComments: no

    csslint:
      site:
        options:
          csslintrc: './config/csslintrc.json'
        src: ['public/application.css' ]

    coffeelint:
      options:
        coffeelintrc: './config/coffeelintrc.json'
      site:
        files: [{
          expand: yes
          cwd: 'assets'
          src: [ '*.coffee', '**/*.coffee' ]
          filter: 'isFile'
        }]

    connect:
      site:
        options:
          hostname: '*'
          port: 3000
          base: 'public'

    watch:
      options:
        livereload: yes
        interrupt: yes
        spawn: no
      static:
        tasks: ['copy']
        files: ['assets/*', 'assets/**/*', '!assets/*.{coffee,styl,jade}', '!assets/**/*.{coffee,styl,jade}']
      js:
        tasks: ['_build_js']
        files: ['assets/*.coffee', 'assets/**/*.coffee']
      css:
        tasks: ['_build_css']
        files: ['assets/*.styl', 'assets/**/*.styl']
      html:
        tasks: ['jade']
        files: ['assets/*.jade', 'assets/**/*.jade']

