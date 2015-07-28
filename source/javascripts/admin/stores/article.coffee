@viewPath = Reflux.createAction
  asyncResult: true

@updateMarkdown = Reflux.createAction()
@updateMetadata = Reflux.createAction()
@saveCurrentArticle = Reflux.createAction()

@pathStore = Reflux.createStore
  init: ->
    @state = @defaultState()
    @listenTo viewPath, @onViewPath
    @listenTo updateMarkdown, @onUpdateMarkdown
    @listenTo updateMetadata, @onUpdateMetadata
    @listenTo saveCurrentArticle, @onSaveCurrentArticle

  defaultState: ->
    loading: false
    dirty: false
    path: null
    draft: false
    metadata: {}
    markdown: ""

  onViewPath: (path) ->
    console.log "Loading path", path
    @state = @defaultState()
    @state.path = path
    @state.loading = true
    @trigger @state
    if !path
      viewPath.completed( null )
      return
    request.get "/api/post"
      .query path: path
      .end (err, response) =>
        console.log response
        if response.ok
          viewPath.completed( response.body )
          d = response.body
          @state.loading = false
          @state.metadata = d.meta
          @state.markdown = d.content
          @state.draft = path.match( "^drafts/")
          @trigger @state
        else
          viewPath.failed( response.error )

  onUpdateMetadata: (metadata) ->
    @state.metadata = metadata
    @state.dirty = true
    @trigger @state

  onUpdateMarkdown: (markdown) ->
    @state.markdown = markdown
    @state.dirty = true
    @trigger @state

  onSaveCurrentArticle: ->
    window.LiveReload.shutDown() if window.LiveReload

    @state.saving = true
    @trigger @state

    request.post "/api/post"
      .set('Content-Type', 'application/json')
      .send path: @state.path, meta: @state.metadata, body: @state.markdown
      .end (err, response) =>
        if response.ok
          @state.saving = false
          @state.dirty = false
          @trigger @state
