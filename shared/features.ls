
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
  +todo-example     # disable to remove TODO app routes & logic
  +dimension        # dimension banners
  +static-assets    # disable to run in a separate process
  offline: false    # disable offline unless necessary (prevent glorious caching)

  unsafely-allow-any-query: dev # when true, whitelist is used
}
