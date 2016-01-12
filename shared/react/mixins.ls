
require! {
  superagent: request
  immstruct
  immutable
  \react-dom
}

state = { last-offset: 0px, -initial-load }

# XXX based on https://github.com/mikemintz/react-rethinkdb/blob/master/src/Mixin.js
update = (component, props, state) ->
  [observed, {session, subscriptions}] = [
    component.observe props, state
    component._rethink-mixin-state ]
  subscription-manager = session._subscription-manager

  # close subscriptions no longer subscribed to
  Object.keys subscriptions .for-each (key) ->
    if not observed[key]
      subscriptions[key].unsubscribe!
      delete component.data[key]

  # [re]-subscribe to active queries
  Object.keys observed .for-each (key) ->
    [old-subscription, query-request] = [
      subscriptions[key]
      observed[key]]
    subscriptions[key]  = subscription-manager.subscribe component, query-request, query-result
    component.data[key] = query-result
    if old-subscription then old-subscription.unsubscribe!

unmount = (component) ->
  {subscriptions} = component._rethink-mixin-state
  Object.keys subscriptions .for-each (key) ->
    subscriptions[key].unsubscribe!

export rethinkdb =
  component-did-mount: ->
    console.log \mount
    # TODO update path
    # TODO update locals over socket
    [session, subscriptions] = [{}, {}]
    @_rethink-mixin-state = {session, subscriptions}
    update @, @props, @state

    window.scroll-to 0 0 # reset scroll position
    scrolled!
  component-will-unmount: ->
    unmount @
    console.log \unmount
  component-will-update: (next-props, next-state) ->
    console.log \will-update
    if next-props !== @props or next-state !== @state
      update @, next-props, next-state

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
