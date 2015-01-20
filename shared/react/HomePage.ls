
require! {
  immstruct
  omniscient: component
  react: {DOM:{div,button,h1,h2,label,input,code}}:React
}


module.exports = component ({props}) ->
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
    h2 void 'React App State:'
    code void (JSON.stringify props.toJS!)
