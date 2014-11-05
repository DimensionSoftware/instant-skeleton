
require! 'react': {div}:React

module.exports = React.create-class do
  display-name: \Hello

  render: ->
    div class-name: \Hello, \YO
