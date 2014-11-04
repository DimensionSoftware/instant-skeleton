![Instant Skeleton](https://raw.githubusercontent.com/dimensionsoftware/instant-skeleton/gh-pages/assets/skull_keys.png)

Instant-Skeleton
================
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/DimensionSoftware/instant-skeleton?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Build bigger with less
----------------------
Best _opinionated_ realtime framework to lift heavy functionality lightening quick with Node.JS

**PROTIP**  [Be sure to peruse our fancy documentation](http://dimensionsoftware.github.io/instant-skeleton)

**FORK** [Pull request friendly!](https://github.com/DimensionSoftware/instant-skeleton/fork)

## Quick Start

    $ npm install && npm test && npm start

## Overview

Building your SEO-friendly, realtime application is simple: add **Pages** <small>(declarative, isomorphic bits of React)</small> and **Services** <small>(RESTful & Realtime API endpoints)</small>.  To get started instantly, this skeleton implements a basic TODO application <small>(the "hello world" of realtime frameworks)</small> as a starting example.

* Add a new **Page**

        $ vim server/pages.ls    # add a route here

* Add a new **Service**

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
    * **React Router** -- https://github.com/rackt/react-router
* **Primus** -- https://github.com/primus/primus
    * **Engine.io** -- https://github.com/Automattic/engine.io
* **PM2** -- https://github.com/Unitech/pm2

## Principles

How much does your stack weigh?  Keeping Instant Skeleton light as possible means true agility and speed.  This no-compromise stack is fast, functional and streaming in realtime.

From nothing, you have potential to build greatness; only-- with Instant Skeleton, you start way ahead with the best curated tools for lifting heavy, realtime functionality into the browser lightening quick.

## Contributors

[According to GitHub](https://github.com/DimensionSoftware/instant-skeleton/graphs/contributors)

[Become a Contributor!](https://github.com/DimensionSoftware/instant-skeleton/fork)

## TODO
* Famo.us
* Selenium tests
* Wire up react + react router
* Coverage working with LiveScript
* Websockets + feathers-like services
* Implement TODO example app inside skeleton
* Better WebPack config that correctly exports modules
* Bootstrap data-layer -- bookshelf or https://www.youtube.com/watch?v=41oDDTRWjIQ
