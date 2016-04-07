
require! {
  superagent: request
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
    unless state.last-path or state.last-path is path # guard
      state.last-path := path
      return
    window.app.update \path -> immutable.fromJS path
    request # fetch state (GET request is cacheable vs. websocket)
      .get path
      .set \Accept \application/json
      .query window.location.search
      .query { +_surf }
      .end (err, res) ->
        return unless res?body?locals # guard
        # update page & local cursor
        window.app.update \locals -> immutable.fromJS res.body.locals
        cb void res.body
        window.scroll-to 0 0 # reset scroll position
        scrolled!
        state.last-path := path
    true

subscriptions = {} # QueryState manager
export rethinkdb =
  component-will-mount: ->
    # init rethink & guards
    rs = @props.RethinkSession
    if rs and !rs._subscription-manager then throw new Error 'Mixin does not have Session'
    unless rs._conn-promise then throw new Error 'Must connect() before mounting'
    @_rethink-mixin-state = {} # XXX fix for react-rethinkdb (not used)
    observing = (@default-observe @props) <<< if @observe then @observe @props else {}
    self = @
    # unsubscribe queries no-longer needed
    for let name, unsubscribe of subscriptions
      unless observing[name]
        console?log \-sub: name
        unsubscribe!
    # subscribe rethink queries to components
    run-query = rs.run-query.bind rs
    for let name, request of observing
      unless subscriptions[name] # guard
        console?log \+sub: name
        result = new QueryResult request.initial
        state  = new QueryState request, run-query, result, -> delete subscriptions[name]
        if window? # in browser
          subscriptions[name] = state.subscribe @, result .unsubscribe # save unsubscribe
          state
            ..update-handler = ->
              exists = window.app.get name
              [cur, prev] =
                result.value!
                if exists then window.app.get name .toJS! else {}
              # guards
              return unless cur
              return if cur === prev
              return if window.token and cur.token is window.token
              return if cur.updated and cur.updated <= prev.updated
              if storage? then storage.set name, cur # store locally
              window.app.update name, -> immutable.fromJS cur
            ..handle-connect!
  default-observe: ({locals, session, RethinkSession}, state) ->
    # fetch all data for session & todos (everyone rights)
    everyone: new QueryRequest do
      query:   r.table \everyone .order-by index: r.desc \date
      changes: true
      initial: if storage? then storage.get \everyone
    session: new QueryRequest do
      query:   r.table \sessions .get <| session.get \id
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
