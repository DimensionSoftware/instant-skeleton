# feathers-cluster [![Build Status](https://travis-ci.org/Glavin001/feathers-cluster.png?branch=master)](https://travis-ci.org/Glavin001/feathers-cluster)

> Easily take advantage of multi-core systems for Featherjs.

## Getting Started

To install feathers-cluster from [npm](https://www.npmjs.org/), run:

```bash
$ npm install feathers-cluster --save
```

Finally, to use the plugin in your Feathers app:

```javascript
// Require
var feathers = require('feathers');
var cluster = require('feathers-cluster');
// Get a Feathers server
var app = feathers();
// ...

// ===== Usage =====
// app.configure(cluster());
app.configure(cluster({
    // Customize
    cores: 4, // Optional: Force number of cores, defaults to number of CPUs.
    // Customize the Cluster
    cluster: function(cluster) {
        // See http://nodejs.org/api/cluster.html
        cluster.on('fork', function (worker) {
            console.log('forked worker ' + worker.process.pid);
        });
        cluster.on('listening', function(worker, address) {
            console.log('worker ' + worker.process.pid + ' is now connected to ' + address.address + ':' + address.port);
        });
        cluster.on('exit', function(worker, code, signal) {
            console.log('worker ' + worker.process.pid + ' died');
        });
    },
    // Important: Do NOT configure Socket.io yourself, 
    // instead put your Socket.io configuration in the function below.
    socketio: function(io) {
        // Example Socket.io configuration
        io.enable('browser client minification');  // send minified client
        io.enable('browser client etag');          // apply etag caching logic based on version number
        io.enable('browser client gzip');          // gzip the file
        io.set('log level', 1);                    // reduce logging
    }
}));

// ....

```

## Documentation

See the [docs](docs/).

## Author

- [Glavin Wiechert](https://github.com/Glavin001)

## License

Copyright (c) 2014 Glavin Wiechert

Licensed under the [MIT license](LICENSE).
