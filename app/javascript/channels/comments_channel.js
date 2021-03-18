import consumer from "./consumer";

$(document).on('turbolinks:load', function () {
  if (/questions\/\d+/.test(window.location.pathname)) {
    let template = require('./templates/comments.hbs')
    consumer.subscriptions.create({channel: "CommentsChannel", question_id: gon.question_id}, {
      received(data) {
        if (gon.current_user_id === data.comment.user_id) return;
        let id = data.comment.commentable_type.toLowerCase() + '_' + data.comment.commentable_id + '_comments';
        document.getElementById(id).innerHTML += template(data);
      }
    });
  }
});
