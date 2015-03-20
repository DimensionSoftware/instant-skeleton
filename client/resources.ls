

module.exports = (primus) ->

  # example "foo" resource
  foo = primus.resource \foo
    ..on \ready ->
      foo.command \test (res) ->
        console?log \test-resource: res
