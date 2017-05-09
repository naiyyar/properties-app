/**
 * Slide and swipe menu (https://github.com/JoanClaret/slide-and-swipe-menu)
 *
 * @copyright Copyright 2013-2015 Joan claret
 * @license   MIT
 * @author    Joan Claret Teruel <dpam23 at gmail dot com>
 *
 * Licensed under The MIT License (MIT).
 * Copyright (c) Joan Claret Teruel <dpam23 at gmail dot com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
!function(e){"use strict";e.fn.slideAndSwipe=function(s){function t(e,s,t,n){"start"==s&&(r=i.hasClass("ssm-nav-visible")?0:l);var a;"move"==s&&"left"==t?(a=0>r?r-n:-n,o(a,0)):"move"==s&&"right"==t?(a=0>r?r+n:n,o(a,0)):"cancel"==s&&"left"==t&&0===r?o(0,d.speed):"end"==s&&"left"==t?v():"end"!=s&&"cancel"!=s||"right"!=t||console.log("end")}function n(){return/Safari/.test(navigator.userAgent)&&/Apple Computer/.test(navigator.vendor)}function a(){return/Chrome/.test(navigator.userAgent)&&/Google Inc/.test(navigator.vendor)}function o(s,t){i.css("transition-duration",(t/1e3).toFixed(1)+"s"),s>=0&&(s=0),l>=s&&(s=l),n()||a()?i.css("-webkit-transform","translate("+s+"px,0)"):i.css("transform","translate("+s+"px,0)"),"0"==s&&(e(".ssm-toggle-nav").addClass("ssm-nav-visible"),e("html").addClass("is-navOpen"),e(".ssm-overlay").fadeIn())}var i=e(this),l=-i.outerWidth(),r=l,d=e.extend({triggerOnTouchEnd:!0,swipeStatus:t,allowPageScroll:"vertical",threshold:100,excludedElements:"label, button, input, select, textarea, .noSwipe",speed:250},s);i.swipe(d);var v=function(){i.removeClass("ssm-nav-visible"),o(l,d.speed),e("html").removeClass("is-navOpen"),e(".ssm-overlay").fadeOut()},u=function(){i.addClass("ssm-nav-visible"),o(0,d.speed)};e(".ssm-toggle-nav").click(function(e){i.hasClass("ssm-nav-visible")?v():u(),e.preventDefault()})}}(window.jQuery||window.$,document,window),"undefined"!=typeof module&&module.exports&&(module.exports=slideAndSwipe);