
require! {
  './Footer'
}

# destructure only what's needed
{NavigatableMixin,Link} = Router
{DOM:{div,h1,h4,footer,strong,code}} = React


# HelloPage
module.exports = component middleware, ({props}) ->
  geo = ->
    if props.get-in <[locals geo]>
      "#{that.get \city}, #{that.get \region} (#{that.get \country})"

  div class-name: \HelloPage,
    h1 void "Hello From #{geo! or \Earth}"
    div void 'Last visited ' [
      strong void "#{props.get-in [\session, \lastPage] or ''}"
    ]
    Link {href:R(\HomePage)}, 'HomePage →'

    Footer {props}
