!function(i){"use strict";"ontouchstart"in window||window.DocumentTouch&&document instanceof DocumentTouch||i("body").addClass("no-touch"),i(".dropdown-select li a").click(function(){i(this).parent().hasClass("disabled")||(i(this).prev().prop("checked",!0),i(this).parent().siblings().removeClass("active"),i(this).parent().addClass("active"),i(this).parent().parent().siblings(".dropdown-toggle").children(".dropdown-label").html(i(this).text()))}),i("#advanced").click(function(){i(".adv").toggleClass("hidden-xs")}),i(".home-navHandler").click(function(){i(".home-nav").toggleClass("active"),i(this).toggleClass("active")}),i(".carousel-inner").swipe({swipeLeft:function(){i(this).parent().carousel("next")},swipeRight:function(){i(this).parent().carousel("prev")}}),i(".modal-su").click(function(){i("#signin").modal("hide"),i("#signup").modal("show")}),i(".modal-si").click(function(){i("#signup").modal("hide"),i("#signin").modal("show")}),i(".swipe-nav").slideAndSwipe()}(jQuery);