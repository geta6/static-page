'use strict'

util = require 'util'
coffeelint = require 'coffeelint'
{reporter} = require 'coffeelint-stylish'

module.exports = (grunt) ->

  (require 'jit-grunt')(grunt)

  process.env.NODE_ENV = if 'build' in grunt.cli.tasks then 'production' else 'development'

  grunt.registerMultiTask 'coffeelint', 'CoffeeLint', ->
    count = e: 0, w: 0
    options = @options()
    if options.coffeelintrc?
      util._extend options, require options.coffeelintrc
    (files = @filesSrc).forEach (file) ->
      grunt.verbose.writeln "Linting #{file}..."
      errors = coffeelint.lint (grunt.file.read file), options
      unless errors.length
        return grunt.verbose.ok()
      reporter file, errors
      errors.forEach (err) ->
        switch err.level
          when 'error' then count.e++
          when 'warn'  then count.w++
          else return
        message = "#{file}:#{err.lineNumber} #{err.message} (#{err.rule})"
        grunt.event.emit "coffeelint:#{err.level}", err.level, message
        grunt.event.emit 'coffeelint:any', err.level, message
    return no if count.e and !options.force
    if !count.w and !count.e
      s = if 1 < files.length then 's' else ''
      grunt.log.ok "#{files.length} file#{s} lint free."

  grunt.registerTask '_build_js', [
    'coffee', 'coffeelint'
  ]

  grunt.registerTask '_build_css', [
    'stylus', 'cssmin', 'csslint'
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

  grunt.loadNpmTasks 'grunt-notify'

  grunt.initConfig
    clean:
      site: ['public']

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
          compress: yes
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

    cssmin:
      options:
        separator: ''
      common:
        src: [
          'vendor/bower/bootstrap/dist/css/bootstrap.css'
          'public/application.css'
        ]
        dest: 'public/application.css'

    requirejs:
      site:
        options:
          baseUrl: 'public/config'
          mainConfigFile: 'public/config.js'
          out: 'public/application.js'
          include: [ '../config' ]
          optimize: 'uglify2'
          wrap: yes
          name: '../vendor/almond'
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

