require 'sinatra'
require 'image_suckr'

get '/' do
  suckr = ImageSuckr::GoogleSuckr.new
  image_url = suckr.get_image_url('q' => "Dire Straits")
  erb :index, locals: {
    lyric: lyrics.shuffle.first.strip.upcase,
    image_url: image_url
  }
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