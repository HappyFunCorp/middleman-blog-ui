@API = 
  loadUrl: (url) ->
    console.log "Loading", url
    unless @promises
      console.log "Creating promise"
      @promises = {}

    unless @promises[url]
      console.log "Fetching", url
      @promises[url] = $.Deferred()

      $.ajax( url ).success (data) =>
        console.log "Got back: ", data
        console.log @promises[url]
        @promises[url].resolve data
      , (error) =>
        @promises[url].reject error

    @promises[url]

  loadPost: (path) ->
    ret = $.Deferred()

    $.ajax( '/api/post', {data: {path: path}} ).success (data) =>
      console.log "Got post back", data
      ret.resolve( data )
    .fail (e) =>
      ret.reject( e.responseJSON )

    ret

  savePost: (path, meta, body) ->
    ret = $.Deferred()

    $.ajax( '/api/post', {method: 'POST', data: {path: path, meta: meta, body: body} } ).success (data) =>
      console.log "Saved post"
      ret.resolve data
    .fail (e) =>
      console.log "Error saving post"
      ret.reject( e.responseJSON )

    ret

  newDraft: (metadata) ->
    $.post( '/api/drafts', metadata )

  publishDraft: (path) ->
    $.post( '/api/publish', { path: path } )

  uploadFile: ( path, nativeEvent, process_cb ) ->
    console.log "Uploading image to path"

    fd = new FormData()
    fd.append 'path', path
    fd.append 'file', nativeEvent.dataTransfer.files[0]

    $.ajax 
      type: "post"
      url: '/api/images'
      xhr: ->
        xhr = new XMLHttpRequest()
        xhr.upload.onprogress = process_cb
        xhr
      cache: false
      contentType: false
      # complete: uploadCompleted
      processData: false
      data: fd

  runCommand: (cmd, path) ->
    console.log "Running command", cmd, path

    callback = (e) ->
      console.log "Got change"
      console.log e
      true

    # $.post( '/api/' + cmd )
    $.ajax
      type: 'post'
      url: '/api/' + cmd
      data: {path: path}
      xhr: ->
        xhr = new XMLHttpRequest()
        xhr.onprogress = callback # process_cb
        # xhr.upload.onprogress = process_cb
        xhr


  loadDrafts: ->
    @loadUrl "/admin/drafts.json"

  loadPublished: ->
    @loadUrl "/admin/published.json"