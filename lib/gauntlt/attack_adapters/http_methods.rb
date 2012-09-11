require 'httparty'

When /^"curl" is installed$/ do
  ensure_cli_installed("curl")
end

When /^I launch a "curl" attack$/ do
  url = URI::Generic.build(
    :scheme => 'http',  # allow this to be set
    :host   => hostname
  ).to_s

  # we need a rescue to capture the response
  # due to the odd way HTTParty handles redirects
  begin
    @response = HTTParty.get(url, :no_follow => true)
  rescue HTTParty::RedirectionTooDeep => e
    @response = e.response
  end
end

When /^I launch a "curl" attack with:$/ do |command|
  command.gsub!('<hostname>', hostname)
  run command
end