class ScheduledDomain extends Backbone.Model
  coordinates: ->
    @view && [@view.el.offsetLeft, @view.el.offsetTop, @view.width()]
  endWeek: ->
    @get('start_week') + @get('weeks') - 1
  abbreviateDomainName: (width) ->
    name = if @get('domain_name').length < width / 9
      @get('domain_name')
    else
      @get('domain_name')[0..(width / 9)] + "..."
    if @get('days')
      name = name + " (#{ @get('days') })"
    @set('abbreviated_domain_name', name)
  render: ->
    @view ||= new DynamicScheduledDomainView({model: this})
    @view.render()

class ScheduledDomains extends Backbone.Collection
  model: ScheduledDomain
  url: '/my_school/scheduled_domains'
  removeByName: (name) =>
    @each (model) =>
      if model.get('name') == name
        $(model.view.el).remove()
        @remove(model)

class ScheduledDomainView extends Backbone.View
  className: 'scheduled-domain'
  template: JST['views/scheduled_domain']
  events:
    'click .unschedule-domain': 'destroy'
  width: ->
    @finalizeRight() - @offsetLeft() - 10
  calendarRow: ->
    $("table.calendar tr.subject-#{ @model.get('subject_id') }:visible")[0]
  offsetTop: ->
    # Start at the top
    potential = @calendarRow().offsetTop + 5

    # Memoize the bottom of the current row in case it needs expanded
    bottom = @calendarRow().offsetTop + $(@calendarRow()).height()

    # Look for overlaps
    @model.
      collection.
      chain().
      filter((m) => m.get('subject_id') == @model.get('subject_id')).
      filter((m) => m.coordinates()).
      sortBy((m) => m.coordinates()[1]).
      map((m) => m.coordinates()).
      each (co) =>

        # Find coordinates of scheduled domain, check to see if they match
        if co[1] == potential && (co[0] <= @offsetLeft() <= co[0] + co[2] || @offsetLeft() <= co[0] <= @offsetLeft() + @width())

          # If we have a match, add 25px to our top offset
          potential += 25

          # If the new offset will overlap the bottom of the row, stretch the row
          if bottom < potential + 25
            $(@calendarRow()).attr("style", "height: #{ potential - @calendarRow().offsetTop + 25 }px;")


    if potential >= bottom
      # Re-render all rows below us, because the positions will have changed
      @model.collection.each (s) =>
        if s.get('subject_position') > @model.get('subject_position')
          s.render() 

    potential
  offsetLeft: ->
    cell = $("td.week-title#week-#{ @model.get('start_week') }:visible")[0]
    if cell
      cell.offsetLeft
    else
      $("th.subject-header:visible")[0].offsetWidth
  finalizeRight: ->
    cell = $("table.calendar:visible td.week-title#week-#{ @model.endWeek() }")[0]
    if cell
      cell.offsetLeft + cell.offsetWidth
    else
      table = $('table.calendar:visible')[0]
      table.offsetLeft + table.offsetWidth
  month: ->
    $('table.calendar:visible').data('month')
  isVisible: () ->
    _.any @model.get('weeks_taught'), (week) ->
     $("td#week-#{ week }").is(":visible")
  render: ->
    if @isVisible()
      @model.abbreviateDomainName(@width())
      $(@el).html(@template(@model.attributes))
      if @model.get('domain_is_course_unit')
        $(@el).addClass('custom-course-unit')
      $(@el).
        attr("style", "position: absolute; z-index: 8; left: #{ @offsetLeft() }px; top: #{ @offsetTop() }px; width: #{ @width() }px;").
        data('scheduled-domain-id', @model.id).
        appendTo(".scheduled-domains.month-#{ @month() }")
        $(@el).mouseenter( () ->
          $(this).find('a.unschedule-domain').show()
        ).mouseleave( () ->
          $(this).find('a.unschedule-domain').hide()
        )
  destroy: (ev) ->
    ev.preventDefault()
    if confirm("Are you sure you want to unschedule #{ @model.get('domain_name') }?")
      @model.destroy()
      $(@el).fadeOut('fast').remove()

