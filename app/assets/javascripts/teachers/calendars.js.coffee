$ ->

  $('#teacher-calendar').fullCalendar({
    events: "/my_calendar/events"
  })

  $('li.domain_unit a').click (ev) ->
    ev.preventDefault()
    $("li.domain_unit a").removeClass('active')
    $(this).addClass('active')
    id = $(this).data('domain-unit-id')
    $('li.lesson_plan').hide()
    $("li.lesson_plan.domain_unit_#{ id }").show()

  $('li.lesson_plan').draggable({
    helper: ->
      "<span data-lesson-plan-id=#{ $(this).data('lesson-plan-id')
#}><i class='icon-bookmark'/>#{ $(this).data('lesson-plan-name') }</span>"
  })

  $('td.fc-day').droppable({
    accept: "li.lesson_plan"
    drop: (ev, ui) ->
      dateString = $(this).data('date')
      params = { scheduled_lesson_plan: { date: dateString, lesson_plan_id: $(ui.draggable).data('lesson-plan-id') } }
      success = (data) ->
        $('#teacher-calendar').fullCalendar('addEventSource', [data])
      $.post("/school_years/#{ window.schoolYearId }/scheduled_lesson_plans", params, success, "json")
  })
