

var manifest = require('../')

var test = require('tape')
var inspect = require('util').inspect

test("merge, but don't mutate", function (t) {

  var error = {type: 'error', message: 'read-only'}

  var db = {
    methods: {
      put              : error,
      del              : error,
      batch            : error,
      writeStream      : error,
      createWriteStream: error
    }
  }
  var _db = JSON.parse(JSON.stringify(db))

  var m = manifest(db)

  t.notDeepEqual(m, _db)

  t.deepEqual(m.methods.put              , error)
  t.deepEqual(m.methods.del              , error)
  t.deepEqual(m.methods.batch            , error)
  t.deepEqual(m.methods.createWriteStream, error)
  t.deepEqual(m.methods.writeStream      , error)

  t.deepEqual(db, _db) //check that manifest did not mutate

  t.end()
})

test('recursive', function (t) {

  var error = {type: 'error', message: 'read-only'}

  var readOnly = {
        put              : error,
        del              : error,
        batch            : error,
        writeStream      : error,
        createWriteStream: error
      }

  var db = {
    methods: readOnly,
    sublevels: {
      foo: {methods: {}},
      bar: {methods: readOnly}
    }
  }

  var m = manifest(db)

  t.ok(m.sublevels.foo)
  t.ok(m.sublevels.bar)

  console.log(inspect(m, false, 10))

  t.end()
})

test('terse: blank defaults', function (t) {

  var error = {type: 'error', message: 'read-only'}

  var readOnly = {
        put              : error,
        del              : error,
        batch            : error,
        writeStream      : error,
        createWriteStream: error
      }

  var db = {
    methods: readOnly,
    sublevels: {
      foo: {},
      bar: {methods: readOnly}
    }
  }

  var m = manifest(db, true)

  console.log(inspect(m, false, 10))

  t.deepEqual(m, JSON.parse(JSON.stringify(db)))
  t.end()
})

test('blank defaults', function (t) {

  var error = {type: 'error', message: 'read-only'}

  var readOnly = {
        put              : error,
        del              : error,
        batch            : error,
        writeStream      : error,
        createWriteStream: error
      }

  var db = {
    methods: readOnly,
    sublevels: {
      foo: {},
      bar: {methods: readOnly}
    }
  }

  var m = manifest(db, true)

  t.deepEqual(m, JSON.parse(JSON.stringify(db)))
  t.end()
})

test('sets methods', function (t) {
  var m = manifest({})
  t.ok(m.methods)
  t.end()

})

test('nested objects', function (t) {

  var error = {type: 'error', message: 'read-only'}
  var nested = {type: 'object', methods: {get: error}}

  var readOnly = {
        put              : error,
        del              : error,
        batch            : error,
        writeStream      : error,
        createWriteStream: error,
        nested           : nested
      }

  var db = {
    methods: readOnly,
    sublevels: {foo: {methods: readOnly}}
  }

  var m = manifest(db)

  t.deepEqual(m.methods.nested, nested)
  t.deepEqual(m.sublevels.foo.methods.nested, nested)

  console.log(inspect(m, false, 10))

  t.end()
})
