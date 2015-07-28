@DashboardNavbar = React.createClass
  getInitialState: ->
    newDraftModal: false
    metadata: 
      title: ""
      subtitle: ""
      tags: ""

  toggleModal: ->
    @state.newDraftModal = !@state.newDraftModal
    @state.metadata =
      title: ""
      subtitle: ""
      tags: ""
    @setState @state

  updateMeta: (metadata) ->
    @state.metadata = metadata
    @setState @state

  onCreateNewDraft: ->
    console.log "Running create new draft"
    @state.newDraftModal = false
    createNewDraft( @state.metadata )

  render: ->
    <Nav navbar>
      {@newDraftModal()}
      <NavItem href='#' onClick={@toggleModal}>New Draft</NavItem>
    </Nav>

  closeModal: ->
    @state.newDraftModal = false
    @setState @state

  updateMeta: (metadata) ->
    @state.metadata = metadata
    @setState @state

  newDraftModal: ->
    return <span/> unless @state.newDraftModal

    <Modal title='New Draft' onRequestHide={@toggleModal}>
      <div className='modal-body'>
        <MetadataEditor metadata={@state.metadata} onChange={@updateMeta}/>
      </div>
      <div className='modal-footer'>
        <Button onClick={@closeModal}>Cancel</Button>
        <Button bsStyle='primary' onClick={@onCreateNewDraft} disabled={@state.metadata.title.length < 5}>New Draft</Button>
      </div>
    </Modal>
