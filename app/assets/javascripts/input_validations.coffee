jQuery ->
	setInputFilter = (textbox, inputFilter) ->
  [
    'input'
    'keydown'
    'keyup'
    'mousedown'
    'mouseup'
    'select'
    'contextmenu'
    'drop'
  ].forEach (event) ->
    if textbox != null
      textbox.addEventListener event, ->
        if inputFilter(this.value)
          this.oldValue = this.value
          this.oldSelectionStart = this.selectionStart
          this.oldSelectionEnd = this.selectionEnd
        else if this.hasOwnProperty('oldValue')
          this.value = this.oldValue
          this.setSelectionRange this.oldSelectionStart, this.oldSelectionEnd
        return
      return
  return

  #-ve and +ve both
  setInputFilter document.getElementById('intTextBox'), (value) ->
  	/^-?\d*$/.test value

	setInputFilter document.getElementById('uintTextBox'), (value) ->
  	/^\d*$/.test value