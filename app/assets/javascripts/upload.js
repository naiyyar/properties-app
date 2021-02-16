$(document).ready(function(){
	// disable auto discover
	Dropzone.autoDiscover = false;
	var uploaded_ids = [];
	// grap our upload form by its id
	// #new_upload_photos = from +upload button 
	// new_upload_ = from contribute page
	// id new_upload_ used for featured agent form
	var dz_elem = $('#new_upload_photos, #new_upload_');
	var param_name = "upload[image]";
	if($('#new_upload_documents').length > 0){
		dz_elem = $('#new_upload_documents');
		param_name = 'upload[document]'
	}
	dz_elem.dropzone({
		// restrict image size to a maximum 1MB
		maxFilesize: 1,
		// changed the passed param to one accepted by
		// our rails app
		paramName: param_name,
		// show remove links on each image upload
		addRemoveLinks: true,
		dictDefaultMessage: "<b>Add images </b> <br/> Drop Your Images Or Click To Browse",
		// if the upload was successful
		success: function(file, response){
			// find the remove button link of the uploaded file and give it an id
			// based of the fileID response from the server
			$(file.previewTemplate).find('.dz-remove').attr('id', response.fileID);
			// add the dz-success class (the green tick sign)
			$(file.previewElement).addClass("dz-success");

			if(!uploaded_ids.includes(response.fileID)){
				appendToGallery(response);
				removedfile(file);
			}
		},
		//when the remove button is clicked
		removedfile: function(file){
			// grap the id of the uploaded file we set earlier
			// make a DELETE ajax request to delete the file
			removedfile(file)
			delete_upload(file)
		}
	});

	function removedfile(file){
		$(file.previewTemplate).find('.dz-remove').parent().remove();
	}

	function delete_upload(file){
		var id = $(file.previewTemplate).find('.dz-remove').attr('id'); 
		$.ajax({
			type: 'DELETE',
			url: '/uploads/' + id,
			success: function(data){
				// console.log(data.message);
			}
		});
	}

	function appendToGallery(response){
		var image_url = response.image_url;
		var upload_id = response.fileID;
		var sort_index = $('.featured-gallery').length;
		uploaded_ids.push(upload_id) // ISSUE TO FIX: file is uploaded once but sending two success call for a file.
		var featured_icon_class='';
		var badge_icon='';
		
		if(sort_index == 0) {
			featured_icon_class = 'fl-featured-image';
			badge_icon = '<h4 class="comp featured round"><span class="icon-badge font-14"></span></h4>';
		}
		
		var html =  '<li class="featured-gallery ui-state-default '+featured_icon_class+'" data-id="'+upload_id+'" data-index="'+sort_index+'">' +
									'<a data-caption="" data-fancybox="gallery" data-imageable="" data-role="slider" href="'+image_url+'">' +
										'<img src="'+image_url+'" alt="image">' +
									'</a>' +
									'<div class="pull-left fl-featured-badge">'+badge_icon+'</div>' +
									'<div class="actions-links">' +
										'<a class="btn btn-primary btn-xs edit_image" data-remote="true" href="/uploads/'+upload_id+'/edit?upload_type=image"><span class="fa fa-edit"></span></a>' +
										'<a class="btn btn-danger btn-xs delete_image" data-remote="true" rel="nofollow" data-method="delete" href="/uploads/'+upload_id+'"><span class="fa fa-trash"></span></a>' +
									'</div>' +
								'</li>'
		
		$('ul#gallery').append(html);
	}

	//Saving document downloads counts
	$('.document-name').click(function(){
		var upload_id = $(this).data('uploadid');
		var user_id = $(this).data('userid');

		$.ajax({
			url: '/document_downloads',
			beforeSend: function(xhr) { xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')) },
			dataType: 'json',
			type: 'POST',
			data: { document_download:{ upload_id: upload_id, user_id: user_id } },
			success: function(response){
				// console.log(response);
			},
			complete: function(response){
				console.log('Completed!');
			}
		})
	})
});