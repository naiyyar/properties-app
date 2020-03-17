$(document).ready(function(){
    // Exapnd left side navigation
    var windowWidth = $(window).width();
    var isDevice = true;
    if(!(('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch)) {
        $('body').addClass('no-touch');
        isDevice = false;
    }

    var navExpanded = false;
    $('.navHandler, .closeLeftSide, .home-navHandler').click(function(e) {
        e.preventDefault()
        if(!navExpanded) {
            $('.logo').addClass('expanded');
            $('#leftSide').addClass('expanded');
            if(windowWidth < 768) {
                $('.closeLeftSide').show();
            }
            $('.hasSub').addClass('hasSubActive');
            $('.leftNav').addClass('bigNav');
            if(windowWidth > 767) {
                $('.full').addClass('m-full');
            }
            navExpanded = true;
        } else {
            $('.logo').removeClass('expanded');
            $('#leftSide').removeClass('expanded');
            $('.closeLeftSide').hide();
            $('.hasSub').removeClass('hasSubActive');
            // $('.bigNav').slimScroll({ destroy: true });
            $('.leftNav').removeClass('bigNav');
            $('.leftNav').css('overflow', 'visible');
            $('.full').removeClass('m-full');
            navExpanded = false;
        }
    });

    // Expand left side sub navigation menus
    $(document).on("click", '.hasSubActive', function() {
        $(this).toggleClass('active');
        $(this).children('ul').toggleClass('bigList');
        $(this).children('a').children('.arrowRight').toggleClass('fa-angle-down');
    });

    if(isDevice) {
        $('.hasSub').click(function() {
            $('.leftNav ul li').not(this).removeClass('onTap');
            $(this).toggleClass('onTap');
        });
    }

    // leftSide
    $(document).click(function(e){
        var target_class = e.target.className;
        var container = $('.leftNav');
        if( target_class !== "fa fa-bars" && 
            target_class != 'ssm-toggle-nav1' && 
            target_class != 'navLabel' &&
            target_class != 'fa fa-chevron-right' && 
            target_class != 'fa fa-chevron-left') {
            if(!container.is(e.target) && container.has(e.target).length === 0) {
                $('#leftSide').removeClass('expanded');
                $('.logo').removeClass('expanded');
            }
        }
    });
    
    $('.auth').on('click', function(){
        $('#leftSide').removeClass('expanded');
    });
    
});