$(document).ready(function(){
	

	$("form[id^=new_task]").each(function(){
		$(this).validate();
	});
	
	$("input[name^='task']").each(function(){
		$(this).rules("add", {required: true, minlength: 4} )
	});
});