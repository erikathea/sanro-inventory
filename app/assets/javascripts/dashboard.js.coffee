# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready  = ->
  if !$.fn.dataTable.isDataTable( ".inventory" )
    if $('.inventory').length > 0
      $('.inventory').DataTable
          sPaginationType: 'full_numbers'
          bJQueryUI: true
          'order': [[0, 'desc']]
          lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]]
          pageLength: 25
          pagingType: 'simple_numbers'
          dom: '<"top"lf>rt<"bottom"ip><"clear">'

  if !$.fn.dataTable.isDataTable( ".receipt" )
    if $('.receipt').length > 0
      $('.receipt').DataTable
          sPaginationType: 'full_numbers'
          bJQueryUI: true
          'order': [[0, 'asc']]
          lengthMenu: [[10, 25, -1], [10, 25, "All"]]
          pageLength: 10
        pagingType: 'simple_numbers'
        dom: '<"top"lf>rt<"bottom"ip><"clear">'

  if !$.fn.dataTable.isDataTable( ".reports" )
    if $('.reports').length > 0
      $report = $('.reports').DataTable
          sPaginationType: 'full_numbers'
          bJQueryUI: true
          'order': [[0, 'asc']]
          paging: false
          searching: false
      new $.fn.dataTable.FixedHeader($report, {bottom: true})

  ### user input must be uppercase ###
  $('input').on('keyup', (e) ->
    this.value = this.value.toUpperCase()
    return
  )

  ### receipt form elements start ###
  if (window.location.pathname.match(/.*receipt.*(new|edit).*/))
    ### datepicker - add/update receipt form ###
    $('.receipt_date_issued').datepicker(
       dateFormat: "dd/mm/yy"
    )

    ### cocoon nested forms ###
    $('.new_receipt').on('cocoon:before-insert', (e, detail) ->
      ### calculate receipt_detail total ###
      $qty_input = $(detail.find('div.qty input'))
      $qty_input.on('focusout', ->
        $row = $(this).parents().closest('tr')
        $total = $row.find('div.total input')[0]

        qty = parseFloat(this.value)
        unit_price = parseFloat($row.find('div.price input')[0].value)
        $total.value = parseFloat(qty * unit_price).toFixed(2)
        $('.new_receipt div.receipt-total input').trigger('change')
        return
      )

      $unit_price_input = $(detail.find('div.price input'))
      $unit_price_input.on('focusout', ->
        $row = $(this).parents().closest('tr')
        $total = $row.find('div.total input')[0]

        qty = parseFloat($row.find('div.qty input')[0].value)
        unit_price = parseFloat(this.value)
        $total.value = parseFloat(qty * unit_price).toFixed(2)
        $('.new_receipt div.receipt-total input').trigger('change')
        return
      )

      ### user input must be uppercase ###
      $(detail.find('input')).each( (index, element) ->
        $(element).on('keyup', (e) ->
          this.value = this.value.toUpperCase()
          return
        )
      )

      ### typeahead js ###
      $.getJSON '/items/descriptions', (data) ->
        tag_input = $(detail.find('div.description input'))
        tag_input.typeahead
          placeholder: tag_input.attr('placeholder')
          displayKey: 'value'
          highlight: true
          hint: true
          source: data
          allowNew: true
        return

      $part_number = $(detail.find('div.part-number input'))
      $part_number.on('focusin', ->
        ### typeahead js ###
        description = $(detail.find('div.description input')).val()
        $.getJSON '/items/part_numbers', {description:description}, (data) ->
          $part_number.typeahead
            placeholder: $part_number.attr('placeholder')
            displayKey: 'value'
            highlight: true
            hint: true
            source: data
            allowNew: true
          return
        return
      )

      ### typeahead js ###
      $.getJSON '/items/ajaxList', (data) ->
        tag_input = $(detail.find('.select-inventory-item'))
        tag_input.typeahead
          placeholder: tag_input.attr('placeholder')
          displayKey: 'value'
          highlight: true
          hint: true
          source: data
          updater: (item) ->
            el_item = this.$element.parent().find('.hidden-item-id')[0]
            el_item.value = item.split('|')[1]
            return item
          allowNew: false
        return

      return
    )

    $('.new_receipt .nested-fields div.qty input').on('change', (e, detail) ->
      $row = $(this).parents().closest('tr')
      $total = $row.find('div.total input')[0]

      qty = parseFloat(this.value)
      unit_price = parseFloat($row.find('div.price input')[0].value)
      $total.value = parseFloat(qty * unit_price).toFixed(2)
      $('.new_receipt div.receipt-total input').trigger('change')
      return
    )

    $('.new_receipt .nested-fields div.price input').on('change', (e, detail) ->
      $row = $(this).parents().closest('tr')
      $total = $row.find('div.total input')[0]

      qty = parseFloat($row.find('div.qty input')[0].value)
      unit_price = parseFloat(this.value)
      $total.value = parseFloat(qty * unit_price).toFixed(2)
      $('.new_receipt div.receipt-total input').trigger('change')
      return
    )


    ### calculate receipt total ###
    $('.new_receipt div.receipt-total input').on('change', ->
      receipt_details = $('.new_receipt .receipt-detail table')
      len = receipt_details.length
      index = 0
      total_amount = parseFloat(0)
      while index < len
        total_amount += parseFloat($(receipt_details[index]).find('div.total input')[0].value)
        ++index
      this.value = parseFloat(total_amount).toFixed(2)
      $('.new_receipt div.receipt-amount-received input').trigger('focusout')
      return
    )

    ### calculate balance ###
    $('.new_receipt div.receipt-amount-received input').on('focusout', ->
      balance = $('.new_receipt div.receipt-balance input')[0]
      total = parseFloat($('.new_receipt div.receipt-total input')[0].value)
      balance.value =  (Number(total).toFixed(2) - Number(this.value).toFixed(2)).toFixed(2)
      return
    )

    ### typeahead js ###
    $.getJSON '/items/descriptions', (data) ->
      tag_input = $('.new_receipt .nested-fields div.description input')
      tag_input.typeahead
        placeholder: tag_input.attr('placeholder')
        displayKey: 'value'
        highlight: true
        hint: true
        source: data
        allowNew: true
      return

    $part_number = $('.new_receipt .nested-fields div.part-number input')
    $part_number.on('focusin', ->
      ### typeahead js ###
      description = $('.new_receipt .nested-fields div.description input').val()
      $.getJSON '/items/part_numbers', {description:description}, (data) ->
        $part_number.typeahead
          placeholder: $part_number.attr('placeholder')
          displayKey: 'value'
          highlight: true
          hint: true
          source: data
          allowNew: true
        return
      return
    )

    ### typeahead js ###
    $.getJSON '/items/ajaxList', (data) ->
      tag_input = $('.new_receipt .nested-fields .select-inventory-item')
      tag_input.typeahead
        placeholder: tag_input.attr('placeholder')
        displayKey: 'value'
        highlight: true
        hint: true
        source: data
        updater: (item) ->
          el_item = this.$element.parent().find('.hidden-item-id')[0]
          el_item.value = item.split(' - ')[2]
          return item
        allowNew: false
      return
  ### receipt form elements end ###

  ### report form elements start ###
  $('.date-month').addClass('hide').hide()
  $('.date-year').addClass('hide').hide()
  $('.report-period').addClass('hide').hide()
  $('.report-type select').on('change', ->
    # reset options
    $('.date-month').removeClass('hide').show()
    $('.date-year').addClass('hide').hide()
    $('.date-quarter').addClass('hide').hide()
    $('.report-period').removeClass('hide').show()
    $('.report-period select').prop('selectedIndex', 0)

    if ($(this).val() == 'Stocks')
      $('.date-month').addClass('hide').hide()
      $('.report-period').addClass('hide').hide()
  )

  $('.report-period').on('change', ->
    # reset options
    $('.date-month').addClass('hide').hide()
    $('.date-quarter').addClass('hide').hide()
    $('.date-year').removeClass('hide').show()

    if ($(this).find('select').val()=='Monthly')
      $('.date-month').removeClass('hide').show()
      $('.date-year').addClass('hide').hide()
    else if ($(this).find('select').val()=='Quarterly')
      $('.date-quarter').removeClass('hide').show()
  )
  ### report form elements end ###

  return

$(document).ready(ready)
$(document).on('page:change', ready)
$(document).on 'page:fetch', ->
  $('main').fadeOut 'slow'

$(document).on 'page:restore', ->
  $('main').fadeIn 'slow'
