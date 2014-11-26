var wrap = require('co-level');

function LevelStore(options) {
  options = options || {};
  if(!options.db) {
    throw new Error('Please provide a `db`!');
  }
  this.db = wrap(options.db);
}

LevelStore.prototype.get = function* get(sid) {
  try {
    return yield this.db.get(sid, {
      valueEncoding: 'json'
    });
  } catch(err) {
    if(err.notFound) {
      return null;
    }
    throw err;
  }
};

LevelStore.prototype.set = function* set(sid, sess, ttl) {
  yield this.db.put(sid, sess, {
    valueEncoding: 'json',
    ttl: ttl
  });
};

LevelStore.prototype.destroy = function* destroy(sid) {
  yield this.db.del(sid);
};

module.exports = function(opts) {
  return new LevelStore(opts);
};
