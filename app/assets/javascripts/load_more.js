// when the page is ready for manipulation
$(document).ready(function () {
    // when the load more link is clicked
    $('a.load-more').click(function (e) {
        var last_date_active = null;
        var last_id          = null;
        var loaded_ids       = [];
        var past_listings_count    = $('#past_listings_count').val();
        var total_reviews          = $('#total_reviews').val();
        var loaded_listings_count;
        // prevent the default click action
        e.preventDefault();

        // hide load more link
        $('.load-more').hide();

        // show loading gif
        $('.loading-gif').show();

        // get the last id and save it in a variable 'last_id'
        if($(this).hasClass('past-listings')){
            last_date_active = $('.listings-record').last().attr('data-date-active');
            $('#past-listings .listings-record').each(function(i, j){
                loaded_ids.push(parseInt($(j).attr('data-id')));
            });
        }else{
            last_id = $('.record').last().attr('data-id');
        }
        
        // make an ajax call passing along our last user id
        $.ajax({

            // make a get request to the server
            type: "GET",
            // get the url from the href attribute of our link
            url: $(this).attr('href'),
            // send the last id to our rails app
            data: {
                object_id:   last_id,
                date_active: last_date_active,
                loaded_ids:  loaded_ids
            },
            // the response will be a script
            dataType: "script",

            // upon success 
            success: function () {
                // hide the loading gif
                $('.loading-gif').hide();
                // show our load more link
                $('.load-more').show();
                loaded_listings_count  = $('#past-listings .listings-record').length;
                //hiding show more button when no review left to load
                if(total_reviews == $('.comment.record').length || loaded_listings_count == past_listings_count){
                    $('a.load-more').hide();
                }
            }
        });

    });
});