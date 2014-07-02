# the todo app

request = require 'superagent'
client  = require 'tinyprofiler-client'
ui      = require 'tinyprofiler-react'

module.exports = app = ->

  # the items
  items = []

  # create a tinyprofiler client
  #   default behavior monkey patches XmlHttpRequest
  profiles = client()

  # use tinyprofiler-react to render client markup
  renderProfiler = ->
    ui.renderElement profiles, document.getElementById 'tp'

  # render the list of todos
  renderItems = ->
    list = document.getElementById 'todos'
    list.innerHTML = (
      renderItem item for item in items
    ).concat(
      renderNewItem()
    ).join '\n'

  # render an individual todo
  renderItem = (item) ->
    isDone = if item.done then ' checked' else ''
    """
    <li id="item#{item.id}" class="item">
      <input class="done" type="checkbox"#{isDone}>
      <input class="label" type="text" value="#{item.label}">
    </li>
    """

  # render a new item placeholder
  renderNewItem = ->
    """
    <li id="item-new" class="item">
      <input class="done" type="checkbox" disabled>
      <input class="label" type="text" value="" placeholder="create a new item...">
    </li>
    """

  # create a todo update handler
  updateHandler = (id, box, label) ->
    ->
      updateTodo
        id: id
        label: label.value
        done: box.checked

  # create a todo create handler
  createHandler = (label) ->
    ->
      createTodo label.value

  addHandlers = ->
    for own i, item of document.getElementsByClassName 'item'
      id = item.id[4..]
      continue if id is '-new'
      box = item.children[0]
      label = item.children[1]
      box.onchange = label.onblur = updateHandler id, box, label

    newitem = document.getElementById 'item-new'
    newlabel = newitem.children[1]
    newlabel.onblur = createHandler newlabel

  # render everything
  render = ->
    getTodos ->
      renderItems()
      renderProfiler()
      addHandlers()

  # get all todos
  getTodos = (cb) ->
    request
      .get '/api/todos'
      .end (err, res) ->
        return console.error err if err
        items = res.body
        console.log items
        cb()

  # add a new todo
  createTodo = (label) ->
    request
      .post '/api/todos'
      .send
        label: label
        done: no
      .end (err, res) ->
        return console.error err if err
        render()

  # update a todo
  updateTodo = (todo) ->
    request
      .put "/api/todos/#{todo.id}"
      .send todo
      .end (err, res) ->
        return console.error err if err
        render()

  {render}
