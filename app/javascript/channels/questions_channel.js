import consumer from "./consumer";

$(document).on('turbolinks:load', function () {
  let questionsList = $('#questions');
  consumer.subscriptions.create("QuestionsChannel", {
    received(content) {
      questionsList.append(content).hide().fadeIn();
    }
  });
})
