
require! react: {DOM}:React

module.exports = React.create-class do
  display-name: \HomePage

  render: ->
    DOM.div class-name: \HomePage, 'Hello World!'
