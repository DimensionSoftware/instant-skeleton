

# destructure only what's needed
{DOM:{div,small}} = React


# Footer
module.exports = component middleware, ({props}) ->
  div void [ small void "Last visited #{props.get-in [\session, \lastPage]}" ]
