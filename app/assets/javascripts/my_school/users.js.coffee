$ ->
  $('tr.user input[type=radio]').click ->
    user_id = $(this).parents('tr.user').data('user-id')
    action = $(this).val()
    $.post "/my_school/users/#{ user_id }/#{ action }", { '_method': 'PUT' }

  $('tr.user input[type=checkbox]').click ->
    user_id = $(this).parents('tr.user').data('user-id')
    action = if $(this).is(':checked') then 'activate' else 'deactivate'
    $.post "/my_school/users/#{ user_id }/#{ action }", { '_method': 'PUT' }