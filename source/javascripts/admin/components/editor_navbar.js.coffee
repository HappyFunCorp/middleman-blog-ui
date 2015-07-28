@EditorNavbar = React.createClass
  mixins: [Reflux.connect(pathStore)]

  getInitialState: ->
    metadata: {}
    dirty: false
    saving: false

  toggleModal: ->
    @state.newDraftModal = !@state.newDraftModal
    console.log @state.newDraftModal
    @setState @state

  updateMeta: (metadata) ->
    @state.metadata = metadata
    @setState @state

  updateMetadata: ->
    console.log "Running update meta"
    @state.newDraftModal = false
    @setState @state
    updateMetadata( @state.metadata )
    saveCurrentArticle()

  onPublish: ->
    publishDraft( @state.path )

  render: ->
    metadata = for k,v of @state.metadata
      <MenuItem onClick={@toggleModal} key={k}>
        {k}: {v}
      </MenuItem>

    text = "Save"
    text = "Saving..." if @state.saving

    publish = <span/>

    if @state.draft
      publish = <NavItem href="#" onClick={@onPublish}>Publish Article</NavItem>

    <Nav navbar>
      {@newDraftModal()}
      <NavItem href='#' onClick={saveCurrentArticle} disabled={!@state.dirty || @state.saving}>{text}</NavItem>
      <DropdownButton title='Metadata'>
        {metadata}
      </DropdownButton>
      {publish}
      <NavItem disabled>{@state.path}</NavItem>
    </Nav>

  newDraftModal: ->
    return <span/> unless @state.newDraftModal

    <Modal title='Update' onRequestHide={@toggleModal}>
      <div className='modal-body'>
        <MetadataEditor metadata={@state.metadata} onChange={@updateMeta}/>
      </div>
      <div className='modal-footer'>
        <Button onClick={@closeModal}>Cancel</Button>
        <Button bsStyle='primary' onClick={@updateMetadata} disabled={@state.metadata.title.length < 5}>Update Data</Button>
      </div>
    </Modal>
