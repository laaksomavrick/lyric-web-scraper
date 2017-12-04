require 'rubygems'
require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key = ""
  config.consumer_secret = ""
  config.access_token = ""
  config.access_token_secret = ""
end

lyric_blocks = []
lines = File.readlines("lyrics.txt")

temp = ""

lines.each do |line|
  if line == "\n"
    lyric_blocks << temp
    temp = ""
  else
    fmt = line.downcase.capitalize
    temp << fmt
  end
end

max = lyric_blocks.length - 1
random = Random.new.rand(0..max)

selection = lyric_blocks[random]
check = lyric_blocks[random].length

if check > 280
  split = selection.split("\n")
  selection = ""
  split.each do |line|
    local_selection = selection.dup
    local_selection << line + "\n"
    break if local_selection.length > 280
    selection = local_selection
  end
end

client.update(selection)
sleep 14400

