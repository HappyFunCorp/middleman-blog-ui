@updateDraftList = Reflux.createAction
  asyncResult: true

@draftStore = Reflux.createStore
  init: ->
    @drafts = []
    @listenTo( updateDraftList, @onUpdateDrafts )

  onUpdateDrafts: ->
    request.get "/admin/drafts.json", (err, response) =>
      if response.ok
        updateDraftList.completed( response.body )
        @drafts = response.body
        @trigger @drafts
      else
        updateDraftList.failed(response.error)
