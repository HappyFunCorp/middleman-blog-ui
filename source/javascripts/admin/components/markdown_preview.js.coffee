@MarkdownPreview = React.createClass
  getDefaultProps: ->
    markdown: ""
    
  render: ->
    rawMarkup = marked(@props.markdown, {sanitize: true});

    <div className="markdown-preview" dangerouslySetInnerHTML={{__html: rawMarkup}}>
    </div>