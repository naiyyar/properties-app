(function(){$(document).on("click",".add_new_building",function(e){var i;return e.preventDefault(),i=$("#buildings-search-txt").val(),""===i?$("#buildings-search-txt").parent().addClass("has-error"):($("#search-form").addClass("hide"),$("#new_building").removeClass("hide"),$("#building_building_street_address").val(i)),1===$("#units-search-txt").length?$("#units-search-txt").remove():void 0}),$(document).on("click","#submit_review",function(e){var i,t,s,a,n,r,l;return r=$("input[name='score']").val(),n=$(".reviewer_type").hasClass("active"),s=$("#review_stay_time option:selected").val(),a=$("#review_review_title").val(),t=$("#review_pros").val(),i=$("#review_cons").val(),l=!1,""===r?(e.preventDefault(),$(".rating-not-selected").removeClass("hide"),l=!1):($(".rating-not-selected").addClass("hide"),l=!0),n?($(".status-not-selected").addClass("hide"),l=!0):($(".status-not-selected").removeClass("hide"),l=!1),""===s?"visitor"!==$(".reviewer_status:checked").val()&&($(".years-not-selected").removeClass("hide"),l=!1):($(".years-not-selected").addClass("hide"),l=!0),""===a?($(".title_blank").removeClass("hide"),l=!1):($(".title_blank").addClass("hide"),l=!0),""===t?($(".pros_blank").removeClass("hide"),l=!1):($(".pros_blank").addClass("hide"),l=!0),""===i?($(".cons_blank").removeClass("hide"),l=!1):($(".cons_blank").addClass("hide"),l=!0),$("input[name=vote]").is(":checked")===!1?($(".recommend-not-selected").removeClass("hide"),l=!1):($(".recommend-not-selected").addClass("hide"),l=!0),l}),$(document).on("click","#add_new_unit",function(e){var i;return e.preventDefault(),i=$("#units-search-txt").val(),$("#unit_id").val(""),$("#unit_name").val(i),$("#unit_square_feet").val(""),$("#unit_number_of_bedrooms").val(""),$("#unit_number_of_bathrooms").val(""),$("#new_unit_building").removeClass("hide"),$(".new_unit_lbl").hasClass("hide")&&$(".new_unit_lbl").removeClass("hide"),$(".square_feet_help_block").hasClass("hidden")&&($(".square_feet_help_block").removeClass("hidden"),$(".square_feet_help_block").css("visibility","hidden")),$(".unit-search").addClass("hide"),$("#unit_name").parent().parent().hasClass("hide")?$("#unit_name").parent().parent().removeClass("hide"):void 0}),$(document).on("click","input[name='contribute_to']",function(){var e,i,t,s,a,n,r;return a='<input name="units-search-txt" id="units-search-txt" type="text" class="unit-search form-control" placeholder="Search unit number" readonly="readonly"/>',n=$(".unit-search").find(".form-group").find("input"),r=$("#user_id").val(),0!==$(".search-no-result li").length&&$(".search-no-result li").hide(),$("#buildings-search-txt").parent().hasClass("has-error")&&$("#buildings-search-txt").parent().removeClass("has-error"),"unit_review"!==this.value&&"unit_photos"!==this.value&&"unit_amenities"!==this.value&&"unit_price_history"!==this.value?($("#search-form").removeClass("hide"),$("#buildings-search-txt").val(""),t=$("#next_btn"),t.length>0&&t.addClass("hidden"),i=$("#next_to_review_btn"),s='<a id="next_to_review_btn" class="btn btn-primary add_new_building" href="javascript:;">Next</a>',0===i.length&&$(".next_btn_container").append(s),$(".unit-search").addClass("hide"),$("#new_unit_building").addClass("hide"),$("#new_building").addClass("hide"),$(".building_contribution").val(this.value),"building_review"===this.value?e="/reviews/new":"building_photos"===this.value&&(e=""!==r?"/uploads/new":"/users/sign_in"),$("#search_item_form").attr("action",e)):(""!==$("#units-search-txt").val()&&$("#units-search-txt").val(""),$("#new_unit_building").hasClass("hide")||$("#new_unit_building").addClass("hide"),$(".unit-search").removeClass("hide").attr("readonly","readonly"),$("#next_btn").addClass("hidden"),$("#next_to_review_btn").remove(),$("#buildings-search-txt").val(""),$("#buildings-search-no-results > li.no-result-li").hide(),$("#unit_contribution").val(this.value),$("#new_building").hasClass("hide")||$("#new_building").addClass("hide"),$("#contribution").val(this.value),$("#new_building_submit").val("Submit"),$("#search-form").hasClass("hide")&&($("#search-form").removeClass("hide"),$("#buildings-search-txt").val(""),$(".no-result-li").hide()),0===n.length?$(".unit-search").find(".form-group").append(a):void 0)}),$(document).on("click","#elevator",function(){return $("#building_elevator").toggleClass("hide"),$("#building_elevator").hasClass("hide")?$("#building_elevator").val(""):void 0}),$(document).on("click",".reviewer_type",function(){var e;return e=$(this).children().attr("id"),"visitor"!==e?($("#review_stay_time").removeClass("hide"),$("#review_stay_time").prev().show(),$("#review_stay_time").next().show()):($("#review_stay_time").addClass("hide"),$("#review_stay_time").next().hide(),$("#review_stay_time").prev().hide(),$("#review_stay_time").data("validate")?$("#review_stay_time").removeAttr("data-validate"):void 0)}),$(document).on("keypress","form",function(e){return 13===e.keyCode?!1:void 0})}).call(this);