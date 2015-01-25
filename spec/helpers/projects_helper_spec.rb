def get_edit_form_for_project(project)
	expect(page).to have_content(project.name)
	page.find("a[href=\"#{edit_project_path(project)}\"]").click
	wait_for_ajax
	expect(page).to have_field("project[name]")	
end


