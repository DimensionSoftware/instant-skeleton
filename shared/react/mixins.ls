
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
      .end (err, res) ->
        return unless res.body and res.body.locals # guard
        # update page & local cursor (state)
        window.app.update \locals -> immutable.fromJS res.body.locals
        window.app.update \path   -> res.body.path
        cb void res.body
        window.scroll-to 0 0 # reset scroll position
        scrolled!

export focus-input =
  component-did-mount: ->
    <~ set-timeout _, 150ms # yield for smoothness
    if @refs.focus
      that.getDOMNode!
        ..focus!
        ..select!

export scroll =
  component-did-mount: ->
    window.add-event-listener \scroll, scrolled, false
  component-will-unmount: ->
    window.remove-event-listener \scroll, scrolled, false

state = { last-offset: 0px }
function scrolled
  body   = document.get-elements-by-tag-name \body .0 # cache
  offset = window.page-y-offset
  window.toggle-class body, \scrolled (offset > 1px)
  window.toggle-class body, \down     (state.last-offset < offset)
  window.toggle-class body, \up       (state.last-offset > offset)
  state.last-offset := offset
