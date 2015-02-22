# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.receipts').DataTable
      sPaginationType: 'full_numbers'
      bJQueryUI: true
      'order': [[0, 'desc']]
  $('#receipt_date_issued').datepicker()

  ### user input must be uppercase ###
  $('input').on('keyup', (e) ->
    this.value = this.value.toUpperCase()
    return
  )

  ### calculate receipt_detail total ###
  $('#new_receipt').on('cocoon:after-insert', (e, detail) ->
    $qty_input = $(detail.find('div.qty input'))
    $qty_input.on('focusout', ->
      $row = $(this).parent().parent()
      $total = $row.find('div.total input')[0]

      qty = parseFloat(this.value)
      unit_price = parseFloat($row.find('div.unit_price input')[0].value)
      $total.value = parseFloat(qty * unit_price).toFixed(2)
      $('#new_receipt input#receipt_total').trigger('change')
      return
    )

    $unit_price_input = $(detail.find('div.unit_price input'))
    $unit_price_input.on('focusout', ->
      $row = $(this).parent().parent()
      $total = $row.find('div.total input')[0]

      qty = parseFloat($row.find('div.qty input')[0].value)
      unit_price = parseFloat(this.value)
      $total.value = parseFloat(qty * unit_price).toFixed(2)
      $('#new_receipt input#receipt_total').trigger('change')
      return
    )
  )

  ### calculate receipt total ###
  $('#new_receipt input#receipt_total').on('change', ->
    receipt_details = $('#new_receipt .receipt-detail')
    len = receipt_details.length
    index = 0
    total_amount = parseFloat(0)
    while index < len
      total_amount += parseFloat($(receipt_details[index]).find('div.total input')[0].value)
      ++index
    this.value = parseFloat(total_amount).toFixed(2)
    return
  )

  ### calculate balance ###
  $('#new_receipt input#receipt_amount_received').on('focusout', ->
    balance = $('#new_receipt input#receipt_balance')[0]
    total = parseFloat($('#new_receipt input#receipt_total')[0].value)
    balance.value =  total - parseFloat(this.value)
    return
  )

  return

$(document).ready(ready)
$(document).on('page:load', ready)
