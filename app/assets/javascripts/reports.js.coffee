$ ->

  $('#format').change () ->
    timelineOption = $('select#report_style option[value=Timeline]')
    if $(this).val() == 'pdf'
      timelineOption.attr('disabled', true)
      $('select#report_style option[value=Table]').prop('selected', true)
    else
      timelineOption.attr('disabled', null)