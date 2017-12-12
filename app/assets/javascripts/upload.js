$(document).ready(function(){
	// disable auto discover
	Dropzone.autoDiscover = false;

	// grap our upload form by its id
	$("#new_upload_photos").dropzone({
		// restrict image size to a maximum 1MB
		//maxFilesize: 1,
		// changed the passed param to one accepted by
		// our rails app
		paramName: "upload[image]",
		// show remove links on each image upload
		addRemoveLinks: true,
		// if the upload was successful
		success: function(file, response){
			// find the remove button link of the uploaded file and give it an id
			// based of the fileID response from the server
			$(file.previewTemplate).find('.dz-remove').attr('id', response.fileID);
			// add the dz-success class (the green tick sign)
			$(file.previewElement).addClass("dz-success");
		},
		//when the remove button is clicked
		removedfile: function(file){
			// grap the id of the uploaded file we set earlier
			var id = $(file.previewTemplate).find('.dz-remove').attr('id'); 
			$(file.previewTemplate).find('.dz-remove').parent().remove();
			// make a DELETE ajax request to delete the file
			$.ajax({
				type: 'DELETE',
				url: '/uploads/' + id,
				success: function(data){
					console.log(data.message);
				}
			});
		}
	});	

	//Only for pfd and word docs
	$("#new_upload_documents").dropzone({
		// restrict image size to a maximum 1MB
		//maxFilesize: 1,
		// changed the passed param to one accepted by
		// our rails app
		paramName: "upload[document]",
		// show remove links on each image upload
		addRemoveLinks: true,
		// if the upload was successful
		successful: function(file, response){
			// find the remove button link of the uploaded file and give it an id
			// based of the fileID response from the server
			$(file.previewTemplate).find('.dz-remove').attr('id', response.fileID);
			// add the dz-success class (the green tick sign)
			$(file.previewElement).addClass("dz-success");
		},
		//when the remove button is clicked
		removedfile: function(file){
			// grap the id of the uploaded file we set earlier
			var id = $(file.previewTemplate).find('.dz-remove').attr('id'); 
			$(file.previewTemplate).find('.dz-remove').parent().remove();
			// make a DELETE ajax request to delete the file
			$.ajax({
				type: 'DELETE',
				url: '/uploads/' + id,
				success: function(data){
					// console.log(data.message);
				}
			});
		}
	});

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