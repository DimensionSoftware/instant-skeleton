
require! react: {DOM}:React

module.exports = React.create-class do
  display-name: \Hello

  render: ->
    DOM.div class-name: \Hello, \YO
