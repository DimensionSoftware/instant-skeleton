
require! {
  omniscient: component
  react: {DOM:{div,h1,h2,code}}:React
  'react-router-component': {NavigatableMixin,Link}:ReactRouter
  'react-async': {Mixin}
  '../routes': {r}
  \./mixins
}


module.exports = component [Mixin, mixins.InitialStateAsync, NavigatableMixin], ({props}) ->
  geo = ->
    if props.get-in <[locals geo]>
      "#{that.get \city}, #{that.get \region} (#{that.get \country})"

  div class-name: \HelloPage,
    h1 void "Hello From #{geo! or \Earth}"
    Link {href:r(\HomePage)}, 'Go to HomePage'
    h2 void 'React App State:'
    code void (JSON.stringify props.toJS!)
