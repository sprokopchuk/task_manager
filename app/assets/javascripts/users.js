$(document).ready(function(){

	$(document).bind("ajax:error", "#ajax-modal", function(event, xhr, status, error){
		if(xhr.status == 401){
			if($("#ajax-modal").is(":visible")){
				$('<div class="alert alert-error">' + xhr.responseText + '</div>').insertBefore(".modal-body-content").fadeOut(3000, function(){
					$(this).remove();
				});
			}else{
				$('<div class="alert alert-error">' + xhr.responseText + '</div>').insertBefore(".nav").fadeOut(3000, function(){
					$(this).remove();
				});				
			}
		}
	});

	$(document).bind("ajax:complete", function(event, xhr, settings) {
	  var csrf_param = xhr.getResponseHeader('X-CSRF-Param');
	  var csrf_token = xhr.getResponseHeader('X-CSRF-Token');

	  if (csrf_param) {
	    $('meta[name="csrf-param"]').attr('content', csrf_param);
	  }
	  if (csrf_token) {
	    $('meta[name="csrf-token"]').attr('content', csrf_token);
	  }
	});

	$("#ajax-modal").on('shown.bs.modal', function(){
		validate_for_modal();
		
		$(".modal-footer").on('DOMSubtreeModified', function(){
			validate_for_modal();
		});
		
	});

});

function validate_for_modal(){
	switch($(".modal-title").html()){
		case "Sign Up":
		$(".modal-body-content > form").validate({
			rules: {
				"user[email]": {required: true},
				"user[password]": {required: true, minlength: 8},				
				"user[password_confirmation]": {required: true, minlength: 8}
				}
		});
		break;
		case "Log In":
		$(".modal-body-content > form").validate({
			rules: {
				"user[email]": {required: true},
				"user[password]": {required: true, minlength: 8},				
				}
		});
		break;

		case "Forgot your password?":
		$(".modal-body-content > form").validate({
			rules: {
				"user[email]": {required: true},
				}
		});
		break;

		case "Edit User":
		$(".modal-body-content > form").validate({
			rules: {
				"user[email]": {required: true},
				"user[password]": {minlength: 8},				
				"user[password_confirmation]": {minlength: 8},
				"user[current_password]": {required: true, minlength: 8}				
				}
		});
		break;

	}
}