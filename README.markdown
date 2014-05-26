tinyprofiler
============

a minimal isomorphic JavaScript profiler
strongly influenced by [MiniProfiler][0]

 * introduction
 * getting started
 * faq
 * documentation

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

documentation
-------------

 * data structure
 * api methods
 * express middleware

###data structure###

```json
{
  "id": "jZKO20skdk0983sF",
  "name": "GET /users/1234",
  "start": "1972-06-15T12:38:43Z",
  "end": [0, 270261496],
  "steps": [
    {
      "name": "query Users",
      "start": [0, 49920582],
      "end": [0, 101885726]
    },
    {
      "name": "send results",
      "start": [0, 163945603],
      "end": [0, 256993038],
      "steps": [
        {
          "name": "format user",
          "start": [0, 198373405],
          "end": [0, 237504993]
        }
      ]
    }
  ]
}
```

the recursive data structure has the following properties:

  * `id`: a guid for the request [root only]
  * `name`: the name of the step
  * `start`: the start time of the step [iso date on root]
  * `end`: the finish time of the step
  * `steps`: any child steps [optional]

all timings are relative to the start time of the root, and are
recorded in the format of `process.hrtime()`. each timing is a pair
of integers - the first the number of seconds since the start of the
root, and the second the number of nanoseconds.

the `start` entry for the root has an iso date string representing
the start time of the entire profile.

###api methods###

*soon*

###express middleware###

*forthcoming*

[0]: https://github.com/MiniProfiler
