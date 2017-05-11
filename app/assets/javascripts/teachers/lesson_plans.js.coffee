$ ->

  subAndSuperscript = {
    "font-styles": (locale, options) ->
      "<a class='btn' data-wysihtml5-command='subscript'><sub>sub</sub></a><a class='btn' data-wysihtml5-command='superscript'><sup>super</sup></a>"
  }


  wysi = () ->
    $('textarea.wysiwyg').each (i, el) ->
      $(el).wysihtml5(
        image: false
        lists: false
        link: $(el).parents('form').is('.lesson-plan')
        customTemplates: subAndSuperscript
      )
    iframeFocus = () ->
      $('iframe').each (i, el) ->
        helpBlock = $(el).siblings('.help-block')
        $(el).contents().find('body').focus ->
          helpBlock.show()
        $(el).contents().find('body').blur ->
          helpBlock.hide()
    setTimeout iframeFocus, 1000
    
  setTimeout wysi, 10

  $('form.check_sub_guideline input[type=checkbox]').click () ->
    method = if $(this).is(':checked') then 'put' else 'delete'
    $.post $(this).parent('form').attr('action'), {'_method': method}

  $('a.collapse-guidelines').click () ->
    $("##{ $(this).data('collapse') }").children(':not(h3)').toggle()
