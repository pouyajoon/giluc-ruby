json.array!(@songs) do |song|
  json.extract! song, :id, :name, :chords
  json.url song_url(song, format: :json)
end
