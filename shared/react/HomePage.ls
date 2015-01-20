
require! {
  immstruct
  omniscient: component
  react: {DOM:{div,button,h1,h2,label,input,code}}:React
}


module.exports = component ({async-state}:props) ->
  [key, value] = [\env, async-state.get-in [\locals \env]]
  on-change    = (e) ->
    t = async-state.update-in [\locals key], -> e.current-target.value

  div class-name: \HomePage,
    h1 void value
    label void \Greeting: [
      input {key, value, on-change}
    ]
    button {on-click:(-> async-state.update-in [\locals key], -> \CLICK)}, \Swap
    h2 void 'All Props:'
    code void (JSON.stringify async-state.toJS!)
