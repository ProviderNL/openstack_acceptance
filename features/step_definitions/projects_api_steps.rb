# coding: utf-8

Then(/^there is at least one project$/) do
  @avail_projects = @identity.projects.all
  expect(@avail_projects.count).to be >= 1
end

Given(/^I generate a unique project name$/) do
  @project_name = "cucumber-#{SecureRandom.hex(12)}"
end

Given(/^that project name is not used$/) do
  expect(get_project).to be_nil
end

When(/^I create the new project$/) do
  @identity.projects.create(
    name: @project_name,
  )
end

Then(/^that project can be retrieved$/) do
  @project = get_project
  expect(@project).not_to be_nil
end

Then(/^that project should be enabled$/) do
  expect(@project.enabled).to be true
end

When(/^I remove the project$/) do
  @project.destroy
end

Then(/^that project cannot be retrieved$/) do
  expect(get_project).to be_nil
end

# Helpers
def get_project
  expect(@identity).not_to be_nil
  @identity.projects.all.select{|pr| pr.name == @project_name}.first
end
