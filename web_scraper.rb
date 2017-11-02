#get all smiths lyrics
#parse into mungeable format
#find all lines below 140 characters
#sanitize
#create "database"

require 'HTTParty'
require 'Nokogiri'
require 'JSON'

directory = HTTParty.get('https://www.azlyrics.com/s/smiths.html')
parsed_directory = Nokogiri::HTML(directory)

song_urls = []

parsed_directory.css('a').each do |element|
    href = element.attr('href')
    if href.kind_of? String
        if href.include? "../lyrics/smiths/"
            cleaned = href[2..-1]
            song_urls << cleaned
        end
    end
end

temp = song_urls[0]

target = "https://www.azlyrics.com#{temp}"

html = HTTParty.get(target)
parsed = Nokogiri::HTML(html)

parsed_string = parsed.to_s

marker_one = '<!-- Usage of azlyrics.com content by any third-party lyrics provider is prohibited by our licensing agreement. Sorry about that. -->'
marker_two = '</div>'

rough_lyrics = parsed_string[/#{marker_one}(.*?)#{marker_two}/m, 1]
lines = rough_lyrics.split('<br>')

open('lyrics.txt', 'w') { |f| f << lines } 
