
Then(/^lingering([\w, ]+)? (\w+) and (\w+) on (\w+) are cleaned$/) do |others, first, second, service|
  models = []
  models.concat(others.split(',').map{|model| model.strip}) if others
  models << first << second

  steps models.map{|model| "Then lingering #{model} on #{service} are cleaned"}.join("\n")
end

Then(/^lingering (\w+) on (\w+) are cleaned$/) do |models_name,service_name|
  service = instance_variable_get("@#{service_name.downcase}")
  expect(service).not_to be_nil
  expect(service).to respond_to(models_name)

  prefix = _generate_name(_singularize(models_name), 0)
  models = service.send(models_name).all.select{|model| model.name.start_with?(prefix)}
  puts "Cleaning up #{models.count} #{models_name}" if models.count > 0
  models.each do |model|
    model.destroy
  end
end
