$(document).ready(function(){
  if($('#stripe-billing-form').length > 0){
    $('#example2-address').on('keyup', function(){
      var text = $(this).val();
      $('#billing_email').val(text);
    });

    var stripe = Stripe($("meta[name='stripe-key']").attr('content'));
    function registerElements(elements, exampleName) {
      var formClass = '.' + exampleName;
      var example = document.querySelector(formClass);
      var form = example.querySelector('form');
      var error = form.querySelector('.error');
      var errorMessage = error.querySelector('.message');

      function enableInputs() {
        Array.prototype.forEach.call(
          form.querySelectorAll(
            "input[type='text'], input[type='email']"
          ),
          function(input) {
            input.removeAttribute('disabled');
          }
        );
      }

      function disableInputs() {
        Array.prototype.forEach.call(
          form.querySelectorAll(
            "input[type='text'], input[type='email']"
          ),
          function(input) {
            input.setAttribute('disabled', 'true');
          }
        );
      }

      function triggerBrowserValidation() {
        // The only way to trigger HTML5 form validation UI is to fake a user submit
        // event.
        var submit = document.createElement('input');
        submit.type = 'submit';
        submit.style.display = 'none';
        form.appendChild(submit);
        submit.click();
        submit.remove();
      }

      // Listen for errors from each Element, and show error messages in the UI.
      var savedErrors = {};
      elements.forEach(function(element, idx) {
        element.on('change', function(event) {
          if (event.error) {
            error.classList.add('visible');
            savedErrors[idx] = event.error.message;
            errorMessage.innerText = event.error.message;
          } else {
            savedErrors[idx] = null;

            // Loop over the saved errors and find the first one, if any.
            var nextError = Object.keys(savedErrors)
              .sort()
              .reduce(function(maybeFoundError, key) {
                return maybeFoundError || savedErrors[key];
              }, null);

            if (nextError) {
              // Now that they've fixed the current error, show another one.
              errorMessage.innerText = nextError;
            } else {
              // The user fixed the last error; no more errors.
              error.classList.remove('visible');
            }
          }
        });
      });

      // Listen on the form's 'submit' handler...
      form.addEventListener('submit', function(e) {
        e.preventDefault();
        // Trigger HTML5 validation UI on the form if any of the inputs fail
        // validation.
        var plainInputsValid = true;
        Array.prototype.forEach.call(form.querySelectorAll('input'), function(
          input
        ) {
          if (input.checkValidity && !input.checkValidity()) {
            plainInputsValid = false;
            return;
          }
        });
        if (!plainInputsValid) {
          triggerBrowserValidation();
          return;
        }

        // Show a loading screen...
        //example.classList.add('submitting');
        // Disable all inputs.
        disableInputs();
        // Use Stripe.js to create a token. We only need to pass in one Element
        // from the Element group in order to create a token. We can also pass
        // in the additional customer data we collected in our form.
        stripe.createToken(elements[0]).then(function(result) {
          // Stop loading!
          //example.classList.remove('submitting');
          if (result.token) {
            var token = result.token.id;
            var paymentForm = $('#stripe-billing-form');
            paymentForm.append($('<input type="hidden" name="billing[stripe_card_id]" />').val(token));
            //example.classList.add('submitted');
            paymentForm[0].submit();
          } else {
            // Otherwise, un-disable inputs.
            enableInputs();
          }
        });
      });
    }


    var elements = stripe.elements({
      fonts: [{
        //cssSrc: 'https://fonts.googleapis.com/css?family=Source+Code+Pro',
      }, ],
      // Stripe's examples are localized to specific languages, but if
      // you wish to have Elements automatically detect your user's locale,
      // use `locale: 'auto'` instead.
      locale: window.__exampleLocale
    });

    // Floating labels
    var inputs = document.querySelectorAll('.cell.example.example2 .input');
    Array.prototype.forEach.call(inputs, function(input) {
      input.addEventListener('focus', function() {
        input.classList.add('focused');
      });
      input.addEventListener('blur', function() {
        input.classList.remove('focused');
      });
      input.addEventListener('keyup', function() {
        if (input.value.length === 0) {
          input.classList.add('empty');
        } else {
          input.classList.remove('empty');
        }
      });
    });

    var elementStyles = {
      base: {
        color: '#32325D',
        fontWeight: 500,
        //fontFamily: 'Source Code Pro, Consolas, Menlo, monospace',
        fontSize: '16px',
        fontSmoothing: 'antialiased',

        '::placeholder': {
          color: '#A9A9A9',
        },
        ':-webkit-autofill': {
          color: '#A9A9A9',
        },
      },
      invalid: {
        color: '#E25950',

        '::placeholder': {
          color: '#FFCCA5',
        },
      },
    };

    var elementClasses = {
      focus: 'focused',
      empty: 'empty',
      invalid: 'invalid',
    };

    var cardNumber = elements.create('cardNumber', {
      style: elementStyles,
      classes: elementClasses,
    });
    cardNumber.mount('#example2-card-number');

    var cardExpiry = elements.create('cardExpiry', {
      style: elementStyles,
      classes: elementClasses,
    });
    cardExpiry.mount('#example2-card-expiry');

    var cardCvc = elements.create('cardCvc', {
      style: elementStyles,
      classes: elementClasses,
    });
    cardCvc.mount('#example2-card-cvc');

    registerElements([cardNumber, cardExpiry, cardCvc], 'example2');

    var cardBrandToPfClass = {
      'visa': 'pf-visa',
      'mastercard': 'pf-mastercard',
      'amex': 'pf-american-express',
      'discover': 'pf-discover',
      'diners': 'pf-diners',
      'jcb': 'pf-jcb',
      'unknown': 'pf-credit-card',
    }

    function setBrandIcon(brand) {
      var brandIconElement = document.getElementById('brand-icon');
      var pfClass = 'pf-credit-card';
      if (brand in cardBrandToPfClass) {
        pfClass = cardBrandToPfClass[brand];
      }
      for (var i = brandIconElement.classList.length - 1; i >= 0; i--) {
        brandIconElement.classList.remove(brandIconElement.classList[i]);
      }
      brandIconElement.classList.add('pf');
      brandIconElement.classList.add(pfClass);
    }

    cardNumber.on('change', function(event) {
      // Switch brand logo
      if (event.brand) {
        setBrandIcon(event.brand);
      }
    });
  }; //end if
})//end doc ready