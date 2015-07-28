@DashboardDraftList = React.createClass
  mixins: [Reflux.connect(draftStore)],

  getInitialState: ->
    drafts: []

  componentDidMount: -> updateDraftList()

  render: ->
    drafts = @state.drafts.map (item) ->
      <li key={item.path}><a onClick={viewPath.bind(this, item.path)}>{item.title}</a></li>

    <div className="maincontent">
      <h1>Drafts</h1>
      
      <ul className="nav nav-pills nav-stacked">
        {drafts}
      </ul>
    </div>
