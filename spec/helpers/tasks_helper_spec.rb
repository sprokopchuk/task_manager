def get_edit_form_for_task(task)
	expect(page).to have_content(task.name)
	div_task = page.find("div[data-task_id=\"#{task.id}\"]")
	div_task.hover
	div_task.find("a[href=\"#{edit_task_path(task)}\"]").click
	wait_for_ajax
	expect(page).to have_field("task[name]", :with => task.name) 
end



