
require! {
  immstruct
  omniscient: component
  react: {DOM:{div,button,h1,h2,label,input,code}}:React
}


module.exports = component ({props}) ->
  [key, value] = [\env, props.get-in [\locals \env]]
  on-change    = (e) ->
    t = props.update-in [\locals key], -> e.current-target.value

  div class-name: \HomePage,
    h1 void value
    label void \Greeting: [
      input {key, value, on-change}
    ]
    button {on-click:(-> props.update-in [\locals key], -> \CLICK)}, \Swap
    h2 void 'App State:'
    code void (JSON.stringify props.toJS!)
