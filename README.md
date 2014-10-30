Instant-Skeleton
================

Best _opinionated_ realtime framework to lift heavy functionality lightening quick with Node.JS

**PROTIP**  [Be sure to peruse our fancy documentation](http://dimensionsoftware.github.io/instant-skeleton)
**FORK ME** Pull request friendly

## Quick Start

    $ npm install && npm test && npm start

## Overview

Building your realtime application is simple: add _Pages_ (isomorphic bits of React) and _Services_ (RESTful & Realtime API
endpoints).  As an example, a basic TODO application is implemented herein.

* Add a New Page

    $ vim server/pages.ls    # add a route here

* Add a New RESTful Service

    $ vim server/services.ls # add a service here


## Environment Variables
* `NODE_ENV`  -- development, production or test
* `NODE_PORT` -- port to listen on

## References
* **Gulp** -- http://gulpjs.com
* **LiveScript** -- http://livescript.net
    * **Prelude.ls** -- http://preludels.com
* **Koa** -- http://koajs.com
* **React** -- http://facebook.github.io/react/docs/getting-started.html
* **Primus** -- https://github.com/primus/primus
    * **Engine.io** -- https://github.com/Automattic/engine.io
* **PM2** -- https://github.com/Unitech/pm2

## Contributors

[According to GitHub](https://github.com/DimensionSoftware/instant-skeleton/graphs/contributors)
[Become a Contributor!](https://github.com/DimensionSoftware/instant-skeleton/fork)

## TODO
* Famo.us
* Selenium tests
* Wire up react + react router
* Websockets + feathers-like services
* Bootstrap data-layer -- bookshelf or https://www.youtube.com/watch?v=41oDDTRWjIQ
