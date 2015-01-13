
require! {
  immstruct
  omniscient: component
  react: {DOM:{div,button,h1,h2,label,input,code}}:React
}

#state = immstruct do
#  greeting: 'Hello World!'

HomePage = component ->
  props = @props; cursor = @props.cursor
  key       = \greeting
  value     = cursor.get key
  on-change = (e) -> props.cursor = props.cursor.update key, -> console.log e.current-target.value; e.current-target.value
  #props.cursor = props.cursor.update key, -> \YO2
  guest = @props.cursor.get \guest

  div class-name: \HomePage,
    h1 void (cursor.get key)
    label void \Greeting: [
      input {key, value, on-change}
      div {key:\key} guest.get \name
    ]
    button {on-click:(-> guest.update \name, -> \FOO; cursor.update key, -> \CLICK)}, \Swap
    h2 void 'All Props:'
    code void (JSON.stringify props)


structure  = immstruct {greeting: 'Hello World!', guest: {name:\keith}} #<<< locals.async-state
module.exports.name = \HomePage
module.exports.structure = structure
module.exports.init = (locals) ->
  console.log \+HomePage
  render = -> console.log \render; HomePage(structure.cursor!)
  #structure.on \next-animation-frame render
  structure.on \swap render
  render!
