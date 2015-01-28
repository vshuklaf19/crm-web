require './rolodex'
require './contact'
require 'sinatra'
require 'sinatra/reloader'

$rolodex= Rolodex.new

#routes
get '/' do
  @title = "Main Page"
  @crm_app_name = "My CRM"
  erb :index 
end

get '/contacts' do
  @title = "Contacts Page"
  erb :contacts
  end

get '/contacts/new' do
  @title = "Add a new contact"
  erb :new_contact
end

post '/contacts' do
  new_contact = Contact.new(params[:first_name], params[:last_name], params[:email], params[:note])
  $rolodex.add_contact(new_contact)
  redirect to('/contacts')
end