var app = {
  bind: function () {
    $('*[data-behavior="show-tweets"]').on('click', function () {
      var tweets = $(this).parent().find('.tweets');
      tweets.is(':visible') ? tweets.hide('fast') : tweets.show('fast');

      $('html, body').animate({ scrollTop: $(this).offset().top - 40 }, 'fast');
    });
  }
}

$(function () {
  app.bind();
})
