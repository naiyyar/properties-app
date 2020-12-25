(function($) {
    "use strict";
    
    if(!(('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch)) {
        $('body').addClass('no-touch');
    }

    setTimeout(function() {
        $('body').removeClass('notransition');
    }, 300);

    $('.dropdown-select li a').click(function() {
        var $self = $(this);
        if (!($self.parent().hasClass('disabled'))) {
            $self.prev().prop("checked", true);
            var parent = $self.parent();
            parent.siblings().removeClass('active');
            parent.addClass('active');
            parent.parent().siblings('.dropdown-toggle').children('.dropdown-label').html($self.text());
        }
    });

    $(document).on('click', function(e){
        e.stopPropagation();
        if(e.target.id != 'search_term' && e.target.id != 'location-link'){
            hideAutoSearchList();
            $('#search_term').addClass('border-bottom-lr-radius');
        }
    })

    $(document).on('keyup', '#search_term', function(e){
        // e.keyCode != 40 || e.keyCode != 38 for key up / down
        // home page search
        var search_term = $('#search_term');
        if((e.keyCode != 40 && e.keyCode != 38)){
            if(search_term.val() == ''){
                hideAutoSearchList();
                // $('#ui-id-1').show();
            }
        }
    });

    function hideAutoSearchList(){
        // setInterval because no match link was not working: hiding too early
        var ui_complete = mobile ? $('#ui-id-1') : $('#ui-id-2');
        setTimeout(function(){
            if(ui_complete.is(":visible")) { ui_complete.hide(); }
            $('.no-match-link').addClass('hidden');
            if(!mobile){
                $('#ui-id-1').prepend(LOC_LINK.locationLinkLi('ui-menu-item'));
            }
            if(typeof(history_ul) != 'undefined' && history_ul.is(':hidden')){
                history_ul.show();   
            }
        }, 200);
    }

    // Searching building on neighborhood click
    var bn = $('.borough-neighborhood')
    if(bn.length > 0){
        bn.click(function(e){
            e.preventDefault();
            $('#neighborhoods').val($(this).text());
            var nbh = $(this).data('nhname');
            var search_btn = $('.search-btn-submit');
            $('#apt-search-txt').val(nbh);
            search_btn.click();
            if(search_btn.length > 0) {
                search_btn.click();
            }
        })
    }

    var panel_collapse = $('.panel-collapse');
    panel_collapse.on('show.bs.collapse', function () {
        $(this).prev().find('span').removeClass('fa-angle-down').addClass('fa-angle-up');
    });

    panel_collapse.on('hide.bs.collapse', function () {
        $(this).prev().find('span').removeClass('fa-angle-up').addClass('fa-angle-down');
    });

    //To changes the size of search field on mobile device orientation changed
    window.addEventListener('resize', function() {
        var homeSearchContainer  = $('.home-search-form  .easy-autocomplete');
        var splitSearchContainer = $('.split-view-seach  .easy-autocomplete');
        setTimeout(function(){
            if(window.innerWidth > 500 && window.innerWidth <= 667){
                homeSearchContainer.css('width','649px');
                splitSearchContainer.css('width','581px');
            }
            else if(window.innerWidth > 667 && window.innerWidth <= 736){
                homeSearchContainer.css('width','715px');
                splitSearchContainer.css('width','646px');
            }
            else if(window.innerWidth == 375){
                homeSearchContainer.css('width','355px');
                splitSearchContainer.css('width','289px');
            }
            else if(window.innerWidth == 414){
                homeSearchContainer.css('width','394px');
                splitSearchContainer.css('width','322px');
            }
        }, 200);
    }, false);
})(jQuery);