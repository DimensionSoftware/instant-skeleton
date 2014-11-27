
### For flipping on/off features

if typeof env is \undefined
  env = window?locals?env or process.env?NODE_ENV or \production

prod = env is \production
test = env is \test
dev  = env is \dev


module.exports = {
  +advertise        # dimension banner
  +static-assets    # disable to run in a separate process

  offline: prod
  hello-page: !prod # disable in production
}
