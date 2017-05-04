!function(i){/**
     * Copyright 2012, Digital Fusion
     * Licensed under the MIT license.
     * http://teamdf.com/jquery-plugins/license/
     *
     * @author Sam Sehnert
     * @desc A small plugin that checks whether elements are within
     *       the user visible viewport of a web browser.
     *       only accounts for vertical position, not horizontal.
     */
i.fn.visible=function(t){var n=i(this),o=i(window),e=o.scrollTop()-150,f=e+o.height(),h=n.offset().top,r=h+n.height(),s=t===!0?r:h,u=t===!0?h:r;return f>=u&&s>=e}}(jQuery);