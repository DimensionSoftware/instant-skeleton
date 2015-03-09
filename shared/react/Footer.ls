
# destructure only what's needed
{img,a,div,footer,h3,code} = DOM

require! \./Navigation

# Footer
module.exports = component \Footer ({path, last-page}:props) ->
  footer void [
    a {href:'https://dimensionsoftware.com', target:'_blank'} [
      img {src:'https://dimensionsoftware.com/images/software_by.png'}
    ]
    Navigation {path, last-page} # sync'd across sessions
  ]
