
# destructure only what's needed
{img,a,div,footer,h3,code} = DOM

require! \./Nav

# Footer
module.exports = component \Footer ({name, path}) ->
  footer do
    class-name: \footer

    Nav {name, path} # sync'd across sessions
