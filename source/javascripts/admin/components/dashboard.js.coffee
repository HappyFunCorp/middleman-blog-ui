@Dashboard = React.createClass
  render: ->
    <div className="dashboard">
      <div className="row">
        <DashboardDraftList />
        <DashboardPublishedList />
      </div>
    </div>
