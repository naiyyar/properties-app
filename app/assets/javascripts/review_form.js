$(document).ready(function(){
    // New review form validations only
    $("#new_review").validate({
        rules: {
            'score[building]': 'required',
            'score[cleanliness]': 'required',
            'score[noise]': 'required',
            'score[safe]': 'required',
            'score[health]': 'required',
            'score[responsiveness]': 'required',
            'score[management]': 'required',
            'review[tenant_status]': 'required',
            'review[review_title]': 'required',
            'review[resident_to]': 'required',
            'review[pros]': { 'required': true, 'minlength': 10 },
            'review[cons]': { 'required': true, 'minlength': 10 },
            'review[resident_from]': 'required',
            'review[tos_agreement]': 'required',
            'vote': 'required'
        },
        messages: {
            'score': 'Please select a rating.',
            'review[tenant_status]': 'Please select a reviewer type.',
            'review[review_title]': 'Please add review title.',
            'review[resident_to]': 'Please select number of years in residence.',
            'review[pros]': {'required': 'Please add pros.', 'minlength': 'You must enter at least 10 words.'},
            'review[cons]': {'required': 'Please add cons.', 'minlength': 'You must enter at least 10 words.'},
            'review[resident_from]': 'Please select last year at residence.',
            'vote': 'Please select recommendation.',
            'review[tos_agreement]': 'Must be accepted.'
        }
    });

    // Removing rules when no pros check is checked
    $('#no_pros').change(function(){
        if($(this).is(':checked')){
            $('#review_pros').rules('remove', 'invalid min required');
        }
        else{
            $('#review_pros').rules('add', 'invalid min required');
        }
    });

    // Removing rules when no cons check is checked and vice versa
    $('#no_cons').change(function(){
        if($(this).is(':checked')){
            $('#review_cons').rules('remove', 'invalid min required');
        }
        else{
            $('#review_cons').rules('add', 'invalid min required');
        }
    });
})