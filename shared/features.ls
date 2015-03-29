
### For flipping on/off features

env =
  if typeof window isnt \undefined
    window.locals?env # client
  else
    process.env?NODE_ENV


prod = env is \production
test = env is \test
dev  = env is \development


module.exports = {
  +todo-example
  +dimension        # dimension banners
  +static-assets    # disable to run in a separate process

  offline: prod     # enable in production
}
