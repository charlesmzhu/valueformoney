class StaticPagesController < ApplicationController	
	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'

	def index
		@nodearray = []
		if params[:city]
			(0..150).step(10) do |n|
				url = "http://www.yelp.com/search?find_loc=" + params[:city].gsub(/\s+/, '') + "&start=#{n}"
				page = Nokogiri::HTML(open(url, 'User-Agent' => 'jonbiagiotti'))
				nodeset = page.css('.biz-listing-large')
				nodeset.each do |item|
					if item.at_css(".media-story .business-attribute")
						bizname = "<a href='http://yelp.com" + item.at_css(".biz-name")['href'] + "'>" + item.at_css(".biz-name", 'utf-8').inner_html + "</a>"
						bizname = bizname.html_safe
						reviews = item.css(".media-story .biz-rating").text.gsub("\n", "").strip
						dollars = item.at_css(".media-story .business-attribute").text
						stars = item.at_css(".main-attributes .media-story img").attr("alt")
						vfm = (stars[0,3].to_f*2.5)-(dollars.count('$').to_f)
						address = item.css("address").inner_html.gsub("<br>", ', ')
						node = [vfm, bizname, reviews, dollars, stars, address]
						@nodearray << node if dollars
					end
				end
			end
			@nodearray = @nodearray.sort.reverse
		end
	end
end

#<a data-hovercard-id="jG1qMpA9MlYZCLGvCakwVA" href="/biz/samuel-adams-brewery-boston" class="biz-name">Samuel Adams Brewery</a>
#<i title="4.5 star rating" class="star-img stars_4_half">
 #           <img height="303" width="84" src="http://s3-media3.ak.yelpcdn.com/assets/2/www/img/7d58085d03a1/ico/stars/v2/stars_map.png" class="offscreen" alt="4.5 star rating">



# .rating-qualifier

#<div class="media-story"> <h3 class="search-result-title"> <span class="indexed-biz-name">1. <a class="biz-name" href="/biz/polcaris-coffee-boston" data-hovercard-id="VmECIDTMsDPDb2gpOudu3Q">Polcari's Coffee</a> </span> </h3> <div class="biz-rating biz-rating-large clearfix"> <div class="rating-large"> <i class="star-img stars_5" title="5.0 star rating"> <img alt="5.0 star rating" class="offscreen" height="303" src="http://s3-media3.ak.yelpcdn.com/assets/2/www/img/7d58085d03a1/ico/stars/v2/stars_map.png" width="84"></i> </div> <span class="review-count rating-qualifier"> 89 reviews </span> </div> <div class="price-category"> <span class="bullet-after"> <span class="business-attribute price-range">$</span> </span> <span class="category-str-list"> <a href="/search?find_loc=boston&amp;cflt=coffee">Coffee &amp; Tea</a> </span> </div> <ul class="tags"></ul> </div><div class="media-story"> <h3 class="search-result-title"> <span class="indexed-biz-name">

#.biz-listing-large
#address