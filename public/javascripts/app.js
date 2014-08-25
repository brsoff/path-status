var app = {
  initialize: function () {
    app.bindTweets();
    app.daysListener();
    app.filterPhrase();
    app.bindUnfilter();
  },

  daysListener: function () {
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

          app.bindTweets();
          app.filterPhrase();
          app.bindUnfilter();
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
        $('html, body').animate({ scrollTop: $(this).offset().top - 165 }, 'fast');
      }
    });
  },

  filterPhrase: function () {
    $('*[data-behavior="filter-phrase"]').on('click', function () {
      var phrase = $(this).text();

      var tweets = $.grep($('*[data-target="phrases"]'), function (el) {
        return (new RegExp(phrase).test(el.innerText) === true)
      })

      $('.day').hide();
      $('.tweet-details').hide();

      for (var i = 0; i < tweets.length; i++) {
        $(tweets[i]).closest('.day').show();
        $(tweets[i]).closest('.tweet-details').show();
      }

      $('.messages').show().find('.message').text('Filtering by: "' + phrase + '"');
    });
  },

  bindUnfilter: function () {
    $('*[data-behavior="unfilter"]').on('click', function () {
      $('.messages').hide().find('.message').empty();
      $('.day').show();
      $('.tweet-details').show();
      $('.tweets').hide();
    });
  }
}

$(function () {
  app.initialize();
})
