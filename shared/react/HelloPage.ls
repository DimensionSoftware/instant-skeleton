
# destructure only what's needed
{NavigatableMixin,Link} = Router
{DOM:{div,h1,h2,code}} = React


# HelloPage
module.exports = component middleware, ({props}) ->
  geo = ->
    if props.get-in <[locals geo]>
      "#{that.get \city}, #{that.get \region} (#{that.get \country})"

  div class-name: \HelloPage,
    h1 void "Hello From #{geo! or \Earth}"
    Link {href:R(\HomePage)}, 'Go to HomePage'
    h2 void 'React App State:'
    code void (JSON.stringify props.toJS!)
