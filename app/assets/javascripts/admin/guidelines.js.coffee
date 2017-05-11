class KnowledgeConnection extends Backbone.Model
  render: () ->
    @view ||= new KnowledgeConnectionView({model: this})
    @view.render()

class KnowledgeConnections extends Backbone.Collection
  model: KnowledgeConnection

class KnowledgeConnectionView extends Backbone.View
  className: 'knowledge-connection'
  tagName: 'li'
  template: _.template("<%= name %> <a href='#' class='destroy-connection'>&times;</a>")
  parentContainer: () ->
    if @model.get('prior_knowledge_id')?
      $('td#prior-knowledge ul')
    else if @model.get('future_knowledge_id')?
      $('td#future-knowledge ul')
    else
      $('td#cross-curricular ul')
  render: () ->
    $(@el).html @template(@model.attributes)
    @parentContainer().append @el
  events:
    'mouseenter': 'showDisconnect'
    'mouseleave': 'showDisconnect'
    'click a.destroy-connection': 'disconnect'
  showDisconnect: ->
    $(@el).find('a.destroy-connection').toggle()
  disconnect: (ev) ->
    ev.preventDefault()
    @model.destroy()
    $(@el).remove()

class StandardApplication extends Backbone.Model
  render: ->
    @view ||= new StandardApplicationView({model: this})
    @view.render()

class StandardApplications extends Backbone.Collection
  model: StandardApplication

class StandardApplicationView extends Backbone.View
  className: 'standard-application'
  tagName: 'li'
  template: JST['views/standard_application']
  parentContainer: ->
    $('td#standard-applications ul')
  render: ->
    $(@el).html @template(@model.attributes)
    $("li.standard[data-standard-id=#{ @model.get('standard_id') }]").hide().addClass('applied')
    @parentContainer().append @el
  events:
    'mouseenter': 'showDisconnect'
    'mouseleave': 'showDisconnect'
    'click a.destroy-application': 'disconnect'
  showDisconnect: ->
    $(@el).find('a.destroy-application').toggle()
  disconnect: (ev) ->
    ev.preventDefault()
    $("li.standard[data-standard-id=#{ @model.get('standard_id') }]").show().removeClass('applied')
    @model.destroy()
    $(@el).remove()
    
class DomainApplication extends Backbone.Model
  render: ->
    @view ||= new DomainApplicationView({model: this})
    @view.render()

class DomainApplications extends Backbone.Collection
  model: DomainApplication
  
class DomainApplicationView extends Backbone.View
  className: 'domain-application'
  tagName: 'li'
  template: _.template("<%= domain_name %> <a href='#' class='destroy-application'>&times;</a>")
  parentContainer: ->
    $('td#domain-applications ul')
  render: ->
    $(@el).html @template(@model.attributes)
    $("li.domain[data-domain-id=#{ @model.get('domain_id') }]").hide()
    @parentContainer().append @el
  events:
    'mouseenter': 'showDisconnect'
    'mouseleave': 'showDisconnect'
    'click a.destroy-application': 'disconnect'
  showDisconnect: ->
    $(@el).find('a.destroy-application').toggle()
  disconnect: (ev) ->
    ev.preventDefault()
    $("li.domain[data-domain-id=#{ @model.get('domain_id') }]").show()
    @model.destroy()
    $(@el).remove()

$ () ->

  window.knowledgeConnections = new KnowledgeConnections()
  knowledgeConnections.url = "/admin/guidelines/#{ window.guidelineId }/knowledge_connections"
  knowledgeConnections.reset window.initialKnowledgeConnections
  knowledgeConnections.each (kc) ->
    kc.render()

  $('a.knowledge-connection').draggable(
    helper: 'clone'
  )

  $('td#prior-knowledge').droppable(
    accept: 'a.knowledge-connection'
    hoverClass: 'ui-state-highlight'
    drop: (event, ui) ->
      knowledgeConnections.create({
        knowledge_connection: {
          prior_knowledge_id: $(ui.draggable).data('knowledge-id')
          prior_knowledge_type: $(ui.draggable).data('knowledge-type')
        }
      }, {
        wait: true
        success: (knowledgeConnection) ->
          knowledgeConnection.render()
      })
  )

  $('td#future-knowledge').droppable(
    accept: 'a.knowledge-connection'
    hoverClass: 'ui-state-highlight'
    drop: (event, ui) ->
      knowledgeConnections.create({
        future_knowledge_id: $(ui.draggable).data('knowledge-id')
        future_knowledge_type: $(ui.draggable).data('knowledge-type')
      }, {
        wait: true
        success: (knowledgeConnection) ->
          knowledgeConnection.render()
      })
  )


  $('td#cross-curricular').droppable(
    accept: 'a.knowledge-connection'
    hoverClass: 'ui-state-highlight'
    drop: (event, ui) ->
      knowledgeConnections.create({
        cross_knowledge_id: $(ui.draggable).data('knowledge-id')
        cross_knowledge_type: $(ui.draggable).data('knowledge-type')
      }, {
        wait: true
        success: (knowledgeConnection) ->
          knowledgeConnection.render()
      })
  )

  window.domainApplications = new DomainApplications()
  domainApplications.url = "/admin/guidelines/#{ window.guidelineId }/domain_applications"
  domainApplications.reset window.initialDomainApplications
  domainApplications.each (da) ->
    da.render()

  $('li.domain').draggable(
    helper: 'clone'
  )

  $('td#domain-applications').droppable(
    accept: 'li.domain'
    hoverClass: 'ui-state-highlight'
    drop: (event, ui) ->
      domainApplications.create({
        domain_id: $(ui.draggable).data('domain-id')
      }, {
        wait: true
        success: (domainApplication) ->
          domainApplication.render()
      })
  )

  window.standardApplications = new StandardApplications()
  standardApplications.url = "/admin/guidelines/#{ window.guidelineId }/standard_applications"
  standardApplications.reset window.initialStandardApplications
  standardApplications.each (sa) ->
    sa.render()

  $('td#standard-applications').droppable(
    accept: 'li.standard'
    hoverClass: 'ui-state-highlight'
    drop: (event, ui) ->
      standardApplications.create({
        standard_id: $(ui.draggable).data('standard-id')
      }, {
        wait: true
        success: (standardApplication) ->
          standardApplication.render()
      })
  )
      