require 'sinatra'
require 'net/http'
require 'json'
require 'uri'

FALLBACK_IMAGES = [
  "https://upload.wikimedia.org/wikipedia/commons/4/45/GuitareClassique5.png",
  "https://upload.wikimedia.org/wikipedia/commons/4/4e/Sunburst_Gibson_Les_Paul_Custom.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/a/a2/Fender_Stratocaster_001.jpg"
].freeze

get '/' do
  erb :index, locals: {
    lyric: lyrics.sample.strip.upcase,
    image_url: fetch_random_image("Dire Straits")
  }
end

def fetch_random_image(query)
  url = URI("https://commons.wikimedia.org/w/api.php")
  url.query = URI.encode_www_form(
    action: "query",
    generator: "search",
    gsrsearch: query,
    gsrnamespace: 6,
    gsrlimit: 20,
    prop: "imageinfo",
    iiprop: "url",
    format: "json"
  )

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.open_timeout = 5
  http.read_timeout = 5

  request = Net::HTTP::Get.new(url)
  request["User-Agent"] = "MoneyForNothin/1.0 (fun Dire Straits lyrics app)"

  response = http.request(request)
  data = JSON.parse(response.body)

  pages = data.dig("query", "pages") || {}
  images = pages.values.map { |p| p.dig("imageinfo", 0, "url") }.compact
  images.empty? ? FALLBACK_IMAGES.sample : images.sample
rescue => e
  puts "Image fetch error: #{e.message}"
  FALLBACK_IMAGES.sample
end

def lyrics
  %{ Now look at them yo-yo's that's the way you do it
    You play the guitar on the MTV
    That ain't workin' that's the way you do it
    Money for nothin' and chicks for free
    Now that ain't workin' that's the way you do it
    Lemme tell ya them guys ain't dumb
    Maybe get a blister on your little finger
    Maybe get a blister on your thumb
    We gotta install microwave ovens
    Custom kitchen deliveries
    We gotta move these refrigerators
    We gotta move these color TV's
    See the little faggot with the earring and the make-up
    Yeah buddy that's his own hair
    That little faggot got his own jet airplane
    That little faggot he's a millionaire
    We gotta install microwave ovens
    Custom kitchen deliveries
    We gotta move these refrigerators
    We gotta move these color TV's
    I shoulda' learned to play the guitar
    I shoulda' learned to play them drums
    Look at that mama, she got it stickin' in the camera
    Man we could have some fun
    And he's up there, what's that? Hawaiian noises?
    Bangin' on the bongos like a chimpanzee
    That ain't workin' that's the way you do it
    Get your money for nothin' get your chicks for free }.split("\n")
end