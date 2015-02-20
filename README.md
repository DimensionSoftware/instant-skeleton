<center>
[![Instant Skeleton](https://dimensionsoftware.com/images/skull_keys.png)](https://dimensionsoftware.com)

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

## Create Your First Page

Building your SEO-friendly, realtime application is simple!  Instant Skeleton cobbles together the best of functional
React.JS into a single, routable concept that makes your on-screen productivity incredible:

>  | ***Page*** | &nbsp; *declarative, isomorphic bits of React + Omniscient + Immutable.JS*

1. Add a Page Route

        $ vim shared/routes.ls

2. Add a Page Handler for the Route

        $ vim server/pages.ls

3. Add a Component for the Page

        $ vim shared/react/[ROUTE-NAME].ls

## Environment &amp; "npm config" Variables
* `NODE_ENV`  -- "development", "production" or "test"
* `NODE_PORT` -- port to listen on
* `SUBDOMAIN` -- subdomain of site

[See all configurable variables in package.json](https://github.com/DimensionSoftware/instant-skeleton/blob/master/package.json#L48-L91) and [customize with a .env file](https://github.com/motdotla/dotenv)!

## References

SERVER

* **Gulp** -- http://gulpjs.com
    * **nodemon** --  https://github.com/JacksonGariety/gulp-nodemon
    * **webpack** -- https://github.com/shama/gulp-webpack
* **Koa** -- http://koajs.com
    * **helmet** -- https://github.com/venables/koa-helmet
    * **level sessions** -- https://github.com/purposeindustries/koa-level
    * **rate limit** -- https://github.com/tunnckoCore/koa-better-ratelimit
    * **static cache** -- https://github.com/koajs/static-cache
* **DotEnv** -- https://github.com/motdotla/dotenv

SHARED

* **LiveScript** -- https://livescript.net
* **React** -- http://facebook.github.io/react/docs/getting-started.html
    * **react router component** -- https://github.com/STRML/react-router-component
    * **immutable.js** -- https://github.com/facebook/immutable-js
    * **omniscient** -- https://omniscientjs.github.io/
    * **hot-loader** -- http://gaearon.github.io/react-hot-loader/
* **Primus** -- https://github.com/primus/primus
    * **engine.io** -- https://github.com/Automattic/engine.io
    * **emitter** -- https://github.com/cayasso/primus-emitter
    * **multiplex** -- https://github.com/cayasso/primus-multiplex
    * **resource** -- https://github.com/cayasso/primus-resource
* **LevelDB** -- https://github.com/google/leveldb
    * **party** -- https://github.com/substack/level-party
    * **sublevel** -- https://github.com/dominictarr/level-sublevel
    * **livestream** -- https://github.com/dominictarr/level-live-stream

CLIENT

* **Famo.us** -- https://famo.us
* **Stylus** -- https://learnboost.github.io/stylus
    * **nib** -- https://github.com/tj/nib

## Principles

How much does your stack weigh?  Keeping Instant Skeleton light as possible means true agility and speed.  This
no-compromise, SEO-friendly stack is fast, functional and streaming in realtime.  Zero external service
dependencies make deploying a cinch.  Persistence is [LevelDB](https://github.com/google/leveldb).  The rest is up to you!

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

       + Variables are **const**ants
       + [Immutable.JS](https://github.com/facebook/immutable-js) persistent data structures
       + [ES6](http://tc39wiki.calculist.org/es6/), useful stack traces &amp; source maps
       + Check out our [perf](https://github.com/DimensionSoftware/instant-skeleton/tree/perf) branch for runtime profiling

3. How rapid is development?

       + [Instant "hot" live loads](https://www.youtube.com/watch?v=pw4fKkyPPg8)
       + Undo &amp; Redo for [FREE](https://github.com/omniscientjs/immstruct)
       + Source maps

4. How can I enable &amp; disable features with zero impact for those unused?

            $ vim shared/features.ls

5. How can I add my own data store?

       + Simply require &amp; hook it into your Page handler or Resource:

            $ vim server/pages.ls
            $ vim server/resources.ls

6. How easy is session management?

       + Session updates are streamed realtime with [LevelDB](https://github.com/google/leveldb) &amp; [Primus](https://github.com/primus/primus).

            $ vim server/pages.ls
            $ vim client/layout.ls
            $ vim shared/react/HomePage.ls


7. What is "develop.com" and why am I seeing a blank page?

       + Prefer to specify your own domains for local development?  Simply update the package.json; otherwise, append your /etc/hosts to include the develop &amp; cache domains:

            $ echo "127.0.0.1 develop.com cache2.develop.com cache3.develop.com cache4.develop.com" >> /etc/hosts

8. What about cacheability?

       + Since etags &amp; proper cache-control headers are automagically set on every Page, and sessions stream in
         real-time on page load, all pages are completely cacheable!  The idea is to persist personalization in user sessions.

9. Does this work with io.js?

       Absolutely!



## Contributors &amp; Idea Factories

[**Keith Hoerling**](https://github.com/khoerling)

[**John Beppu**](https://github.com/beppu)

[**Matt Elder**](https://github.com/dreamcodez)

[**Dave Seleno**](https://github.com/onelesd)

[**Mark Huge**](https://github.com/markhuge)


[According to GitHub](https://github.com/DimensionSoftware/instant-skeleton/graphs/contributors) . [Become a Contributor](https://github.com/DimensionSoftware/instant-skeleton/fork) .  [Pull request friendly!](https://github.com/DimensionSoftware/instant-skeleton/fork)

## TODO

* [Famo.us+React](https://github.com/Famous/famous-react/issues)
* Selenium and more tests
* Coverage working with LiveScript
* Fork and implement TODO example
* More beautiful documentation &amp; better literate .ls

&nbsp;

<center>
[![Fresh Software by Dimension](https://dimensionsoftware.com/images/software_by.png)](https://dimensionsoftware.com)
</center>
