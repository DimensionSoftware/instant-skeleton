
require! {
  'react-rethinkdb': {r, QueryRequest, DefaultMixin, PropsMixin}
  superagent: request
  immstruct
  immutable
  \react-dom
}

state = { last-offset: 0px, -initial-load }

export rethinkdb =
  observe: (props, state) ->
    console.log \observe-from-reactdb-mixin
    # TODO fetch page locals
    # TODO fetch initial session
    turtles: new QueryRequest do
      query: r.table('turtles') # RethinkDB query
      changes: true             # subscribe to realtime changefeed
      initial: []               # return [] while loading
    #window.app.update \locals -> immutable.fromJS locals
  component-will-receive-props: ->
    console.log \component-will-receive-props

# XXX deprecated-- slated for removal
export initial-state-async =
  get-initial-state-async: (cb) ->
    # TODO better on mobile to use primus websocket for surfing?
    unless state.initial-load then state.initial-load = true; return # guard
    request # fetch state (GET request is cacheable vs. websocket)
      .get window.location.pathname
      .set \Accept \application/json
      .query window.location.search
      .query { +_surf }
      .end (err, res) ->
        return unless res?body?locals # guard
        # update page & local cursor (state)
        window.app.update \locals -> immutable.fromJS res.body.locals
        window.app.update \path   -> res.body.path
        cb void res.body
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
  body = document.get-elements-by-tag-name \body .0 # cache
  offset = window.page-y-offset
  # add relevant scroll classes
  window.toggle-class body, \scrolled (offset > 1px)
  window.toggle-class body, \down     (state.last-offset < offset)
  window.toggle-class body, \up       (state.last-offset > offset)
  window.toggle-class body, \bottom   (window.inner-height + window.scroll-y) >= document.body.offset-height
  state.last-offset := offset
