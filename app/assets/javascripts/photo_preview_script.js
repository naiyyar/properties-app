// $(document).on('change', '#upload_images', function(){
//   var files = document.getElementById('upload_images').files;
//   
// 	for(i = 0; i < files.length; i++){
		
// 	}
// });

function showImagePreview(file){
		var reader  = new FileReader();
	  reader.addEventListener('load', function (e) {
		 var image = $($.parseHTML('<img>')).attr('src', e.target.result);
		 var preview_div = '<div class="pull-left image-preview"></div>';
		 var image_div = $(preview_div).html(image);
		 $('.images-container').prepend(image_div);
	  }, false);

	  if (file) {
	    reader.readAsDataURL(file);
	  }

}