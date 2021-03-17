import consumer from "./consumer";

$(document).on('turbolinks:load', function () {
  if (/questions\/\d+/.test(window.location.pathname)) {
    let answersList = $('.answers');
    let template = require('./templates/answers.hbs')
    consumer.subscriptions.create({ channel: 'AnswersChannel', question_id: gon.question_id }, {
      received(data) {
        if (gon.current_user_id === data.answer.user_id) return;
        answersList.append(template(data));
      }
    });
  }
})