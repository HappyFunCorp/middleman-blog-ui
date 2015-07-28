@AutosizeTextarea = React.createClass
  getInitialState: ->
    @shrink = 0
    value: @props.value,
    style: 
      boxSizing: "border-box"
      minHeight: "31px"
      overflowX: "hidden"
      height: 50
      resize: 'none'

  componentWillReceiveProps: (props) ->
    @state.value = props.value
    @state.trigger_resize = true
    @setState @state

  # componentWillUpdate: () ->
  #   console.log "Start", React.findDOMNode( @refs.myInput )

  componentDidUpdate: ->
    React.findDOMNode( @refs.myInput ).setSelectionRange( @position, @position )
    if @state.trigger_resize
      @state.trigger_resize = false
      requestAnimationFrame =>
        @resize React.findDOMNode( @refs.myInput )

  inputHandler: (e)->
    @resize( e.target )
    if( @props.onChange )
      @position = e.target.selectionStart
      @props.onChange( e.target.value )

  resize: (target) ->
    unless @diff
      @compStyle = window.getComputedStyle(target);
      @diff = parseFloat(@compStyle.getPropertyValue('border-bottom-width')) + parseFloat(@compStyle.getPropertyValue('border-top-width'));

    line_diff = target.value.length - @state.value.length 
    if line_diff < 0 # Removed content
      @shrink = 1
      setTimeout( @startShrinking, 0 )

    new_height = target.scrollHeight + @diff - @shrink

    if new_height >= @state.style.height
      @shrink = 0

    @state.value = target.value
    @state.style.height = new_height
    @setState @state

  startShrinking: ->
    # console.log "Shrinking"
    @resize( React.findDOMNode( @refs.myInput ))
    requestAnimationFrame( @startShrinking ) if @shrink != 0

  render: ->
    <textarea className="form-control" onChange={this.inputHandler} value={this.state.value} style={this.state.style} ref="myInput"/>