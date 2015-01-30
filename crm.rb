require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper'

#Setting up databases - working with datamapper
DataMapper.setup(:default, "sqlite3:database.sqlite3")

class Contact
  # module DataMapper
  #   module Resource
  #   end
  # end ==> That's what the '::' does below
  include DataMapper::Resource
  #Datamapper syntax below to communicate with the DB
  property :id, Serial
  property :first_name, String
  property :last_name, String
  property :email, String
  property :note, String

  # attr_accessor :id, :first_name, :last_name, :email, :note

  # def initialize(first_name, last_name, email, note)
  #   @id = id
  #   @first_name = first_name
  #   @last_name = last_name
  #   @email = email
  #   @note = note  
  # end

  # def to_s
  #   "id: #{@id} First Name: #{@first_name} Last Name: #{@last_name} Email: #{@email} Note: #{@note}" 
  # end
end

DataMapper.finalize
DataMapper.auto_upgrade!

#end of datamapper setup

#routes
get '/' do
  @title = "Main Page"
  @crm_app_name = "My CRM"
  erb :index 
end

get '/contacts' do
  @title = "Contacts Page"
  @contacts = Contact.all
  erb :contacts
  end

get '/contacts/new' do
  @title = "Add a new contact"
  erb :new_contact
end

post '/contacts' do
  #Saves it to the newly created DB
  new_contact = Contact.create(
    :first_name => params[:first_name],
    :last_name => params[:last_name],
    :email => params[:email],
    :note => params[:note]
    )

  redirect to('/contacts')
end 

get '/contacts/:id' do
  # @contact = @@rolodex.find(params[:id].to_i)
  @contact = Contact.get(params[:id].to_i)
  if @contact
    erb :show_contact
  else
    raise Sinatra::NotFound
  end
end

get "/contacts/:id/edit" do
  @contact = Contact.get(params[:id].to_i)
  if @contact
    erb :edit_contact
  else
    raise Sinatra::NotFound
  end
end

put "/contacts/:id" do
  @contact = Contact.get(params[:id].to_i)
  if @contact
    @contact.first_name = params[:first_name]
    @contact.last_name = params[:last_name]
    @contact.email = params[:email]
    @contact.note = params[:note]
    @contact.save

    redirect to("/contacts")
  else
    raise Sinatra::NotFound
  end
end 

delete "/contacts/:id" do
  @contact = Contact.get(params[:id].to_i)
  if @contact
    # @@rolodex.remove_contact(@contact)
    @contact.destroy
    redirect to("/contacts")
  else
    raise Sinatra::NotFound
  end
end