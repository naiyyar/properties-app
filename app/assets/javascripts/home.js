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
            hideAutoSearchList('.ui-autocomplete');
            addSearchInputBorderClass()
        }
    });

    $(document).on('keyup', '#search_term, #featured_building_field, #feature_building_as_comp', function(e){
        // e.keyCode != 40 || e.keyCode != 38 for key up / down
        // home page search
        var search_term = $('#search_term, #featured_building_field, #feature_building_as_comp');
        if((e.keyCode != 40 && e.keyCode != 38)){
            if(search_term.val() == ''){
                hideAutoSearchList('.ui-autocomplete');
                addSearchInputBorderClass()
            }
        }
    });

    function addSearchInputBorderClass(){
        var input = $('#search_term');
        if(input.length > 0){
            input.addClass('border-bottom-lr-radius');
        }
    }

    function hideAutoSearchList(klass){
        // setInterval because no match link was not working: hiding too early
        // var ui_complete = mobile ? $('#ui-id-1') : $('#ui-id-2');
        var elem = $(klass);
        setTimeout(function(){
            if(elem.is(":visible")) { elem.hide(); }
            $('.no-match-link').addClass('hidden');
            if(!mobile){
                var ui = $('#ui-id-1');
                var loc_link = ui.find('.location');
                if(loc_link.length == 0){
                    ui.prepend(LOC_LINK.locationLinkLi('ui-menu-item'));
                }
            }
            if(typeof(history_ul) != 'undefined' && history_ul.is(':hidden')){
                history_ul.show();   
            }
        }, 200);
    }
})(jQuery);