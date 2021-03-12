$(document).on('turbolinks:load', function() {
    $('.votes').on('click', function(e) {
        return $('#flash_messages').html('');
    });
    return $('.votes').on('ajax:success', function(e) {
        var vote;
        vote = e.detail[0];
        return $('#' + vote.model + '-' + vote.object_id + ' .votes-count').html(vote.value);
    }).on('ajax:error', function(e) {
        var errors;
        errors = e.detail[0];
        return $.each(errors, function(_field, array) {
            return $.each(array, function(_index, value) {
                return $('#flash_messages').append('<div class="flash-alert">' + value + '</div>');
            });
        });
    });
});