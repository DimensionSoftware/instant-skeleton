'use strict';

module.exports = function (grunt) {

    // Project configuration.
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        release: {},
        jshint: {
            options: {
                jshintrc: '.jshintrc'
            },
            lib: ['lib/**/*.js', 'Gruntfile.js'],
            test: 'test/**/*.js'
        },
        simplemocha: {
            all: {
                src: ['test/**/*.test.js']
            }
        },
        watch: {
            scripts: {
                files: '**/*.js',
                tasks: ['jshint', 'simplemocha', 'express:dev'],
                options: {
                    spawn: false
                }
            }
        },
        express: {
            options: {
                // Override defaults here
            },
            dev: {
                options: {
                    script: 'example/server.js'
                }
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-release');
    grunt.loadNpmTasks('grunt-simple-mocha');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-express-server');

    grunt.registerTask('test', 'simplemocha');
    grunt.registerTask('default', ['jshint', 'simplemocha', 'express:dev', 'watch']);

};