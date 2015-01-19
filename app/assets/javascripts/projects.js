$(document).ready(function() {

		$(".panel-heading").each(function(){			
				$(this).on("click", ".pencil", function(){
					if($(".panel-heading > div").hasClass("hide")){
						$(".panel-heading > form").remove();
						$(".panel-heading").find(".hide").replaceWith($(".panel-heading > .hide").html());
					}
				});
		});
		$(document).bind('ajax:success',".panel-heading .pencil", function(){		
			$(".panel-heading > form").validate({
				rules: {
					"project[name]": {required: true, minlength: 4}
					}
			});
		});

		$(document).bind('ajax:success',".add-lists button", function(){		
			$("#new_project").validate({
				rules: {
					"project[name]": {required: true, minlength: 4}
					}
			});
		});

});

