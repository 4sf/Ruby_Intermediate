require 'httparty'
require 'awesome_print'
require 'json'
require 'uri'
require 'nokogiri'

url = "https://api.telegram.org/bot"
token = "BotFather에서 받은 token"

response = HTTParty.get("#{url}#{token}/getUpdates")
hash = JSON.parse(response.body)

chat_id = hash["result"][0]["message"]["from"]["id"]

# KOSPI 지수 스크랩
res = HTTParty.get("http://finance.naver.com/sise/")
html = Nokogiri::HTML(res.body)
kospi = html.css('#KOSPI_now').text

# 로또 API로 로또 번호 가져오기
res = HTTParty.get("http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=784")
lotto = JSON.parse(res.body)

lucky = []

6.times do |n|
  lucky << lotto["drwtNo#{n+1}"]
end

bonus = lotto["bnusNo"]
winner = lucky.to_s

msg = "로또 번호는 #{winner} #{bonus}"
encoded = URI.encode(msg)

HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded}")
