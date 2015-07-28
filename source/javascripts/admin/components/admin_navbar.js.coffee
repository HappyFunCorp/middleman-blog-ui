@AdminNavbar = React.createClass
  mixins: [Reflux.connect(commandResultStore)]

  getDefaultProps: ->
    path: ""
    draft: false

  getInitialState: ->
    command: ""

  render: ->
    subnav = unless @props.path
      <DashboardNavbar />
    else
      <EditorNavbar />

    <Navbar brand={<a href="/admin">Blog Admin</a>} fixedTop>
      {@commandResult()}
      {subnav}
      <CollapsibleNav>
        <Nav navbar right>
          <DropdownButton title='Site Commands'>
            <NavItem onClick={runLater( 'diff', true )}>Diff</NavItem>
            <NavItem onClick={runLater( 'status' )}>Git Status</NavItem>
            <NavItem onClick={runLater( 'update' )}>Update</NavItem>
            <NavItem onClick={runLater( 'build' ) }>Build</NavItem>
            <NavItem onClick={runLater( 'deploy' )}>Deploy</NavItem>
          </DropdownButton>
          <NavItem href={"/" + @props.path}>Preview</NavItem>
        </Nav>
      </CollapsibleNav>
    </Navbar>

  closeResult: ->
    @state.command = ""
    @setState @state

  commandResult: ->
    return <span/> if @state.command == ""

    <Modal title={@state.command} onRequestHide={@closeResult} bsSize='large' >
      <div className='modal-body'>
        <pre>{@state.result}</pre>
      </div>
      <div className='modal-footer'>
        <Button onClick={@closeResult}>OK</Button>
      </div>
    </Modal>