class DynamicScheduledDomainView extends ScheduledDomainView
  render: ->
    super
    $(@el).draggable()

class StaticScheduledDomainView extends ScheduledDomainView
  className: 'scheduled-domain static'
  template: JST['views/static_scheduled_domain']
  destroy: undefined
  events: {}

class StaticScheduledDomain extends ScheduledDomain
  render: ->
    @view ||= new StaticScheduledDomainView({model: this})
    @view.render()

class StaticScheduledDomains extends Backbone.Collection
  model: StaticScheduledDomain

window.scheduled_domains = new ScheduledDomains()
window.static_scheduled_domains = new StaticScheduledDomains()

$ ->

  resetDomains = (data) ->
    domains.reset(data)
    domains.each (model) ->
      model.render()
    $('tr.grade-header:not(.tag-core-knowledge)').find('a').trigger('click')

  resetScheduledDomains = (data) ->
    scheduled_domains.reset(data)
    if location.hash != ''
      $('a[href="'+location.hash+'"]').trigger 'click'
    else
      $('a.show-month:first').trigger 'click'

  loadDomainData = (grade) ->
    $.get("/curriculum/plan/#{ grade }/domains", {}, resetDomains, 'json')

  window.loadScheduledDomainData = (grade, schoolYearId) ->
    $.get("/curriculum/plan/#{ grade }/scheduled_domains", {'school_year_id': schoolYearId}, resetScheduledDomains, 'json')

  loadAllDomainData = () ->
    grade = $('span#grade').data('grade')
    if grade?
      loadDomainData(grade)
      loadScheduledDomainData(grade, window.schoolYearId)

  setTimeout(loadAllDomainData, 500)

  renderScheduledDomains = (month) ->
    $('.scheduled-domains').html('')
    scheduled_domains.
      chain().
      sortBy((m) => m.get('subject_position')).
      each (sd) ->      
        sd.render()

  $('a.domain-collapse').click ->
    $($(this).data('target')).toggle('fast')

  $('a.show-month').click (ev) ->
    month = $(this).data('month')
    $.post("/my_calendar/#{ window.schoolYearId }/#{ $(this).attr('href').slice(1) }")
    $("table.calendar").hide()
    $("div.scheduled-domain").remove()
    $("table.calendar.month-#{ month }").show()
    $("ul#months li").removeClass("active")
    $("li#month-tab-#{ month }").addClass("active")
    renderScheduledDomains(month)

  $(document).on 'click', 'a.toggle-domain-folder', (ev) ->
    ev.preventDefault()
    toggleTag = $(this).data('toggle-tag')
    toggleGrade = $(this).data('toggle-grade')
    folder = $(this).parent('th').find('i')
    if folder.hasClass('icon-folder-open')
      folder.removeClass('icon-folder-open').addClass('icon-folder-close')
    else
      folder.removeClass('icon-folder-close').addClass('icon-folder-open')
    $("tr.#{ toggleGrade }.#{ toggleTag }:not(.grade-header)").toggle('fast')

  $('tr.custom-domain a').click ->
    grade = $(this).data('grade')
    $("select#domain_grade option[value=#{ grade }]").attr('selected', 'selected')

  _.each $('td.week-cell'), (cell) ->
    grade = $(cell).data('grade')
    $(cell).droppable(
      accept: "span.grade-#{ grade }, div.scheduled-domain"
      hoverClass: 'ui-state-highlight'
      drop: (event, ui) ->
        if $(ui.draggable).hasClass('domain')
          scheduled_domains.create({
            domain_id: $(ui.draggable).data('domain-id')
            subject_id: $(this).data('subject-id')
            grade: $(this).data('grade')
            start_week: $(this).data('week')
            school_year_id: window.schoolYearId
          }, {
            wait: true
            success: (domain) -> domain.render()
          })
        else
          scheduledDomain = scheduled_domains.get($(ui.draggable).data('scheduled-domain-id'))
          scheduledDomain.set
            subject_id: $(this).data('subject-id')
            grade: $(this).data('grade')
            start_week: $(this).data('week')
          scheduledDomain.save()
          scheduledDomain.render()
    )
