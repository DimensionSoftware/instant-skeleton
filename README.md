<center>
[![Instant Skeleton][is-image]][ds-link]

Instant-Skeleton
================
[![Gitter][gitter-image]][gitter-link] [![Dimension Software][html5-image]][ds-link]
</center>

Be Your Own Angel Investor
--------------------------
Realtime framework to lift heavy functionality lightening quick with Node.JS &amp; RethinkDB!

## Quick Start

    $ git clone git@github.com:DimensionSoftware/instant-skeleton.git
    $ cd instant-skeleton
    $ npm install && npm test && npm start

## Create Your First Page

Building your SEO-friendly, secure, realtime streaming application is simple!  Instant Skeleton cobbles together the best of functional React.JS into a single, routable concept that makes your on-screen productivity incredible:

>  ***Page*** | &nbsp; *declarative, isomorphic bits of
[React](http://facebook.github.io/react/docs/getting-started.html) + [Omniscient](https://omniscientjs.github.io/) + [RethinkDB](http://www.rethinkdb.com/api/javascript/)*

1. [Install RethinkDB](http://rethinkdb.com/docs/install/)

2. Add a Page Route &amp; Handler

        $ vim shared/routes.ls
        $ vim server/pages.ls

3. Add a React Component for the Page

        $ vim shared/react/[ROUTE-NAME].ls

## Essential Environment &amp; "npm config" Variables
* `NODE_ENV`  -- "development", "production" or "test"
* `NODE_PORT` -- port to listen on
* `DOMAIN`    -- domain of site
* `CACHE_URL` -- format for cache urls, eg: "//cache%n.%domain"

[See all configurable variables in package.json](https://github.com/DimensionSoftware/instant-skeleton/blob/master/package.json#L50-L87) and [customize with a .env file](https://github.com/motdotla/dotenv)!

## References

SERVER

* **Gulp** -- http://gulpjs.com
    * **nodemon** --  https://github.com/JacksonGariety/gulp-nodemon
    * **webpack** -- https://github.com/shama/gulp-webpack
* **Koa** -- http://koajs.com
    * **helmet** -- https://github.com/venables/koa-helmet
    * **rate limit** -- https://github.com/tunnckoCore/koa-better-ratelimit
    * **static cache** -- https://github.com/koajs/static-cache
    * **rethinkdbdash** -- https://github.com/neumino/rethinkdbdash
* **DotEnv** -- https://github.com/motdotla/dotenv
* **PM2** -- https://github.com/Unitech/pm2

SHARED

* **LiveScript** -- https://livescript.net
* **React** -- http://facebook.github.io/react/docs/getting-started.html
    * **react router component** -- https://github.com/STRML/react-router-component
    * **immutable.js** -- https://github.com/facebook/immutable-js
    * **omniscient** -- https://omniscientjs.github.io/
    * **hot-loader** -- http://gaearon.github.io/react-hot-loader/
* **RethinkDB** -- http://rethinkdb.com
    * **rethinkdb sessions** -- https://github.com/mikemintz/react-rethinkdb

CLIENT

* **Stylus** -- https://learnboost.github.io/stylus
    * **nib** -- https://github.com/tj/nib

## Principles

How much does your stack weigh?  Keeping Instant Skeleton light as possible means true agility and speed.  This no-compromise, SEO-friendly stack is fast, functional and streaming in realtime.  [RethinkDB is the single dependency to install](http://rethinkdb.com/docs/install/) and a cinch to scale your needs forward.  The rest is up to you!

Build bigger with less: a cutting-edge HTML5 core and true first-class mobile web experiences.  Got realtime physics at 60fps?  Real offline?  High-speed, secure websockets?  We do.

From nothing, you have potential to build greatness; only-- with Instant Skeleton, you start way ahead with the best
curated tools for securely lifting heavy, realtime functionality into the browser with insane productivity.  Unlock the
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
       + [ES6](http://tc39wiki.calculist.org/es6/), friendly stack traces &amp; source maps
       + [PM2](http://pm2.keymetrics.io/) instrumentation &amp; process supervision for the 99.999%

4. **How rapid is development?**

       + [Instant "hot" live loads](https://www.youtube.com/watch?v=pw4fKkyPPg8)
       + Undo &amp; Redo for [FREE](https://github.com/omniscientjs/immstruct)
       + Source maps

5. **How can I enable &amp; disable features with zero impact for those unused?**

       We've implemented [The Famous TODO Example](https://todo.powerbulletin.com) for you to demonstrate building high-level functionality with Instant Skeleton.  Don't need it anymore?  Disable it--easy:

       ```sh
       vim shared/features.ls
       ```

6. **What about cacheability?**

       All Pages are completely cacheable!  Etags &amp; proper cache-control headers are automagically set on every Page and sessions stream in real-time on load.  The idea is to persist personalization in user sessions, backed by HTML5 local storage.


7. **Production deployment?  We got you covered!**

       Export a proper NODE_ENV and expect the correct behaviors with "npm start", "npm stop" &amp; "npm restart".  Production builds shrink tiny, bootstrapping a reduced set of modules and client dependencies.  [Tweak ecosystem.json](https://github.com/DimensionSoftware/instant-skeleton/blob/master/ecosystem.json) to configure [PM2](http://pm2.keymetrics.io/) production.  For highly secure, end-to-end SSL, prefer termination infront of Node.JS.


8. **What about Native Desktop, iOS/Droid &amp; and mobile devices?**

       Instant Skeleton is engineered to drop right into a [Electron](http://electron.atom.io/), [Cordova](https://cordova.apache.org/) and [NW.js](http://nwjs.io/).  Of course, [React Native](https://facebook.github.io/react-native/) provides the best native experience for mobile.  Use realtime, secure WebSockets for communication back to your Instant Skeleton application!

## [Hire Us!](mailto:keith@dimensionsoftware.com)

Really digging our [software architecture](https://dimensionsoftware.com)?  [**Say Hello and let us know**](mailto:keith@dimensionsoftware.com)-- Instant Skeleton is battle-tested, having bootstrapped many of our most successful client projects.

[We are pull-request-friendly, contribute today!](https://github.com/DimensionSoftware/instant-skeleton/graphs/contributors)

##### [Example TODO Application](https://todo.powerbulletin.com)

<center>
[![Fresh Software by Dimension](https://dimensionsoftware.com/static/images/github/software_by.png)](https://dimensionsoftware.com)
</center>

[ds-link]: https://dimensionsoftware.com
[is-image]: https://dimensionsoftware.com/static/images/github/skull_keys.png
[gitter-image]: https://badges.gitter.im/Join%20Chat.svg
[gitter-link]: https://gitter.im/DimensionSoftware/instant-skeleton?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge
[html5-image]: http://img.shields.io/badge/HTML-5-blue.svg?style=flat
