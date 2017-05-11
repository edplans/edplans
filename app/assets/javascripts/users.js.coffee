$ ->
  $('tr.admin-user input[type=checkbox]').click ->
    user_id = $(this).parents('tr.admin-user').data('user-id')
    action = if $(this).is(':checked') then 'activate' else 'deactivate'
    $.post "/users/#{ user_id }/#{ action }", { '_method': 'PUT' }

  $('tr.admin-user a.resend').click (ev) ->
    ev.preventDefault()
    url = $(this).attr('href')
    $.post(url, { '_method': 'PUT' }, () ->
      alert("Invitation email has been resent."))

  $('tr.admin-user a.delete').click (ev) ->
    ev.preventDefault()
    url = $(this).attr('href')
    row = $(this).parents('tr.admin-user')
    if confirm("Are you sure you want to delete this user?")
      $.post(url, { '_method': 'DELETE' }, () ->
        row.remove())
