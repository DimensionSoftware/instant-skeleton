var feathers = require('feathers');
var passport = require('passport');
var crypto = require('crypto');
var hooks = require('feathers-hooks');
var memory = require('feathers-memory');
var bodyParser = require('body-parser');
var session = require('express-session');
var feathersPassport = require('../lib/passport');
var LocalStrategy = require('passport-local').Strategy;

// SHA1 hashes a string
var sha1 = function(string) {
  var shasum = crypto.createHash('sha1');
  shasum.update(string);
  return shasum.digest('hex');
};

// A shared session store must be provided.
// This MemoryStore is not recommended for production
var store = new session.MemoryStore();

// Initialize the application
var app = feathers()
  .configure(feathers.rest())
  .configure(feathers.socketio())
  .configure(hooks())
  // Needed for parsing bodies (login)
  .use(bodyParser.urlencoded({ extended: true }))
  // Configure feathers-passport
  .configure(feathersPassport({
    // Secret must be provided
    secret: 'feathers-rocks',
    // Also set a store
    store: store
  }))
  // Initialize a user service
  .use('/users', memory())
  // A simple Todos service that we can use for testing
  .use('/todos', {
    get: function(id, params, callback) {
      callback(null, {
        id: id,
        text: 'You have to do ' + id + '!',
        user: params.user
      });
    }
  })
  // Add a login route for the passport login
  .post('/login', passport.authenticate('local', {
      successRedirect: '/',
      failureRedirect: '/login.html',
      failureFlash: false
  }))
  // Host this folder
  .use('/', feathers.static(__dirname));

var userService = app.service('users');

// Add a hook to the user service that automatically hashes the
// password before saving it
userService.before({
  create: function(hook, next) {
    var password = hook.data.password;
    // Replace the data with the SHA1 hashed password
    hook.data.password = sha1(password);
    next();
  }
});

// Use the id to serialize the user
passport.serializeUser(function(user, done) {
  done(null, user.id);
});

// Deserialize the user retrieving it form the user service
passport.deserializeUser(function(id, done) {
  // Get the user service and then retrieve the user id
  userService.get(id, {}, done);
});

// Attach the local strategy
passport.use(new LocalStrategy(function(username, password, done) {
    var query = {
      username: username
    };

    userService.find({ query: query }, function(error, users) {
      if(error) {
        return done(error);
      }

      var user = users[0];

      if(!user) {
        return done(new Error('User not found'));
      }

      // Compare the hashed password
      if(user.password !== sha1(password)) {
        return done(new Error('Password not valid'));
      }

      done(null, user);
    });
  }
));

// Create a user that we can use to log in
userService.create({
  username: 'feathers',
  password: 'secret'
}, {}, function(error, user) {
  console.log('Created default user', user);
});

app.listen(4000);
