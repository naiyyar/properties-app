'use strict';

(($) => {

    /**
     * The Checkboxes class object.
     */
    class Checkboxes {

        /**
         * Create a new checkbox context.
         *
         * @param {Object} context DOM context.
         */
        constructor(context) {
            this.$context = context;
        }

        /**
         * Check all checkboxes in context.
         */
        check() {
            let checkboxes = this.$context.find(':checkbox')
                .filter(':not(:disabled)')
                .filter(':not(.apple-switch)')
                .prop('checked', true)
                .trigger('change');
                this.selectRow(checkboxes)
        }

        /**
         * Uncheck all checkboxes in context.
         */
        uncheck() {
            let checkboxes = this.$context.find(':checkbox:visible')
                .filter(':not(:disabled)')
                .filter(':not(.apple-switch)')
                .prop('checked', false)
                .trigger('change');
                this.deselectRow(checkboxes);
        }

        showActionButtons() {
            $('.listing-actions').show(300);
            $('#check_all_listing').prop('checked', true);
        }

        hideActionButtons() {
            $('.listing-actions').hide(300);
            $('#check_all_listing').prop('checked', false);
        }

        selectRow(checkboxes){
            console.log(checkboxes)
            $.each(checkboxes, function(i, j){
                let p_tr = $(j).parent().parent();
                p_tr.addClass('selected');
                let id = p_tr.data('id');
                if(id != undefined){
                    aptListing.appendIdsContainerInputToForms(id);
                }
            });
            console.log('select checkboxes')
            this.showActionButtons();
        }

        deselectRow(checkboxes){
            $.each(checkboxes, function(i, j){
                let p_tr = $(j).parent().parent();
                p_tr.removeClass('selected');
                aptListing.removeIdsContainerInputToForms(p_tr.data('id'));
            });
            this.hideActionButtons();
        }

        /**
         * Toggle the state of all checkboxes in context.
         */
        toggle() {
            this.$context.find(':checkbox:visible')
                .filter(':not(:disabled)')
                .each((i, element) => {
                    let $checkbox = $(element);
                    $checkbox.prop('checked', !$checkbox.is(':checked'));
                })
                .trigger('change');
        }

        /**
         * Set the maximum number of checkboxes that can be checked.
         *
         * @param {Number} max The maximum number of checkbox allowed to be checked.
         */
        max(max) {
            if (max > 0) {
                // Enable max.
                let instance = this;
                this.$context.on('click.checkboxes.max', ':checkbox', () => {
                    if (instance.$context.find(':checked').length === max) {
                        instance.$context.find(':checkbox:not(:checked)').prop('disabled', true);
                    } else {
                        instance.$context.find(':checkbox:not(:checked)').prop('disabled', false);
                    }
                });
            } else {
                // Disable max.
                this.$context.off('click.checkboxes.max');
            }
        }

        /**
         * Enable or disable range selection.
         *
         * @param {Boolean} enable Indicate is range selection has to be enabled.
         */
        range(enable) {
            if (enable) {
                let instance = this;

                this.$context.on('click.checkboxes.range', ':checkbox', (event) => {
                    let $checkbox = $(event.target);
                    let shiftHold = false
                    let selected_box_tr = $checkbox.parent().parent();
                    if (event.shiftKey && instance.$last) {
                        //let $checkboxes = instance.$context.find(':checkbox:visible');
                        let $checkboxes = instance.$context.find('.listing-box');
                        let from = $checkboxes.index(instance.$last);
                        let to = $checkboxes.index($checkbox);
                        let start = Math.min(from, to);
                        let end = Math.max(from, to) + 1;

                        let elems = $checkboxes.slice(start, end)
                            .filter(':not(:disabled)')
                            .prop('checked', $checkbox.prop('checked'))
                            .trigger('change');
                        //Highlighting seleted rows + appending/removing input to/from form
                        let first_box = elems[0];
                        let new_elems;
                        //exclusing first checked checkbox selected without shift key
                        if(first_box.checked){
                            new_elems = jQuery.grep(elems, function(value) {
                              return value.getAttribute('id') != first_box.getAttribute('id');
                            });
                        }else{
                            new_elems = elems;
                        }
                        $.each(new_elems, function(i, j) {
                          let p_tr = $(j).parent().parent();
                          if (!p_tr.hasClass('selected')) {
                            p_tr.addClass('selected');
                            aptListing.appendIdsContainerInputToForms(p_tr.data('id'));
                          }else{
                            p_tr.removeClass('selected');
                            aptListing.removeIdsContainerInputToForms(p_tr.data('id'));
                          }
                        });
                        shiftHold = true;
                    }
                    if(!shiftHold){
                        let id = selected_box_tr.data('id');
                        if($checkbox.is(':checked')){
                            selected_box_tr.addClass('selected');
                            this.showActionButtons();
                            aptListing.appendIdsContainerInputToForms(id);
                        }else{
                            selected_box_tr.removeClass('selected');
                            this.hideActionButtons();
                            aptListing.removeIdsContainerInputToForms(id);
                        }
                    }
                    instance.$last = $checkbox;
                });
            } else {
                this.$context.off('click.checkboxes.range');
            }
        }
    }

    /* Checkboxes jQuery plugin. */

    // Keep old Checkboxes jQuery plugin, if any, to no override it.
    let old = $.fn.checkboxes;

    /**
     * Checkboxes jQuery plugin.
     *
     * @param {String} method Method to invoke.
     *
     * @return {Object} jQuery object.
     */
    $.fn.checkboxes = function (method) {
        // Get extra arguments as method arguments.
        let args = Array.prototype.slice.call(arguments, 1);

        return this.each((i, element) => {
            let $this = $(element);

            // Check if we already have an instance.
            let instance = $this.data('checkboxes');
            if (!instance) {
                $this.data('checkboxes', (instance = new Checkboxes($this)));
            }

            // Check if we need to invoke a public method.
            if (typeof method === 'string' && instance[method]) {
                instance[method].apply(instance, args);
            }
        });
    };

    // Store a constructor reference.
    $.fn.checkboxes.Constructor = Checkboxes;

    /* Checkboxes jQuery no conflict. */

    /**
     * No conflictive Checkboxes jQuery plugin.
     */
    $.fn.checkboxes.noConflict = function () {
        $.fn.checkboxes = old;
        return this;
    };

    /* Checkboxes data-api. */

    /**
     * Handle data-api click.
     *
     * @param {Object} event Click event.
     */
    var dataApiClickHandler = (event) => {
        var el = $(event.target);
        var href = el.attr('href');
        var $context = $(el.data('context') || (href && href.replace(/.*(?=#[^\s]+$)/, '')));
        var action = el.data('action');

        if ($context && action) {
            if (!el.is(':checkbox')) {
                event.preventDefault();
            }
            $context.checkboxes(action);
        }
    };

    /**
     * Handle data-api DOM ready.
     */
    var dataApiDomReadyHandler = () => {
        $('[data-toggle^=checkboxes]').each(function () {
            let el = $(this);
            let actions = el.data();
            delete actions.toggle;
            for (let action in actions) {
                el.checkboxes(action, actions[action]);
            }
        });
    };

    // Register data-api listeners.
    $(document).on('click.checkboxes.data-api', '[data-toggle^=checkboxes]', dataApiClickHandler);
    $(dataApiDomReadyHandler);

})(window.jQuery);