
require! {
  'react-rethinkdb': {r, QueryRequest, DefaultMixin, PropsMixin}
  \react-rethinkdb/dist/QueryResult : {QueryResult}
  superagent: request
  immstruct
  immutable
  \react-dom
}

state = { last-offset: 0px, -initial-load }

# riff'd off @mikemintz's awesome works:
# https://github.com/mikemintz/react-rethinkdb/blob/master/src/Mixin.js
update = (component, props, state) ->
  return unless component.observe # guard
  observed                 = component.observe props, state
  {session, subscriptions} = component._rethink-mixin-state
  subscription-manager     = session._subscription-manager

  # close subscriptions no longer subscribed to
  Object.keys subscriptions .for-each((key) ->
    console.log key
    if !observed[key]
      console.log \unsub: key
      subscriptions[key].unsubscribe!
      delete component.data[key])

  # [re]-subscribe to active queries
  Object.keys observed .for-each((key) ->
    query-request      = observed[key]
    old-subscription   = subscriptions[key]
    query-result       = component.data[key] or (new QueryResult query-request.initial)
    subscriptions[key] = subscription-manager.subscribe component, query-request, query-result
    # TODO update window.app.{locals,session,everyone}
    component.data[key] = query-result
    console.log key, query-result
    if old-subscription
      old-subscription.unsubscribe!)

export rethinkdb =
  component-will-mount: ->
    session = @props[\rethinkSession]

    # guards
    unless session and session._subscription-manager then throw new Error 'Mixin does not have Session'
    unless session._conn-promise then throw new Error 'Must connect() before mounting'

    @_rethink-mixin-state = {session, subscriptions: {}}
    @data = @data or {}
    update @, @props, @state

  component-will-unmount: ->
    console.log \component-will-unmount
    {subscriptions} = @_rethink-mixin-state
    key <- Object.keys subscriptions .for-each
    subscriptions[key].unsubscribe!

  component-will-update: (next-props, next-state) ->
    if next-props !== @props or next-state !== @state
      update @, next-props, next-state

  observe: (props, state) ->
    # TODO fetch all data for session & todos (everyone rights)
    session: new QueryRequest do
      query:   r.table \sessions
      changes: true
#    everyone: new QueryRequest do
#      query:   r.table \everyone
#      changes: true
#      initial: []
    #window.app.update \locals -> immutable.fromJS locals

  component-will-receive-props: ->
    console.log \new-props


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
