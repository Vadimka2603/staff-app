jQuery(document).ready ($) ->
  $('.table_header').on 'click', ->
  	if $('.content').hasClass('show_content')
      $(this).text('Показать список')
      $(this).next('.content').removeClass('show_content')
    else
      $(this).text('Убрать список')
      $(this).next('.content').addClass('show_content')
