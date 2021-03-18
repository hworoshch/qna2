$(document).on('turbolinks:load', function(){
    $('.add-comment').on('click', function(e){
        e.preventDefault();
        $(this).hide();
        var commentable = $(this).data('commentable');
        $('form#comment-form-' + commentable).removeClass('hidden');
    });
});
