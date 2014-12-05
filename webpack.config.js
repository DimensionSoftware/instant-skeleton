var nib = require('nib');
var path = require('path');

var webpack     = require('webpack');
var ExtractText = require('extract-text-webpack-plugin');

var env  = process.env.NODE_ENV || 'development'
var prod = env === 'production'

var entry = ['./client/layout.ls']
if (!prod) // add code hot-swapping
  entry.push('webpack/hot/dev-server'
  , 'webpack-dev-server/client?http://'
    + process.env.npm_package_config_subdomain
    + ':'
    + process.env.npm_package_config_dev_port)

var plugins =
  [ new webpack.DefinePlugin({ 'process.env':{NODE_ENV:env} }) // for react
  , new webpack.optimize.DedupePlugin()
  , new ExtractText('site.css', {allChunks:true})
  ]
if (prod) // production plugins
  plugins.push(new webpack.optimize.UglifyJsPlugin())
else
  plugins.push(new webpack.HotModuleReplacementPlugin())


module.exports =
  { cache: !prod
  , debug: !prod
  , devtool: 'source-map'
  , optimize: prod
  , entry: entry
  , plugins: plugins
  , resolve:
    { extensions: ['', '.ls', '.js', '.styl'] }
  , module:
    { loaders:
      [ { test: /\.jade$/, loader: 'jade-loader?self' }
      , { test: /\.ls$/,   loader: 'livescript-loader' }
      , { test: /\.styl$/, loader: ExtractText.extract('stylus-loader', 'css-loader!stylus-loader') }
      ]
    }
  , stylus: { use: [nib()] }
  , node:
    { fs: 'empty' }
  , output:
    { path: path.join(__dirname, 'public/builds/')
    , fileName: "[name].js"
    , chunkFilename: "[hash]/js/[id].js"
    }
  }
