// jQuery(function() {
//   return $.ajax({
//     url: 'https://apis.google.com/js/client:plus.js?onload=gpAsyncInit',
//     dataType: 'script',
//     cache: true
//   });
// });

// window.gpAsyncInit = function() {
//   gapi.auth.authorize({
//     immediate: true,
//     response_type: 'code',
//     cookie_policy: 'single_host_origin',
//     client_id: '913993827153-msctm5mn0a3rf90l1h4u6nl3u4d0kkae.apps.googleusercontent.com',
//     scope: 'email'
//   }, function(response) {
//     return;
//   });
//   $('.btn-google').click(function(e) {
//     e.preventDefault();
//     gapi.auth.authorize({
//       immediate: false,
//       response_type: 'code',
//       cookie_policy: 'single_host_origin',
//       client_id: '913993827153-msctm5mn0a3rf90l1h4u6nl3u4d0kkae.apps.googleusercontent.com',
//       scope: 'email'
//     }, function(response) {
//       if (response && !response.error) {
//         // google authentication succeed, now post data to server.
//         jQuery.ajax({type: 'POST', url: "/users/auth/google_oauth2", data: response,
//           success: function(data) {
//             // response from server
//             console.log(data)
//           }
//         });
//       } else {
//         // google authentication failed
//         console.log('Failed!')
//       }
//     });
//   });
// };
