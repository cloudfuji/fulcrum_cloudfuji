Rails.application.routes.draw do
  begin
    cloudfuji_routes
  rescue => e
    puts "Error loading the Cloudfuji routes:"
    puts "#{e.inspect}"
  end
end
