$(document).ready(function(){
	
	$("form[id^=for_project_id]").each(function(){
		$(this).validate();
	});
	$("input[name='task[name]']").each(function(){
		$(this).rules("add", {required: true, minlength: 4} )
	});
	$("input[name='task[deadline]']").each(function(){
		$(this).rules("add", {required: false, date: true } )
	});
});