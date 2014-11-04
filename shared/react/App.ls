
require! {
  '../routes'
}

require! {
  react: {DOM}:React
  'react-router': {Route,Link}:Router
}


module.exports = React.create-class {
  display-name: \App

  render: ->
    DOM.div void 'Hello from React!'
}
