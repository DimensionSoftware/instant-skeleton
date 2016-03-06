
require! {
  superagent: request
  'react-rethinkdb': {r, QueryRequest}
  \react-rethinkdb/dist/QueryState  : {QueryState}
  \react-rethinkdb/dist/QueryResult : {QueryResult}
  immstruct
  immutable
  \react-dom
}

state = { last-offset: 0px, -initial-load }

# fetch page locals from koa
export initial-state-async =
  get-initial-state-async: (cb) ->
    unless state.initial-load then state.initial-load = true; return # guard
    request # fetch state (GET request is cacheable vs. websocket)
      .get window.location.pathname
      .set \Accept \application/json
      .query window.location.search
      .query { +_surf }
      .end (err, res) ->
        return unless res?body?locals # guard
        # update page & local cursor
        window.app.update \locals -> immutable.fromJS res.body.locals
        window.app.update \path   -> immutable.fromJS res.body.path
        cb void res.body
        window.scroll-to 0 0 # reset scroll position
        scrolled!
        state.initial-load = false
    true

subscriptions = {} # QueryState manager
export rethinkdb =
  component-will-mount: ->
    rs = @props.RethinkSession
    # guards
    if rs and !rs._subscription-manager then throw new Error 'Mixin does not have Session'
    unless rs._conn-promise then throw new Error 'Must connect() before mounting'

    # only unsubscribe non-reuse queries
    self = @
    for let name, unsubscribe of subscriptions
      unless (self.observe self.props)[name]
        console.log \-sub: name, unsubscribe
        unsubscribe!
        delete subscriptions[name]

    # subscribe rethink queries to components
    run-query = rs.run-query.bind rs
    for let name, query-request of @observe @props
      unless subscriptions[name] # guard
        console.log \+sub: name
        query-result = new QueryResult query-request.initial
        qs = new QueryState(
          query-request,
          run-query,
          query-result,
          on-update = -> # on update
            v = query-result.value!
            window.app.update name, -> immutable.fromJS if typeof! v is \Array then v.0 else v # unbox
          on-close = ->) # TODO
        if window? # in browser
          subscriptions[name] = qs.subscribe @, query-result .unsubscribe # save unsubscribe
          qs
            ..updateHandler = on-update # XXX why isn't this passed in above?
            ..handle-connect!
  observe: ({locals, session, RethinkSession}, state) ->
    # fetch all data for session & todos (everyone rights)
    everyone: new QueryRequest do
      query:   r.table \everyone
      changes: true
      initial: []
    session: new QueryRequest do
      query:   r.table \sessions .get (session.get \id)
      changes: true

export focus-input =
  component-did-mount: ->
    <~ set-timeout _, 100ms # yield for smoothness
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
