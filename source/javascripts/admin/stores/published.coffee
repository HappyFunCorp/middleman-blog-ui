@updatePublishedList = Reflux.createAction
  asyncResult: true

@publishedStore = Reflux.createStore
  init: ->
    @published = []
    @listenTo updatePublishedList, @onUpdatePublished

  onUpdatePublished: ->
    request.get "/admin/published.json", (err, response) =>
      if response.ok
        updatePublishedList.completed( response.body )
        @published = response.body
        @trigger @published
      else
        updatePublishedList.failed(response.error)