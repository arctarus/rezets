FileInput =
  initialize: ->
    $('input[type=file]').on('change', FileInput.open)
  open: (e) ->
    $this = $(this)
    $label = $this.prev()
    path = $this.val().split('\\')
    filename = path[path.length-1]
    $this.siblings('span.filename').html(filename)

window.FileInput = FileInput
