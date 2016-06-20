
When(/^I create a new key_pair$/) do
  # Required variabeles
  expect(@compute).not_to be_nil
  expect(@key_pair_name).not_to be_nil
  expect(@key_pair_pubkey).not_to be_nil

  @key_pair = @compute.key_pairs.create(
    name: @key_pair_name,
    public_key: @key_pair_pubkey,
  )
  expect(@key_pair).not_to be_nil
end
