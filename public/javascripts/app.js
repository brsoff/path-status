var app = {
  bind: function () {
    app.bindTweets();
    app.dateSelect();
    app.filterByPhrase();
    app.unfilter();
    app.nodes();
  },

  dateSelect: function () {
    $('*[data-target="days"]').on('change', function () {
      var selected = { days: $(this).val() };

      $.ajax({
        method: 'get',
        data: selected,
        url: '/',
        success: function (data) {
          $('.dummy').html(data);

          var feed = $('.dummy .feed').html();
          var stats = $('.dummy .stats').html();

          $('.main .feed').html(feed);
          $('.sidebar .stats').html(stats);

          $('.dummy').empty();

          app.bind();
        }
      });
    });
  },

  bindTweets: function () {
    $('*[data-behavior="show-tweets"]').on('click', function () {
      var tweets = $(this).parent().find('.tweets');

      if (tweets.is(':visible')) {
        tweets.hide('fast')
      } else {
        tweets.show('fast');
        $('html, body').animate({ scrollTop: $(this).offset().top - 175 }, 'fast');
      }
    });
  },

  filterByPhrase: function () {
    $('*[data-behavior="filter-phrase"]').on('click', function () {
      var phrase = $(this).text();

      var tweets = $.grep($('*[data-target="phrases"]'), function (el) {
        return (new RegExp(phrase).test(el.innerText) === true)
      });

      $('.day').hide();
      $('.tweet-details').hide();

      for (var i = 0; i < tweets.length; i++) {
        $(tweets[i]).closest('.day').show();
        $(tweets[i]).closest('.day .tweets').show();
        $(tweets[i]).closest('.tweet-details').show();
      }

      if (tweets.length < 1) {
        $('.messages').show().find('.message').text('No tweets found with "' + phrase + '" in this date range');
        $('.messages').addClass('no-phrases');
      } else {
        $('.messages').removeClass('no-phrases');
        $('.messages').show().find('.message').text('Filtering by: "' + phrase + '"');
      }
    });
  },

  unfilter: function () {
    $('*[data-behavior="unfilter"]').on('click', function () {
      $('.messages').hide().find('.message').empty();
      $('.day').show();
      $('.tweet-details').show();
      $('.tweets').hide();
    });
  },

  nodes: function () {
    $('*[data-target="node"]').hover(function () {
      var node_id = $(this).index();
      var tweet = $(this).closest('.bar').closest('.day').find('.tweet-details')[node_id].innerHTML;

      $(this).find('.node-hover').html(tweet).show();
    }, function () {
      $(this).find('.node-hover').empty().hide();
    })
  }
}

$(function () {
  app.bind();
})
