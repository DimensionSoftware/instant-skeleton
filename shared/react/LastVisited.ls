

# destructure only what's needed
{DOM:{div,small}} = React


# Footer
module.exports = component common-mixins, ({props}) ->
  # render last visited page (sync'd across all sessions)
  div void [ small void "Last visited #{props.get-in [\session, \lastPage]}" ]
