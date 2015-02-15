
require! {
  chai: {expect}
  sinon
  supertest: request
  \../build/server/App
}

app    = new App(process.env.npm_package_config_node_port-1)
server = void


# TODO better coverage
describe 'Can we boot the app?' ->
  before (done) ->
    app.start ->
      server := app.server # set app instance
      done!

  describe 'Can we fetch an index page?' ->
    specify 'fetches' (done) ->
      request server
        .get '/'
        .expect 200 done
