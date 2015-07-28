@Editor = React.createClass
  mixins: [Reflux.connect(pathStore)]

  handleChange: (value) ->
    updateMarkdown value
    @restartTimer()

  restartTimer: () ->
    clearTimeout( @timer ) if( @timer )
    @timer = setTimeout =>
      saveCurrentArticle()
      @timer = null
    , 2000

  render: ->
    <div className="editor">
      <div className="row">
        <div className="editorPane">
          <AutosizeTextarea value={@state.markdown} onChange={@handleChange}/>
        </div>
        <div className="previewPane">
          <MarkdownPreview markdown={@state.markdown} />
        </div>
      </div>
    </div>