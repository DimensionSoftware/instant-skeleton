

config = JSON.parse(fs.read-file-sync './config.json') # intentionally crashes if malformed & sync

# localize config.json for env
export config-locals = (next) ->*
  config <<< config[global.ENV] # merge in current env's config
  [@locals[k] = v for k,v of config] # localize
  yield next
