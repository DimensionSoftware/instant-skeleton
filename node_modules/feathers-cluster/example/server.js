var feathers = require('feathers');
var cluster = require('../lib');
 
var todoService = {
  todos: [],
  
  // Return all todos from this service
  find: function(params, callback) {
    // Simulate long API request
    var data = this.todos;
    setTimeout(function() {
        callback(null, data);
    }, 10);
  },
  
  // Create a new Todo with the given data
  create: function(data, params, callback) {
    data.id = this.todos.length;
    this.todos.push(data);
    
    callback(null, data);
  }
};
 
var app = feathers();
app.configure(cluster({
    //cores: 1, // Force single core for testing
    cluster: function(cluster) {
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
    socketio: function(io) {
        
    }
}));

app//.configure(feathers.socketio())
    .use('/todos', todoService)
    .listen(8000);

module.exports = app;