require 'nokogiri'
require 'json'
require 'open-uri'
require 'cgi'

cityURLs = [
    "united-states/illinois/chicago-2379574",
    "japan/tokyo-prefecture/tokyo-1118370",
    "united-kingdom/england/london-44418"
]

def getTenDaysOfWeather(cityURL)

    doc = Nokogiri::HTML(URI.open('https://www.yahoo.com/news/weather/'+ cityURL))

    def weatherJson(weatherStr,dL,dH)
        precipitation = weatherStr.split('%')[0]
        precipitation =
        low =
        high = 
        forcast =
        weatherForcast ={ 
            "precipitation" =>  precipitation[dL..dH],
            "low" =>  weatherStr.split('%')[1].split('°')[0],
            "high" => weatherStr.split('%')[1].split('°')[1],
            "forcast" =>  weatherStr.split('%')[1].split('°')[2].split('with a')[0]
        }
        return  weatherForcast
    end
    city = ""
    doc.css('weather-card', '.location .city').each do |link|
        city = link.content
    end
    tenDaysWeather = [{
        "city"=> city
    }]

    weather = doc.css('weather-card', '.forecast .forecast-item').each do |link|
    end

    for i in 0..9 do
        oneDayWeather = weather[i].text.split('high of')
        if oneDayWeather[0].include?("Thursday") || oneDayWeather[0].include?("Saturday") 
            time = Time.now + i*86400 
            thisWeather = weatherJson(oneDayWeather[0],8,10)   
            thisWeatherObject = {  time.strftime("%d-%m-%Y") => thisWeather}
            tenDaysWeather.push(thisWeatherObject)

        end
        if oneDayWeather[0].include?("Friday") || oneDayWeather[0].include?("Sunday") || oneDayWeather[0].include?("Monday")
            time = Time.now + i*86400 
            thisWeather = weatherJson(oneDayWeather[0],6,8) 
            thisWeatherObject = {  time.strftime("%d-%m-%Y") => thisWeather}
            tenDaysWeather.push(thisWeatherObject)
        end
        if oneDayWeather[0].include? "Tuesday"  
            time = Time.now + i*86400 
            thisWeather = weatherJson(oneDayWeather[0],7,9)
            thisWeatherObject = {  time.strftime("%d-%m-%Y") => thisWeather}
            tenDaysWeather.push(thisWeatherObject)
        end
        if oneDayWeather[0].include? "Wednesday"  
            time = Time.now + i*86400 
            thisWeather = weatherJson(oneDayWeather[0],9,11)
            thisWeatherObject = {  time.strftime("%d-%m-%Y") => thisWeather}
            tenDaysWeather.push(thisWeatherObject)
        end
    end

    File.open(city + ".json","w") do |f|
        f.write(tenDaysWeather.to_json)
    end
end

for j in 0..2 do
    getTenDaysOfWeather(cityURLs[j])
end



