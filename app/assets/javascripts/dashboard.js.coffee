# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.receipts').DataTable
      sPaginationType: 'full_numbers'
      bJQueryUI: true
      'order': [[0, 'desc']]
  $('#receipt_date_issued').datepicker()

  $('input').on('keyup', (e) ->
    this.value = this.value.toUpperCase()
    return
  )
  return

$(document).ready(ready)
$(document).on('page:load', ready)
