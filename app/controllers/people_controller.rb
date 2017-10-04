class PeopleController < ApplicationController
  get '/people/new' do
    logged_in? ? (erb :'/people/new') : (redirect '/')
  end

  post '/people' do

    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @dob = params[:dob]

    person = Person.new
    if person.emtpy_input?(params)
       flash[:message] = 'Some required information is missing or incomplete.' \
                         ' Please correct your entries and try again.'
       erb :'people/new'
    else
      person.first_name = params[:first_name]
      person.last_name = params[:last_name]
      person.dob = params[:dob]
      person.age = person.age_calculator(params[:dob].to_date)
      person.save

      user = User.find(session[:u_id])
      user.person = person

      user.save

      redirect "/people/#{person.id}"
    end
  end

  get '/people/:id' do
    if logged_in?
      @person = Person.find(params[:id])

      @user = User.find(session[:u_id])

      erb :'/people/show'
    else
      redirect '/'
    end
  end
end
