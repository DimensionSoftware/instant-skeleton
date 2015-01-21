
require! {
  omniscient: component
  react: {DOM:{div,button,h1,h2,label,input,code}}:React
  'react-router-component': {NavigatableMixin,Link}:ReactRouter
  'react-async': {Mixin}
  '../routes': {r}
  \./mixins
}


module.exports = component [Mixin, mixins.InitialStateAsync, NavigatableMixin], ({props}) ->
  key       = \greeting
  update    = (val) -> props.update-in [\locals, key], -> val
  value     = props.get-in [\locals key]
  on-change = (e) ->
    update e.current-target.value

  div class-name: \HomePage,
    h1 void value
    label void \Greeting: [
      input {key, value, on-change}
    ]
    button {on-click:(-> update \CLICK)}, \Swap
    div void
      Link {href:r(\HelloPage)}, 'Go to HelloPage'
    h2 void 'React App State:'
    code void (JSON.stringify props.toJS!)
