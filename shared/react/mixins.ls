
require! {
  superagent: request
  immstruct
  immutable
}

export initial-state-async =
  get-initial-state-async: (cb) ->
    request # fetch state
      .get window.location.pathname
      .set \Accept \application/json
      .query window.location.search
      .query { +_surf }
      .end (res) ->
        # update page & local cursor (state)
        window.app.update \locals -> immutable.fromJS res.body.locals
        window.app.update \path   -> res.body.path
        cb void res.body

export focus-edit =
  component-did-update: ->
    e = @getDOMNode!
      ..focus!
      ..set-selection-range e.value.length, e.value.length

export focus-input =
  component-did-mount: ->
    if @refs.focus
      that.getDOMNode!
        ..focus!
        ..select!
