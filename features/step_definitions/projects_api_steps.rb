# coding: utf-8

Then(/^that project should be enabled$/) do
  expect(@project.enabled).to be true
end
