$(document).on('change', '#review_photo_attachments', function(){
  var files = document.getElementById('review_photo_attachments').files;
  
	for(i = 0; i < files.length; i++){
		file = files[i];
		var reader  = new FileReader();
		console.log(file);
	  reader.addEventListener('load', function (e) {
		 var image = $($.parseHTML('<img>')).attr('src', e.target.result);
		 preview_div = '<div class="pull-left image-preview"></div>';
		 image_div = $(preview_div).html(image);
		 $('.images-container').prepend(image_div);
	  }, false);

	  if (file) {
	    reader.readAsDataURL(file);
	  }
	}
});