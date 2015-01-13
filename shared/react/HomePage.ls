
require! {
  immstruct
  omniscient: component
  react: {DOM:{div,button,h1,h2,label,input,code}}:React
}

#state = immstruct do
#  greeting: 'Hello World!'

HomePage = component ({cursor}:props) ->
  key       = \greeting
  value     = cursor.get key
  on-change = (e) -> props.cursor = props.cursor.update key, -> console.log e.current-target.value; e.current-target.value
  #props.cursor = props.cursor.update key, -> \YO2

  div class-name: \HomePage,
    h1 void (cursor.get key)
    label void \Greeting: [
      input {key, value, on-change}
    ]
    button {on-click:(-> props.cursor = cursor.update key, -> \CLICK)}, \Swap
    h2 void 'All Props:'
    code void (JSON.stringify props)


module.exports = (locals) ->
  state  = immstruct {greeting: 'Hello World!'} <<< locals.async-state
  cursor = state.cursor!
  console.log \+HomePage
  render = -> console.log \render; HomePage cursor
  state.on \next-animation-frame render
  render!
