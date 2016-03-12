
require! {
  superagent: request
  'react-rethinkdb': {r, QueryRequest}
  \react-rethinkdb/dist/QueryState  : {QueryState}
  \react-rethinkdb/dist/QueryResult : {QueryResult}
  immstruct
  immutable
  \react-dom
}

state = { last-offset: 0px, last-path: void }

# fetch page locals from koa
export initial-state-async =
  get-initial-state-async: (cb) ->
    path = window.location.pathname
    return if state.last-path is path # guard
    window.app = window.app.update \path -> immutable.fromJS path
    request # fetch state (GET request is cacheable vs. websocket)
      .get path
      .set \Accept \application/json
      .query window.location.search
      .query { +_surf }
      .end (err, res) ->
        return unless res?body?locals # guard
        # update page & local cursor
        window.app = window.app.update \locals -> immutable.fromJS res.body.locals
        cb void res.body
        window.scroll-to 0 0 # reset scroll position
        scrolled!
        state.last-path = path
    true

subscriptions = {} # QueryState manager
export rethinkdb =
  component-will-mount: ->
    # init rethink & guards
    rs = @props.RethinkSession
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
        query-state  = new QueryState(query-request, run-query, query-result)
        if window? # in browser
          subscriptions[name] = query-state.subscribe @, query-result .unsubscribe # save unsubscribe
          query-state
            ..updateHandler = ->
              v   = query-result.value!
              val = if typeof! v is \Array then v.0 else v   # unbox
              return if val === (window.app.get name .toJS!) # guard
              if storage? then storage.set name, val         # store locally
              window.app = window.app.update name, -> immutable.fromJS val
            ..handle-connect!
  observe: ({locals, session, RethinkSession}, state) ->
    # fetch all data for session & todos (everyone rights)
    everyone: new QueryRequest do
      query:   r.table \everyone
      changes: true
      initial: if storage? then storage.get \everyone
    if id = session.get \id # fetch session, too
      session: new QueryRequest do
        query:   r.table \sessions .get id
        changes: true
        initial: if storage? then storage.get \session

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
