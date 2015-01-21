
require! {
  omniscient: component
  react: {DOM:{div,h1,h2,code}}:React
  'react-router-component': {NavigatableMixin,Link}:ReactRouter
  'react-async': {Mixin}
  '../routes': {r}
  \./mixins
}


module.exports = component [Mixin, mixins.InitialStateAsync, NavigatableMixin], ({props}) ->
  div class-name: \HelloPage,
    h1 void "Hello From #{(props.get-in [\locals \geo]) or \Earth}"
    Link {href:r(\HomePage)}, 'Go to HomePage'
    h2 void 'React App State:'
    code void (JSON.stringify props.toJS!)
