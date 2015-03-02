require "rubygems"
require "mechanize"
require "open-uri"
require "pry"

BASE_URL = "https://www.endomondo.com/routes"
cookie = "JSESSIONID=3412DC5CA42E04F0258BEF08DD80B1A8; AWSELB=87FBB1DF06CB5333011593EA47F6302B44EB6F00A1A61FDC8CB6BCC0CA35B45F89F1EB269CCF2438A6BF7DAC91D87004313DD03FBA82E298A4617BCF1D3EC42CBA02BC4FD5B027C5B183C5624F13E816625929AE8B; USER_TOKEN=9%2FYSzKbKHTfBSnrzNt2hL%2FZajV7s4h07yhl5hDKUS42gbjo18Bjezxf1mHjoFQOzR%2BwKXy%2BMoGvaKS8LDFmVX4y%2FMJspZPYtSl3hC8aS2AM%3D; routes-explorer_map_pos={\"center\":{\"lat\":1.3444861304821498,\"lng\":103.72655009999994},\"zoom\":16}"

headers = {
  "Origin"      => "https://endomondo.com/",
  "Cookie"      => cookie,
  "Referer"     => "https://www.endomondo.com/home/",
  "User-Agent"  => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.115 Safari/537.36",
  "Wicket-Ajax" => "true"
}


agent = Mechanize.new

session_cookie = Mechanize::Cookie.new domain: "www.endomondo.com", name: "JSESSIONID", value: "3412DC5CA42E04F0258BEF08DD80B1A8", path: "/"
awselb_cookie  = Mechanize::Cookie.new domain: "www.endomondo.com", name: "AWSELB", value: "87FBB1DF06CB5333011593EA47F6302B44EB6F00A1A61FDC8CB6BCC0CA35B45F89F1EB269CCF2438A6BF7DAC91D87004313DD03FBA82E298A4617BCF1D3EC42CBA02BC4FD5B027C5B183C5624F13E816625929AE8B", path: "/"
user_cookie    = Mechanize::Cookie.new domain: "www.endomondo.com", name: "USER_TOKEN", value: "9%2FYSzKbKHTfBSnrzNt2hL%2FZajV7s4h07yhl5hDKUS42gbjo18Bjezxf1mHjoFQOzR%2BwKXy%2BMoGvaKS8LDFmVX4y%2FMJspZPYtSl3hC8aS2AM%3D", path: "/"
routes_cookie  = Mechanize::Cookie.new domain: "www.endomondo.com", name: "routes-explorer_map_pos", value: "{'center':{'lat':1.3615874968643769,'lng':103.79331353515627},'zoom':12}", path: "/"


agent.cookie_jar << session_cookie
agent.cookie_jar << awselb_cookie
agent.cookie_jar << user_cookie
agent.cookie_jar << routes_cookie

agent.get(BASE_URL)

form = agent.page.forms[0]
form.radiobutton_with(value: /0/).check

routes_container = agent.page.search ".leftcontainer"
binding.pry
