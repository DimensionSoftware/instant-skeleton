
# destructure only what's needed
{img,a,div,footer,h3,code} = DOM

require! \./Navigation

# Footer
module.exports = component \Footer ({name, path, last-page}:props) ->
  footer void [
    Navigation {name, path, last-page} # sync'd across sessions
    a {href:'https://dimensionsoftware.com', target:'_blank'} [
      img {src:'https://dimensionsoftware.com/images/software_by.png'}
    ]
  ]
