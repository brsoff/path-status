var app = {
  bind: function () {
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
  app.bind();
})
