require 'sinatra/base'
require 'split'
require 'bigdecimal'
require 'split/countersdashboard/helpers'

module Split
  class Countersdashboard < Sinatra::Base
    dir = File.dirname(File.expand_path(__FILE__))

    set :views,  "#{dir}/countersdashboard/views"
    set :public_folder, "#{dir}/countersdashboard/public"
    set :static, true
    set :method_override, true

    helpers Split::CountersdashboardHelpers

    get '/' do
      @counter_names = Split::Counters.all_counter_names
      # Display Rails Environment mode (or Rack version if not using Rails)
      if Object.const_defined?('Rails')
        @current_env = Rails.env.titlecase
      else
        @current_env = "Rack: #{Rack.version}"
      end
      erb :index
    end

    delete '/counter/:counter' do
      if Split::Counters.exists?(params[:counter])
        Split::Counters.delete(params[:counter])
      end
      redirect url('/')
    end

    post '/counter/reset/:counter/:experiment/:alternative' do
      if Split::Counters.exists?(params[:counter])
        Split::Counters.reset(params[:counter], params[:experiment], params[:alternative])
      end
      redirect url('/')
    end
  end
end

