$ ->

  $('[rel=popover]').mouseenter(
    () -> $(this).popover('show')
  ).mouseleave(
    () -> $(this).popover('hide')
  )

  $('.input-append.date').datepicker()

  $('#newSchoolHoliday').on('shown', ->
    $(this).find('.input-append.date').datepicker()
  )

  # Change school year
  $('form#change-school-year select').change ->
    $(this).parent().submit()
  
