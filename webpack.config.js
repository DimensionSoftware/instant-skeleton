
var nib         = require('nib')
  , path        = require('path')
  , webpack     = require('webpack')
  , ExtractText = require('extract-text-webpack-plugin')

var env       = process.env.NODE_ENV || 'development'
  , prod      = env === 'production'
  , domain    = process.env.DOMAIN || process.env.npm_package_config_domain || 'develop.com'
  , dev_port  = prod ? '' : ':' + (process.env.npm_package_config_dev_port || 8081)

var entry =
  { client: ['./client/App' ] }

var plugins =
  [ new ExtractText('site.css', { allChunks:true })
  ]
var loaders = []

// init
// ----
if (prod) { // production settings
  plugins.push(new webpack.DefinePlugin({'process.env': { 'NODE_ENV': '"production"' } }))
  plugins.push(new ExtractText('site.css', { allChunks:true }))
  plugins.push(new webpack.optimize.UglifyJsPlugin())
  loaders.push({ test: /\.styl$/, loader: ExtractText.extract('css-loader!stylus-loader') })
  loaders.push({ test: /\.ls$/, loader: 'livescript-loader?const=true' })
} else {
  plugins.push(new webpack.HotModuleReplacementPlugin())
  // add hot-reload
  loaders.push({ test: /\.styl$/, loader: 'style-loader!css-loader!stylus-loader' })
  loaders.push({ test: /\.ls$/, loaders: ['react-hot', 'livescript-loader?const=true'] })
  entry.client.push
    ('webpack/hot/dev-server'
    , 'webpack-dev-server/client?http://'
      + domain
      + dev_port
    )
}

// main
// ----
module.exports =
  { cache: !prod
  , context:  __dirname
  , debug:    !prod
  , quiet:    prod
  , devtool:  prod ? false : 'source-map'
  , optimize: prod
  , entry:    entry
  , plugins:  plugins
  , resolve:  { extensions: ['', '.ls', '.js', '.styl'] }
  , module:   { loaders: loaders }
  , stylus:   { use: [nib()] }
  , node:     { fs: 'empty' }
  , output:
    { path:       path.join(__dirname, 'public/builds')
    , filename:   "[name].js"
    , publicPath: 'http://'
      + domain
      + dev_port
      + '/builds/'
    }
  }
