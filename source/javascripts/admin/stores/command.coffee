@runCommand = Reflux.createAction
  asyncResult: true

@createNewDraft = Reflux.createAction
  asyncResult: true

@publishDraft = Reflux.createAction
  asyncResult: true

@runLater = (cmd, findPath) ->
  ->
    path = null
    if findPath
      path = pathStore.state.path
    runCommand( cmd, path )

@commandResultStore = Reflux.createStore
  init: ->
    @state = @defaultState()
    @listenTo runCommand, @onRunCommand
    @listenTo createNewDraft, @onCreateNewDraft
    @listenTo publishDraft, @onPublishDraft

  defaultState: ->
    command: ""
    running: false
    result: ""

  onRunCommand: (cmd, path) ->
    console.log "Running command", cmd, path
    @state = @defaultState()
    @state.running = true
    @state.result = ""
    @state.command = cmd
    @trigger @state
    request.post "/api/" + cmd
      .query path: path
      .end (err, response) =>
        console.log response
        if response.ok
          runCommand.completed( response.body )
          @state.running = false
          @state.result = response.text
          @trigger @state
        else
          runCommand.failed( response.error )

  onCreateNewDraft: (metadata) ->
    window.LiveReload.shutDown() if window.LiveReload
    console.log "Creating new draft", metadata
    @state = @defaultState()
    @state.running = true
    @state.command = "Creating new draft"
    @trigger @state
    request.post "/api/drafts"
      .type 'form'
      .send metadata
      .end (err, response) =>
        if response.ok
          @state.running = false
          @state.result = response.text
          @state.command = ""
          @trigger @state
          viewPath response.body.created

  onPublishDraft: (path) ->
    window.LiveReload.shutDown() if window.LiveReload

    @state = @defaultState()
    @state.running = true
    @state.command = "Publishing " + path
    @trigger @state

    request.post "/api/publish"
      .set('Content-Type', 'application/json')
      .send path: path
      .end (err, response) =>
        if response.ok
          @state.running = false
          @state.result = response.text
          @state.command = ""
          @trigger @state
          viewPath null
