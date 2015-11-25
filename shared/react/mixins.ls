
require! {
  superagent: request
  immstruct
  immutable
  \react-dom
}

state = { last-offset: 0px, -initial-load }

export initial-state-async =
  component-will-mount: (cb) ->
    # TODO better on mobile to use primus websocket for surfing?
    console.log \will-mount
    unless state.initial-load then state.initial-load = true; return # guard
    request # fetch state (GET request is cacheable vs. websocket)
      .get window.location.pathname
      .set \Accept \application/json
      .query window.location.search
      .query { +_surf }
      .end (err, res) ->
        console.log \surfed!
        return unless res.body and res.body.locals # guard
        # update page & local cursor (state)
        window.app.update \locals -> immutable.fromJS res.body.locals
        window.app.update \path   -> res.body.path
        console.log \body!
        #cb void res.body
        window.scroll-to 0 0 # reset scroll position
        scrolled!
    true

export focus-input =
  component-did-mount: ->
    <~ set-timeout _, 150ms # yield for smoothness
    if @refs.focus
      react-dom.findDOMNode that
        ..focus!
        ..select!

export scroller =
  component-did-mount: ->
    window.add-event-listener \scroll, scrolled, false
  component-will-unmount: ->
    window.remove-event-listener \scroll, scrolled, false

function scrolled
  body   = document.get-elements-by-tag-name \body .0 # cache
  offset = window.page-y-offset
  # add relevant scroll classes
  window.toggle-class body, \scrolled (offset > 1px)
  window.toggle-class body, \down     (state.last-offset < offset)
  window.toggle-class body, \up       (state.last-offset > offset)
  window.toggle-class body, \bottom   (window.inner-height + window.scroll-y) >= document.body.offset-height
  state.last-offset := offset
