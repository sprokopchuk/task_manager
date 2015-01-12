$(document).ready(function () {
	
	$(".add-lists").on("click", function(){
		$("#new_project").validate({
			rules: {
				"project[name]": {required: true, minlength: 4}
			}
		});
	});

});

