@DashboardPublishedList = React.createClass
  mixins: [Reflux.connect(publishedStore)],

  getInitialState: ->
    articles: []

  componentDidMount: -> updatePublishedList()

  render: ->
    articles = @state.articles.map (item) ->
      <li key={item.path}><a onClick={viewPath.bind(this, item.path)}>{item.title}</a></li>

    <div className="sidebar">
      <h1>Published</h1>
      
      <ul className="nav nav-pills nav-stacked">
        {articles}
      </ul>
    </div>
