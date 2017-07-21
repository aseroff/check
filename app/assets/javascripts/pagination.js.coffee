jQuery ->
  if $('#infinite-scrolling').size() > 0
    $(window).on 'scroll', ->
      more_posts_url = $('.pagination .next_page').attr('href')
      if more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 100
          $('.pagination').html('<img src="/assets/images/ajax-loader.gif" alt="Loading..." title="Loading..." />')
          $.getScript more_posts_url
      return
    return