
# destructure only what's needed
{DOM:{footer,h4,code}} = React
{NavigatableMixin,Link} = Router


# Footer
module.exports = component common-mixins, ({props}) ->
  footer void [
    # print entire app structure
    h4 void 'React App State'
    code void (JSON.stringify props.toJS!)
  ]
