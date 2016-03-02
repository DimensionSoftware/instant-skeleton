
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
    # TODO better on mobile to use primus websocket for surfing?
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
        window.app.update \path   -> res.body.path
        cb void res.body
        window.scroll-to 0 0 # reset scroll position
        scrolled!
    true


# riff'd off @mikemintz's awesome works:
# https://github.com/mikemintz/react-rethinkdb/blob/master/src/Mixin.js
update = (component, props, state) ->
  return unless component.observe # guard
  observed                 = component.observe props, state
  {session, subscriptions} = component._rethink-mixin-state
  subscription-manager     = session._subscription-manager
  # close subscriptions no longer subscribed to
  Object.keys subscriptions .for-each((key) ->
    if !observed[key]
      console.log \unsub: key
      subscriptions[key].unsubscribe!
      #delete component.data[key]
      #window.app.data.delete key
      #console.log \component: component
  )

  # [re]-subscribe to active queries
  Object.keys observed .for-each((key) ->
    console.log \sub: key
    query-request      = observed[key]
    old-subscription   = subscriptions[key]
    #query-result       = component.data[key] or (new QueryResult query-request.initial)
    query-result = new QueryResult query-request.initial
    subscriptions[key] = subscription-manager.subscribe component, query-request, query-result
    #component.data[key] = query-result
    #window.app.data.update key, query-result
    if old-subscription
      old-subscription.unsubscribe!)


subscriptions = {} # QueryState manager
export rethinkdb =
  component-will-mount: ->
    rs = @props.rethink-session
    # guards
    if rs and !rs._subscription-manager then throw new Error 'Mixin does not have Session'
    unless rs._conn-promise then throw new Error 'Must connect() before mounting'
    # subscribe rethink queries to components
    run-query = rs.run-query.bind rs
    for name, query-request of @observe @props
      console.log \sub: name
      query-result = new QueryResult query-request.initial
      subscriptions[name] = new QueryState(
        query-request,
        run-query,
        query-result,
        on-update = -> # on update
          console.log \update: query-result.value!
        on-close = ->
          console.log \on-close)
      if window? # in browser
        subscriptions[name]
          ..subscribe @, query-result
          ..updateHandler = on-update # XXX why isn't this passed in above?
          ..handle-connect!
  component-will-unmount: ->
    # TODO unsubscribe queries
    #{subscriptions} = @_rethink-mixin-state
    #Object.keys subscriptions .for-each (key) ->
    #  subscriptions[key].unsubscribe!
  observe: ({locals, session, rethink-session}, state) ->
    # TODO fetch all data for session & todos (everyone rights)
    everyone: new QueryRequest do
      query:   r.table \everyone
      changes: true
      initial: []
    #return {} unless session.get \id # guard
    #session: new QueryRequest do
    #  query:   r.table \sessions .get (session.get \id)
    #  changes: true


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
