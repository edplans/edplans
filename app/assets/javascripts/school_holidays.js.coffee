class SchoolHoliday extends Backbone.Model
  url: ->
    "#{ @collection.url }/#{ @id }"
  render: ->
    @view ||= new SchoolHolidayView({model: this})
    @view.render()

class SchoolHolidays extends Backbone.Collection
  model: SchoolHoliday
  url: '/my_school/school_holidays'

class SchoolHolidayView extends Backbone.View
  tag: 'li'
  className: 'holiday'
  template: _.template("""
    <%= name %>:
    <%= start_date %>
    <% if (start_date != end_date) { %>
      -<%= end_date %>
    <% } %>
    <a class='delete'>&times;</a>
    """)
  render: ->
    $(@el).html(@template(@model.attributes)).appendTo($('ul.holidays'))
  events: {
    'click a.delete': 'delete'
  }
  delete: ->
    if confirm("Would you like to delete #{ @model.get('name') }?")
      @model.destroy()
      @remove()

window.school_holidays = new SchoolHolidays()

$ ->

  school_holidays.reset(window.initial_school_holidays)
  school_holidays.each((model) ->
    model.render()
  )
