<center>
[![Instant Skeleton](https://raw.githubusercontent.com/dimensionsoftware/instant-skeleton/gh-pages/assets/skull_keys.png)](https://dimensionsoftware.com)

Instant-Skeleton
================
[![Gitter](https://badges.gitter.im/Join
Chat.svg)](https://gitter.im/DimensionSoftware/instant-skeleton?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![Dimension Software](http://img.shields.io/badge/HTML-5-blue.svg?style=flat)](https://dimensionsoftware.com)
</center>

Build Bigger with Less
----------------------
Best _opinionated_ realtime framework to lift heavy functionality lightening quick with Node.JS

**PROTIP** [Be sure to peruse our fancy documentation](http://dimensionsoftware.github.io/instant-skeleton)

## Quick Start

    $ git clone git@github.com:DimensionSoftware/instant-skeleton.git
    $ cd instant-skeleton
    $ npm install && npm test && npm start

## Overview

Building your SEO-friendly, realtime application is simple: add **Pages** <small>(declarative, isomorphic bits of React)</small> and **Services** <small>(RESTful & Realtime API endpoints)</small>.

* Add a new **Page**

        $ vim shared/routes.ls
        $ vim server/pages.ls

* Add a new **Service**

        $ vim server/services.ls

* Enable and Disable **Features** <small>with zero impact for unused features</small>

        $ vim shared/features.ls

## Environment &amp; "npm config" Variables
* `NODE_ENV`  -- "development", "production" or "test"
* `NODE_PORT` -- port to listen on
* `SUBDOMAIN` -- subdomain of site

[See all configurable variables in package.json](https://github.com/DimensionSoftware/instant-skeleton/blob/master/package.json#L48-L91) and [customize with a .env file](https://github.com/motdotla/dotenv)!

## References

SERVER

* **Gulp** -- http://gulpjs.com
    * **livereload** -- https://github.com/vohof/gulp-livereload
    * **nodemon** --  https://github.com/JacksonGariety/gulp-nodemon
    * **webpack** -- https://github.com/shama/gulp-webpack
* **Koa** -- http://koajs.com
    * **geoip lite** -- https://github.com/bluesmoon/node-geoip
    * **helmet** -- https://github.com/venables/koa-helmet
    * **level sessions** -- https://github.com/purposeindustries/koa-level
    * **rate limit** -- https://github.com/tunnckoCore/koa-better-ratelimit
    * **static cache** -- https://github.com/koajs/static-cache
* **PM2** -- https://github.com/Unitech/pm2
* **DotEnv** -- https://github.com/motdotla/dotenv

SHARED

* **LiveScript** -- https://livescript.net
    * **prelude.ls** -- http://preludels.com
* **React** -- http://facebook.github.io/react/docs/getting-started.html
    * **react router component** -- https://github.com/STRML/react-router-component
    * **immutable.js** -- https://github.com/facebook/immutable-js
    * **omniscient** -- https://omniscientjs.github.io/
* **Primus** -- https://github.com/primus/primus
    * **engine.io** -- https://github.com/Automattic/engine.io
    * **multiplex** -- https://github.com/cayasso/primus-multiplex
* **LevelDB** -- https://github.com/google/leveldb
    * **party** -- https://github.com/substack/level-party
    * **sublevel** -- https://github.com/dominictarr/level-sublevel
    * **livestream** -- https://github.com/dominictarr/level-live-stream

CLIENT

* **Famo.us** -- https://famo.us
* **Stylus + NIB** -- https://learnboost.github.io/stylus

## Principles

How much does your stack weigh?  Keeping Instant Skeleton light as possible means true agility and speed.  This
no-compromise, SEO-friendly stack is fast, functional and streaming in realtime.  Zero external service
dependencies make deploying a cinch.  Persistence is [LevelDB](https://github.com/google/leveldb).

With technologies like [Famo.us](https://famou.us) and a savvy, cutting-edge HTML5 core, Instant Skeleton provides true
first-class mobile experiences.  Got realtime physics at 60fps?  Real offline?  High-speed, secure websockets?  We do.

From nothing, you have potential to build greatness; only-- with Instant Skeleton, you start way ahead with the best
curated tools for lifting heavy, realtime functionality into the browser with insane productivity.  Unlock the
potential of HTML5 and Node.JS.  [Start hacking now!](https://github.com/DimensionSoftware/instant-skeleton/fork)

## FAQ

1. How is this different from Meteor.JS?

       + We &hearts; [NPM](http://npmjs.org).
       + Instant Skeleton is tiny, fast &amp; secure.
       + We are streaming functional [LiveScript](http://livescript.net): write less code with fewer bugs.
       + Isomorphic Web Components leveraging [React](http://facebook.github.io/react/docs/getting-started.html) for data-binding.

2. How easy is this to debug &amp; reason about?

       + All variables are const
       + Immutable.JS persistent data structures
       + --harmony generators provide useful stack traces
       + Check out our [perf](https://github.com/DimensionSoftware/instant-skeleton/tree/perf) branch for runtime profiling


## Contributors &amp; Idea Factories

[**Keith Hoerling**](https://github.com/khoerling)

[**John Beppu**](https://github.com/beppu)

[**Matt Elder**](https://github.com/dreamcodez)

[**Dave Seleno**](https://github.com/onelesd)

[**Mark Huge**](https://github.com/markhuge)


[According to GitHub](https://github.com/DimensionSoftware/instant-skeleton/graphs/contributors) . [Become a Contributor](https://github.com/DimensionSoftware/instant-skeleton/fork) .  [Pull request friendly!](https://github.com/DimensionSoftware/instant-skeleton/fork)

## TODO

**We appreciate your enthusiasm; this code is not yet ready for prime-time!**

* [Famo.us+react](https://github.com/Famous/famous-react/issues)
* Feathers-like services
* Selenium and more tests
* Coverage working with LiveScript
* Fork and implement TODO example
* More beautiful documentation &amp; better literate .ls

&nbsp;

<center>
[![Fresh Software by Dimension](https://dimensionsoftware.com/images/software_by.png)](https://dimensionsoftware.com)
</center>
