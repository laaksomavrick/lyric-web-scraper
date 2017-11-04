#this is an awful script, 
#but it's a one off for getting the lyrics, 
#and it works

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

song_urls.each do |url|

    p url

    target = "https://www.azlyrics.com#{url}"
    
    html = HTTParty.get(target)
    parsed = Nokogiri::HTML(html)
    
    parsed_string = parsed.to_s
    
    marker_one = '<!-- Usage of azlyrics.com content by any third-party lyrics provider is prohibited by our licensing agreement. Sorry about that. -->'
    marker_two = '</div>'
    
    rough_lyrics = parsed_string[/#{marker_one}(.*?)#{marker_two}/m, 1]
    lines = rough_lyrics.split('<br>')
    
    lyric_blocks = lines.map do |line|
        if line == "\n"
            line
        else
            line.strip
        end
    end
    
    File.open("lyrics.txt", "a") do |f|
        lyric_blocks.each { |element| f.puts(element) }
    end

    sleep(5)

end