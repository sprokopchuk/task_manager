def get_edit_form(project)
	expect(page).to have_content(project.name)
	page.find("a[href=\"#{edit_project_path(project)}\"]").click
	wait_for_ajax
	expect(page).to have_field("project[name]")	
end


