
require! react: {DOM}:React
{div,h1} = DOM

module.exports = React.create-class do
  display-name: \HomePage

  render: ->
    div class-name: \HomePage,
      h1 void, 'Hello World!'
