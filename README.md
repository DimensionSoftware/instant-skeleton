<center>
[![Instant Skeleton](https://dimensionsoftware.com/images/skull_keys.png)](https://dimensionsoftware.com)

Instant-Skeleton
================
[![Gitter](https://badges.gitter.im/Join
Chat.svg)](https://gitter.im/DimensionSoftware/instant-skeleton?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![Dimension Software](http://img.shields.io/badge/HTML-5-blue.svg?style=flat)](https://dimensionsoftware.com)
</center>

Build Bigger with Less
----------------------
Best realtime framework to lift heavy functionality lightening quick with Node.JS

__[DOCUMENTATION](http://dimensionsoftware.github.io/instant-skeleton) . [DEMO](https://todo.powerbulletin.com)__

## Quick Start

    $ git clone git@github.com:DimensionSoftware/instant-skeleton.git
    $ cd instant-skeleton
    $ npm install && npm test && npm start

## Create Your First Page

Building your SEO-friendly, realtime application is simple!  Instant Skeleton cobbles together the best of functional
React.JS into a single, routable concept that makes your on-screen productivity incredible:

>  ***Page*** | &nbsp; *declarative, isomorphic bits of [React](http://facebook.github.io/react/docs/getting-started.html) + [Omniscient](https://omniscientjs.github.io/) + [Immutable.JS](https://github.com/facebook/immutable-js)*

1. Add a Page Route

        $ vim shared/routes.ls

2. Add a Page Handler for the Route

        $ vim server/pages.ls

3. Add a Component for the Page

        $ vim shared/react/[ROUTE-NAME].ls

## Environment &amp; "npm config" Variables
* `NODE_ENV`  -- "development", "production" or "test"
* `NODE_PORT` -- port to listen on
* `DOMAIN`    -- domain of site
* `CACHE_URL` -- format for cache urls, eg: "//cache%n.%domain"

[See all configurable variables in package.json](https://github.com/DimensionSoftware/instant-skeleton/blob/master/package.json#L50-L91) and [customize with a .env file](https://github.com/motdotla/dotenv)!

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

1. **What is "develop.com" and why am I seeing a blank page?**

       Prefer to specify your own domain for local development and deployment?  Simply [specify that DOMAIN in a .env file](https://github.com/motdotla/dotenv) or export the DOMAIN environment variable; otherwise, append your /etc/hosts to include the develop &amp; cache domains:

       ```sh
       read -r -d '' MYDOMAINS <<'EOF'
       127.0.0.1 develop.com
       127.0.0.1 cache.develop.com
       127.0.0.1 cache2.develop.com
       127.0.0.1 cache3.develop.com
       127.0.0.1 cache4.develop.com
       EOF
       echo $MYDOMAINS >> /etc/hosts
       ```

2. **How is this different from Meteor.JS?**

       + We &hearts; [NPM](http://npmjs.org).
       + Instant Skeleton is tiny, fast &amp; secure.
       + We are streaming functional [LiveScript](http://livescript.net): write less code with fewer bugs.
       + Isomorphic Web Components leveraging [React](http://facebook.github.io/react/docs/getting-started.html) for data-binding.

3. **How easy is this to debug &amp; reason about?**

       + Variables are **const**ants
       + [Immutable.JS](https://github.com/facebook/immutable-js) persistent data structures
       + [ES6](http://tc39wiki.calculist.org/es6/), useful stack traces &amp; source maps
       + Check out our [perf](https://github.com/DimensionSoftware/instant-skeleton/tree/perf) branch for runtime profiling

4. **How rapid is development?**

       + [Instant "hot" live loads](https://www.youtube.com/watch?v=pw4fKkyPPg8)
       + Undo &amp; Redo for [FREE](https://github.com/omniscientjs/immstruct)
       + Source maps

5. **How can I enable &amp; disable features with zero impact for those unused?**

       We've implemented [The Famous TODO Example](https://todo.powerbulletin.com) for you to demonstrate building high-level functionality with Instant Skeleton.  Don't need it anymore?  Disable it--easy:

       ```sh
       vim shared/features.ls
       ```

6. **How can I add my own data store?**

       Simply require &amp; hook it into your Page handler or Resource:

       ```sh
       vim server/pages.ls
       vim server/resources.ls
       ```

7. **How easy is session management?**

       Sessions are streamed realtime with [LevelDB](https://github.com/google/leveldb) &amp; [Primus](https://github.com/primus/primus).

       ```sh
       vim server/pages.ls
       vim client/layout.ls
       vim shared/react/HomePage.ls
       ```

8. **What about cacheability?**

       All Pages are completely cacheable!  Etags &amp; proper cache-control headers are automagically set on every Page and sessions stream in real-time on Page load.  The idea is to persist personalization in user sessions.


9. **Production deployment?  We got you covered!**

       Export a proper NODE_ENV and expect the correct behaviors with "npm start" and "npm stop".  [We recommend
       Upstart](https://blog.jalada.co.uk/simple-upstart-script-to-keep-a-node-process-alive/) to keep your process
       alive.  Production builds shrink tiny, bootstrapping a reduced set of modules and client dependencies.

10. **What about iOS/Droid &amp; and mobile devices?**

       Instant Skeleton is designed to drop right into a [Cordova Container](https://cordova.apache.org/) and
       [NW.js](http://nwjs.io/)!  [React Native](https://github.com/facebook/react-native) support is on the horizon.

11. **Does this work with io.js?**

       Absolutely.


## [Hire Us!](mailto:keith@dimensionsoftware.com)

Really digging our [software architecture](https://dimensionsoftware.com)?  Say Hello and let us know:
[**keith@dimensionsoftware.com**](mailto:keith@dimensionsoftware.com)

## Contributors &amp; Idea Factories

[**Keith Hoerling**](https://github.com/khoerling) . 
[**John Beppu**](https://github.com/beppu) . 
[**Matt Elder**](https://github.com/dreamcodez) . 
[**Dave Seleno**](https://github.com/onelesd) . 
[**Mark Huge**](https://github.com/markhuge)

[According to GitHub](https://github.com/DimensionSoftware/instant-skeleton/graphs/contributors) . [Become a Contributor](https://github.com/DimensionSoftware/instant-skeleton/fork) .  [Pull request friendly!](https://github.com/DimensionSoftware/instant-skeleton/fork)

## [TODO](https://todo.powerbulletin.com)


* ADD: [Famo.us+React](https://github.com/Famous/famous-react/issues)
* ADD: [Viewdocs](http://progrium.viewdocs.io/viewdocs)
* ADD: Selenium and more tests
* ADD: Coverage.js working with LiveScript
* ADD: sum todos in Navigation
* FIX: whitelist to ipv6 match

&nbsp;

<center>
[![Fresh Software by Dimension](https://dimensionsoftware.com/images/software_by.png)](https://dimensionsoftware.com)
</center>
