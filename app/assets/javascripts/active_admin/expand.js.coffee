jQuery(document).ready ($) ->
  $('.table_header').on 'click', ->
  	if $(this).next('.content').hasClass('show_content')
      $(this).text('Показать список')
      $(this).next('.content').removeClass('show_content')
    else
      $(this).text('Убрать список')
      $(this).next('.content').addClass('show_content')
