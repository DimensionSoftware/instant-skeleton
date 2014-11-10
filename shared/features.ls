
### For flipping on/off features

if typeof env is \undefined
  env = process?env.NODE_ENV or \production # safe default

prod = env is \production
test = env is \test
dev  = env is \dev


module.exports =
  offline: prod

  hello-page: !prod # disable in production
