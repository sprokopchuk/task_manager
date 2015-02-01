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

});