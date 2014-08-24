var app = {
  initialize: function () {
    app.bindTweets();
    app.daysListener();
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
        $('html, body').animate({ scrollTop: $(this).offset().top - 40 }, 'fast');
      }
    });
  }
}

$(function () {
  app.initialize();
})
