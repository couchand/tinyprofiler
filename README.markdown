tinyprofiler
============

a minimal isomorphic JavaScript profiler
strongly influenced by [MiniProfiler][0]

  * [introduction](#introduction)
  * [getting started](#getting-started)
  * [faq](#faq)
  * [documentation](#documentation)
    * [data structure](#data-structure)
    * [options](#options)
    * [api methods](#api-methods)
    * [express middleware](#express-middleware)

introduction
------------

*tinyprofiler* is a minimal isomorphic JavaScript profiler, inspired
by MiniProfiler but adapted to the asynchronous nature of JavaScript.

getting started
---------------

If you have node.js and npm set up, install with:

```bash
> npm install --save tinyprofiler
```

Mount `profiler.middleware` as the first middleware on your stack.
If you'd also like to view the profiler results in the browser, take
a look at [tinyprofiler-client][1].

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
  * options
  * api methods
  * express middleware

### data structure ###

```json
{
  "id": "jZKO20skdk0983sF",
  "name": "GET /users/1234",
  "start": "1972-06-15T12:38:43Z",
  "length": [0, 270261496],
  "steps": [
    {
      "name": "query Users",
      "start": [0, 49920582],
      "length": [0, 101885726]
    },
    {
      "name": "send results",
      "start": [0, 163945603],
      "length": [0, 256993038],
      "steps": [
        {
          "name": "format user",
          "start": [0, 28373405],
          "length": [0, 77504993]
        }
      ]
    }
  ]
}
```

the recursive data structure has the following properties:

  * `id`: a guid for the request [root only]
  * `name`: the name of the step
  * `details`: additional information [optional]
  * `start`: the start time of the step [iso date on root]
  * `length`: the finish time of the step
  * `steps`: any child steps [optional]

all timings are relative to the start time of their parent, and are
recorded in the format of `process.hrtime()`. each timing is a pair
of integers - the first the number of seconds since the start of the
parent, and the second the number of nanoseconds.

the `start` entry for the root has an iso date string representing
the start time of the entire profile.

### options ###

*tinyprofiler* accepts a variety of configuration options.  Many of
these are shared between client and server code, but some of them are
only applicable to one or the other.

*n.b.* the following also documents options for *tinyprofiler-client*.

#### shared options ####

These opitons should be identical between the client and the server.

##### headerName - `"X-TinyProfiler-Ids"` #####

the name of the HTTP header to use to send profile ids

##### path - `"tp"` #####

server path to mount *tinyprofiler* REST API

##### profilerKey - `"profiler"` #####

key name on request object to store request-scoped profiler

#### distinct options ####

These options have the same meaning on the client and server, but
nevertheless are frequently different in the two environments.

##### requestName - `(req) -> "#{req.method} #{req.path}"` #####

function to build profile name from request object (method defaults
to "AJAX" on client)

##### requestDetails - `(req) ->` #####

function to build profile details from request object

#### server options ####

##### profileResponse - `true` #####

do we automatically profile the server response?

#### client options ####

##### monkeyPatch - `true` #####

do we automatically monkey patch the XHR object?

##### profileRequest - `true` #####

do we automatically profile each XHR request?

### api methods ###

*soon*

### express middleware ###

*forthcoming*

##### ╭╮☲☲☲╭╮ #####

[0]: https://github.com/MiniProfiler
[1]: https://github.com/couchand/tinyprofiler-client
