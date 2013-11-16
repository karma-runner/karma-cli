# JS Hint options
JSHINT_BROWSER =
  browser: true,
  es5: true,
  strict: false
  undef: false
  camelcase: false

JSHINT_NODE =
  node: true,
  es5: true,
  strict: false

module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    pkgFile: 'package.json'

    files:
      bin: ['bin/*']

    # JSHint options
    # http://www.jshint.com/options/
    jshint:
      bin:
        files:
          src: '<%= files.bin %>'
        options: JSHINT_NODE

      options:
        quotmark: 'single'
        bitwise: true
        indent: 2
        camelcase: true
        strict: true
        trailing: true
        curly: true
        eqeqeq: true
        immed: true
        latedef: true
        newcap: true
        noempty: true
        unused: true
        noarg: true
        sub: true
        undef: true
        maxdepth: 4
        maxlen: 100
        globals: {}

    # CoffeeLint options
    # http://www.coffeelint.org/#options
    coffeelint:
      grunt: files: src: ['Gruntfile.coffee']
      options:
        max_line_length:
          value: 100

    'npm-publish':
      options:
        abortIfDirty: true

    'npm-contributors':
      options:
        commitMessage: 'chore: update contributors'

    bump:
      options:
        updateConfigs: ['pkg']
        commitFiles: ['package.json', 'CHANGELOG.md']
        commitMessage: 'chore: release v%VERSION%'
        pushTo: 'upstream'


  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-bump'
  grunt.loadNpmTasks 'grunt-npm'
  grunt.loadNpmTasks 'grunt-auto-release'
  grunt.loadNpmTasks 'grunt-conventional-changelog'

  grunt.registerTask 'default', ['lint']
  grunt.registerTask 'lint', ['jshint', 'coffeelint']
  grunt.registerTask 'release', 'Build, bump and publish to NPM.', (type) ->
    grunt.task.run [
      'npm-contributors'
      "bump:#{type||'patch'}:bump-only"
      'changelog'
      'bump-commit'
      'npm-publish'
    ]
