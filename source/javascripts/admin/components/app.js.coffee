@App = React.createClass
  mixins: [Reflux.connect(pathStore)]

  getInitialState: ->
    loading: false
    dirty: false
    path: null
    metadata: {}
    markdown: ""

  render: ->
    mainPanel = unless @state.path
      <Dashboard/>
    else
      <Editor/>

    <div>
      <AdminNavbar path={@state.path}/>
      {mainPanel}
    </div>

