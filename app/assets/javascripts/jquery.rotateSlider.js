(function($) {
  $.fn.rotateSlider = function(opt) {
    var $this = this,
        itemClass = opt.itemClass || 'rotateslider-item',
        arrowClass = opt.arrowClass || 'js-rotateslider-arrow',
        $item = $this.find('.' + itemClass),
        $arrow = $this.find('.' + arrowClass),
        itemCount = $item.length;


    var defaultIndex = 0;
    changeIndex(defaultIndex);
    
    $item.on('mouseenter', function(){
      $(this).css({'transform': 'translateY(-50%) translateX(-50%) scale(1.1, 0.7)', 'z-index': 9999});
      if(!$(this).hasClass('now')){
        $item.filter('.now').css({'transform': 'translateY(-50%) translateX(-50%) scale(0.9, 0.6)','z-index': 0});
      }
      //console.log($(this).hasClass('now'))
      //console.log($(this))
    }).on('mouseleave', function(){
      $item.filter('.now').css({'transform': 'translateY(-50%) translateX(-50%) scale(1.1, 0.7)', 'z-index': 9999});
      if(!$(this).hasClass('now')){
        $(this).css({'transform': 'translateY(-50%) translateX(-50%) scale(0.9, 0.6)','z-index': 0});
      }
    })

    $arrow.on('click', function() {
      var action = $(this).data('action'),
        nowIndex = $item.index($this.find('.now'));
        $item.attr('style', ''); // To remove style on next, prev click
      if(action == 'next') {
        if(nowIndex == itemCount - 1) {
          changeIndex(0);
        } else {
          changeIndex(nowIndex + 1);
        }
      } else if (action == 'prev') {
        if(nowIndex == 0) {
          changeIndex(itemCount - 1);
        } else {
          changeIndex(nowIndex - 1);
        }
      }
    });

    function changeIndex (nowIndex) {
      // clern all class
      $this.find('.now').removeClass('now');
      $this.find('.next').removeClass('next');
      $this.find('.prev').removeClass('prev');
      if(nowIndex == itemCount - 1){
        $item.eq(0).addClass('next');
      }
      if(nowIndex == 0) {
        $item.eq(itemCount - 1).addClass('prev');
      }

      $item.each(function(index) {
        if(index == nowIndex) {
          $item.eq(index).addClass('now');
        }
        if(index == nowIndex + 1 ) {
          $item.eq(index).addClass('next');
        }
        if(index == nowIndex - 1 ) {
          $item.eq(index).addClass('prev');
        }
      });
    }
  };
})(jQuery);
