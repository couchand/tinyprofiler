tinyprofiler
============

a minimal isomorphic JavaScript profiler
strongly influenced by [MiniProfiler][0]

 * introduction
 * getting started
 * faq
 * api documentation

introduction
------------

*tinyprofiler* is a minimal isomorphic JavaScript profiler, inspired
by MiniProfiler but adapted to the asynchronous nature of JavaScript.

getting started
---------------

When published in npm you'll be able to issue:

```bash
> npm install --save tinyprofiler
```

For the time being, build tinyprofiler and copy the library into
your project manually.

Mount `profiler.middleware` as the first middleware on your stack.

faq
---

***Isn't MiniProfiler great?  Why wouldn't I just use that?***

There are two main reasons you might use *tinyprofiler* over
MiniProfiler. *tinyprofiler* is designed first and foremost to be
isomorphic, so the same profiler can be used on the client and server.
This is great for many JavaScript projects, but critical for ones
aiming for the Holy Grail of an isomorphic codebase.

More broadly, the data model for MiniProfiler doesn't really adapt
to the async-by-default nature of born-on-the-web JavaScript.
*tinyprofiler* offers explicit synchronous and asynchronous APIs.

api documentation
-----------------

*forthcoming*

[0]: https://github.com/MiniProfiler
