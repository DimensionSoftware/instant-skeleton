/*
 * feathers-cluster
 *
 * Copyright (c) 2014 Glavin Wiechert
 * Licensed under the MIT license.
 */

'use strict';

// Dependencies
var feathers = require('feathers');
var cluster = require('cluster');

var numCPUs = require('os').cpus().length;
var RedisStore = require('socket.io/lib/stores/redis');
var redis = require('socket.io/node_modules/redis');
var pub = redis.createClient();
var sub = redis.createClient();
var client = redis.createClient();

module.exports = function(config) {
    return function() {
        var app = this;
        //var services = {};

        // Prep config
        config = config || {};

        //
        var cores = config.cores || numCPUs;

        // Enable the cluster plugin
        app.enable('feathers cluster');

        // === Using Decorator pattern ===
        // Store original function
        var listen = app.listen;
        // Replace function with newly decorated function
        app.listen = function() {
            //
            
            if (cluster.isMaster)
            {
                // Master
                console.log('New Master Node');

                var i = 0;
                while (i < cores) {
                    console.log('Forking node '+i);
                    cluster.fork();
                    i++;
                }

                // Check for configuration
                if (typeof config.cluster === 'function')
                {
                    config.cluster.apply(this, [cluster]);
                }

            }
            else
            {
                // Not Master
                console.log('New Worker Node');
                
                // Check for Socket.io
                //if (!this.disabled('feathers socketio')) {
                if (config.socketio)
                {
                    // Socket.io Enabled
                    console.log('Socket.io Enabled');

                    app.configure(feathers.socketio(function(io) {

                        //io = require("socket.io").listen(server)
                        io.set('store', new RedisStore(
                        {
                            redisPub: pub,
                            redisSub: sub,
                            redisClient: client
                        }
                        ));

                        // Check config for Socket.io configure
                        if (typeof config.socketio === 'function')
                        {
                            config.socketio.apply(this, [io]);
                        }

                    }));

                }

                // Call the old listen
                listen.apply(app, arguments);

            }

        };

        /*
        // Optional: Register this plugin as a Feathers provider
        app.providers.push(function(path, service) {
            //console.log('Added service', path, service);
            services[path] = service;
        });
        */

    };
};
