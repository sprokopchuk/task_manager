// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require moment
//= require bootstrap-datetimepicker
//= require jquery.validate
//= require jquery.validate.additional-methods
//= require turbolinks
//= require_tree .

$(document).ready(function(){
	// this sets up the ajax loader, and it will stay until the method specific js removes it
	$('a[data-target=#ajax-modal]').on('click', function(e){
   e.preventDefault();
   e.stopPropagation();
   //$('body').modalmanager('loading');
   $.rails.handleRemote( $(this) );
 });
	//removes whatever is in the modal body content div upon clicking close/outside modal
	$(document).on('click', '[data-dismiss=modal], .modal-scrollable', function(){
	  $('.modal-title').empty();
	  $('.modal-body-content').empty();
	  $('.modal-footer').empty();
	});
	
	$('#ajax-modal').on('click', 'a[data-remote=true]', function(){
		var shown = $("#ajax-modal").is(":visible");
		if(!shown){
		  $('.modal-title').empty();
		  $('.modal-body-content').empty();
		  $('.modal-footer').empty();
		}
	});

	$(document).on('click', '#ajax-modal', function(e){
	  e.stopPropagation();
	});

	$(document).on('click', function(event) {
	  var edit = $(".glyphicon-pencil");
	  if(!edit.is(event.target) && !$(event.target).closest('.panel-heading').length){
			$(".panel-heading > form").remove();
			$(".panel-heading").find(".hide").replaceWith($(".panel-heading > .hide").html());
	  } 

	  if(!edit.is(event.target) && !$(event.target).closest('.list-group-item').length){
			$(".list-group-item > form").remove();
			$(".list-group-item > div").removeClass("hide")
	  } 

	});

});

