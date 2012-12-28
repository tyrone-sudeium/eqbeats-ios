#!/usr/bin/env ruby

# Fetches the provided number of random bits of album artwork from eqbeats.
# Defaults to 50 if no number is provided.

require 'rmagick'
require 'json'
require 'open-uri'
require 'fileutils'

OUTPUT_DIR = 'artwork'
ORIGINALS_DIR = "#{OUTPUT_DIR}/orig"
THUMB_DIR = "#{OUTPUT_DIR}/thumb"
THUMB_SIZE = [180,180]
API_ENDPOINT = 'https://eqbeats.org/tracks/random/json'
IMAGES_NEEDED = 50
if ARGV.length > 0
  IMAGES_NEEDED = ARGV[0].to_i
end

remaining_images = IMAGES_NEEDED
track_ids_checked = []

FileUtils.mkdir_p(OUTPUT_DIR)
FileUtils.mkdir_p(THUMB_DIR)
FileUtils.mkdir_p(ORIGINALS_DIR)

tracks = JSON.parse(open(API_ENDPOINT).read)
while remaining_images > 0
  track = tracks.shift
  puts "Getting art for #{track['title']}: #{remaining_images} left."
  if track_ids_checked.include? track['id']
    next
  else
    track_ids_checked << track['id']
  end
  artwork = track['download']['art']
  next if artwork.nil?

  begin
    data = open(artwork).read
    unless data.nil?
      img = Magick::Image::from_blob(data).first
      filename = "#{IMAGES_NEEDED - remaining_images}"
      format = img.format.downcase
      open("#{ORIGINALS_DIR}/#{filename}.#{format}", 'w').write(data)
      thumb = img.resize_to_fill(THUMB_SIZE[0], THUMB_SIZE[1])
      thumb.write("#{THUMB_DIR}/#{filename}.jpg")
      remaining_images = remaining_images - 1
    end
  rescue OpenURI::HTTPError => e
    # Just a network error.  Keep going.
  end

  if tracks.length == 0
    tracks = JSON.parse(open(API_ENDPOINT).read)
  end
end
