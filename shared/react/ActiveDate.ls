
require! {
  moment
}

ticker = # keep dates up-to-date
  component-did-mount: ->
    @int = set-interval (~> if @is-mounted! then @force-update!), 1000 * 60
  component-did-unmount: ->
    clear-interval @int

# TodoList
module.exports = component \ActiveDate ticker, (props, {title=''}={}) ->
  date = props.deref!
  [calendar, from-now] =
    [moment(date, \x).calendar!,
     moment(date, \x).from-now!]

  DOM.span {title:calendar} "#title #from-now"
