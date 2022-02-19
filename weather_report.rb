#!/usr/bin/env ruby
  require 'net/http'
  require 'uri'
  require 'json'



#Gets the local IP address

  class IPAddress
	def get_ip
       ip = Net::HTTP.get(URI("https://ip-fast.com/api/ip/?format=json&location=True"))
    end
  end


#Makes the ip address into an reuasble variable called "my_ip"

  ip = IPAddress.new 
  my_ip = ip.get_ip


  class GeoLocation
  	  attr_reader :ip
  	
  	def initialize(ip) 
  		 @ip = ip
  	end
	# This method takes an IP address puts it in as ahashed JSON object 
	def get_location
        location_uri = URI('https://geocode.xyz')
        params = {
          'locate' => @ip,
          'json' => 1,
          'region' => 'US',
          'moreinfo' => 1
        }
         location_uri.query = URI.encode_www_form(params)
         location_response = Net::HTTP.get_response(location_uri)
         location = location_response.read_body
         location_hash = JSON.parse(location)
       end
     end


#Takes the hashed JSON object and wraps it in a reusable variable called "my_location"

  geo_location = GeoLocation.new(my_ip)
  my_location = geo_location.get_location


#This class takes the "my_location" has and uses it to gather longitude, latitude and timezone

  class WeatherParams
  	attr_reader :location
  	def initialize(location)
  		@location = location
  	end

  	def timezone
  		 timezone = location['timezone'] 
    end
    def longitute
    	long = location['longt'] 
    end
    def latitude
    	latt = location['latt']
    end


  end
#Wraps the longitude, latitude and timezone into reusable variables 

  weather_params = WeatherParams.new(my_location)
  timezone = weather_params.timezone
  longitude = weather_params.longitute
  latitude = weather_params.latitude
  




class Weather 
	attr_reader :latitude, :longitude, :timezone

	def initialize(latitude, longitude, timezone)
       @latitude = latitude
       @longitude = longitude
       @timezone = timezone
	end
    # takes the passed in parameters and returns a weather forecast as a hash
    def weather
      weather_uri = URI('https://api.open-meteo.com/v1/forecast?')
      params = {
  	  'latitude' => @latitude,
  	  'longitude' => @longitude,
  	  'hourly' => 'temperature_2m',
  	  'daily' => ['temperature_2m_max','temperature_2m_min'],
  	  'timezone' => @timezone,
  	  'temperature_unit' => 'fahrenheit'
  	  }

     weather_uri.query = URI.encode_www_form(params)
     weather_response = Net::HTTP.get_response(weather_uri)

     weather = weather_response.read_body
     weather_hash = JSON.parse(weather)
   end
  

  #Gets the nested daily hash out of the weather hash

   def daily_hash
   	    daily_hash = weather['daily']
   end

   #Uses the created daily has to get the time as well as the high  and lowimum temperatures 

   def high  
    high  = daily_hash["temperature_2m_max"]
   end
   def low
     low = daily_hash["temperature_2m_min"]
   end
     def time
     time = daily_hash['time']
   end
  
end

#Wraps time as well as lowimum andhigh imum temperature arrays into reusable variables

weather = Weather.new(latitude, longitude, timezone)
time = weather.time
high =  weather.high 
low =  weather.low


#This class defines the output I want the user/developer to see when the program is run

 class Output 
	attr_reader :time, :low, :high

	def initialize(time, high, low)
		@low = low  
		@high =high 
		@time = time
	end
    
    def final 
	  while low != [] 
	     puts "#{time.shift}:High :#{high.shift} 
	    Low:#{low.shift}"
	    end
    end

end

date = Output.new(time, high , low) 
puts date.final




  


  





 






