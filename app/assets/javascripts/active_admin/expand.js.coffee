jQuery(document).ready ($) ->
  $('.table_header').on 'click', ->
  	if $('.content').is(':visible')
      $('.table_header').text('Показать список')
      $('.content').removeClass('show_content')
    else
      $('.table_header').text('Убрать список')
      $('.content').addClass('show_content')
