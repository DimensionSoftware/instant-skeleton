# Feathers Passport

[![Build Status](https://travis-ci.org/feathersjs/feathers-passport.png?branch=master)](https://travis-ci.org/feathersjs/feathers-passport)

feathers-passport adds shared [PassportJS](http://passportjs.org/) authentication for Feathers HTTP REST and websockets services.

## Options

feathers-passport will configure the cookieparser, session and Passport middleware for you.
The following options are available:

- __secret__ *required* - The session secret
- __store__ *require* - A session store to use. Must be provided. `new require('express-session').MemoryStore();` is an option but is not recommended for production.
- __name__ (default: `connect.sid`) - The session name (previous `key`)
- __cookieParser__ (default: `require('cookie-parser')`) - The cookie parser middleware to use
- __passport__ (default: `require('passport')`) - The passport module
- __createSession__ (default: `require('express-session')`) - A function that can be called with the options and returns the actual session middleware

You can also pass a function that gets the default values so that you can use them for returning a new configuration. This can be useful to e.g. configure the [connect-mongo](https://github.com/kcbanner/connect-mongo) session store:

```js
var passport = require('passport');
var connectMongo = require('connect-mongo');
var feathersPassport = require('feathers-passport');

var app = feathers();

app.configure(feathers.rest())
  .configure(feathers.socketio())
  .configure(feathersPassport(function(defaults) {
    // MongoStore needs the session function
    var MongoStore = connectMongo(defaults.createSession);
    return {
      secret: 'feathers-rocks'
      store: new MongoStore({
        db: 'feathers-demo'
      })
    };
  });
```

## Example

The following shows a commented example for an application using local authentication with a Feathers user service:

```js
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
```

Add a `login.html` with an HTML form that allows to log our user in:

```html
<!DOCTYPE html>
<html>
<head lang="en">
  <meta charset="UTF-8">
  <title></title>
</head>
<body>
  <form action="/login" method="post">
    <div>
      <label>Username:</label>
      <input type="text" name="username"/>
    </div>
    <div>
      <label>Password:</label>
      <input type="password" name="password"/>
    </div>
    <div>
      <input type="submit" value="Log In"/>
    </div>
  </form>
</body>
</html>
```

## Changelog

__0.1.0__

- Initial release

## Author

- [David Luecke](https://github.com/daffl)

## License

Copyright (c) 2014 David Luecke

Licensed under the [MIT license](LICENSE).
