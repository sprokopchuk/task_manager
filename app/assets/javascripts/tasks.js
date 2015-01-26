$(document).ready(function(){
	

	$("form[id^=for_project_id]").each(function(){
		
		$(this).bind("ajax:success", function(){
			$(this)[0].reset();
		});

		$(this).validate();
	
	});
	
	$("input[name='task[name]']").each(function(){
		$(this).rules("add", {required: true, minlength: 4} )
	});

	$(".panel-body").on("mouseenter", "input[name='task[deadline]']", function(){
		$(this).datetimepicker({format: "YYYY-MM-DD"});
	});

	$("input[name='task[deadline]']").each(function(){
		$(this).rules("add", {required: false, date: true } )
	});


	$(".list-group").on("click", ".list-group-item .pencil", function(){
		if($(".list-group-item > div").hasClass("hide")){
			$(".list-group-item > form").remove();
			$(".list-group-item > div").removeClass("hide")
		}
	});


	$(document).bind('ajax:success',".list-group-item .pencil", function(){		
		$(".list-group-item > form").validate({
			rules: {
				"task[name]": 		{required: true, minlength: 4},
				"task[deadline]": {required: false, date: true },
			}
		});

	});

	$(".list-group").on("mouseenter", ".list-group-item", function(){
		$(".badge").tooltip();
		$(".deadline").tooltip();
		$(this).find(".action-button").css("visibility", "visible");

	});

	$(".list-group").on("mouseleave", ".list-group-item", function(){
		$(this).find(".action-button").css("visibility", "hidden");
	});	

	$("input[id^=task_id]").bind('change', function(){
    $.ajax({
      url: '/tasks/'+$(this).parent().attr("data-task_id")+'/done',
      type: 'POST',
      data: {"done": this.checked}
    });
	});

	$(".btn-group-priority button").on('click', function(){
		var priority_value = $(this).parents(".checkbox").find(".badge").html();
		var chnage_priority = this.value
		$.ajax({
			beforeSend: function(xhr){
				if((chnage_priority == 'up' &&  priority_value == 3 ) || ( chnage_priority == 'down' &&  priority_value == 1 )) {
					xhr.abort();
				}
			},
			url: 'tasks/'+$(this).parents(".checkbox").attr("data-task_id")+'/priority',
			type: 'POST',
			data: {"priority": this.value},
		});
	});


});