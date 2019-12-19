$(document).on("submit", "form#stripe-billing-form", function(event){
  var form = $(this);
  form.find(".payment-errors").text("");
  form.find('.btn_submit').prop('disabled', true);
  Stripe.card.createToken(form, stripeResponseHandler);
  return false;
});

function stripeResponseHandler(status, response) {
  var paymentForm = $('#stripe-billing-form');
  //alert(12)
  if (response.error) {
    paymentForm.find('.payment-errors').text(response.error.message);
    paymentForm.find('.btn_submit').prop('disabled', false);
  } else {
    var token = response.id;
    console.log(token)
    paymentForm.append($('<input type="hidden" name="billing[stripe_card_id]" />').val(token));
    //submitPaymentForm();
    //paymentForm.submit();
    paymentForm[0].submit();
  }
};