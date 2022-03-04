#loading the libraries
library(rvest)
library(stringr)

# this url contains the details of Top 250 TV series based on the number of ratings
url = 'https://www.imdb.com/chart/toptv/?sort=nv,desc&mode=simple&page=1'

imdb = read_html(url)

#scraping urls of top 250 TV shows
name = html_nodes(imdb,'.lister-list > tr > td:nth-child(2) > a')

# urls we scraped above doesn't have "https://www.imdb.com" included in the start of the urls, we are adding that by pasting it in front of each urls.
links = paste0("https://www.imdb.com", html_attr(name, "href"))


#the code below is used for scraping the name of the series
# we are getting the names of the series by using html_text function and adding that into 
name_of_series = html_text(name)
name_of_series=c(name_of_series)
name_of_series


## number of episode 
# we created the empty vector to add all the values we scrap.
# we used for loop to iterate each url in the links and scrap the respective values from the links
## we used as.numeric function to transform the values as numeric.

number_of_episodes=c()
for (i in 1:length(links)) {
  tv_link = read_html(links[i])
  numb = html_node(tv_link,'a.bp_item > div:nth-child(1) > div:nth-child(1) > span:nth-child(2)')
  numb2 = html_text(numb)
  num3 = as.numeric(substr(numb2,1,regexpr("e",numb2)-2))
  number_of_episodes[i]=num3
}
number_of_episodes

#number of seasons
# we created the empty vector to add all the values we scrap.
# we used for loop to iterate each url in the links and scrap the respective values from the links
## we used as.numeric function to transform the values as numeric.
# there was a problem with the 103rd value, so we have to run the loop again from 104th link to the end

number_of_seasons = c()
for (i in 1:length(links)) { 
  tv_link = read_html(links[i])
  seasons =html_nodes(tv_link,'.seasons-and-year-nav > div:nth-child(4) > a:nth-child(1)')
  number_of_seasons[i] = as.numeric(html_text(seasons))
}
for (i in 104:length(links)) { 
  tv_link = read_html(links[i])
  seasons =html_nodes(tv_link,'.seasons-and-year-nav > div:nth-child(4) > a:nth-child(1)')
  number_of_seasons[i] = as.numeric(html_text(seasons))
}
number_of_seasons

#genre
# we created the empty vector to add all the values we scrap.
# we used for loop to iterate each url in the links and scrap the respective values from the links
genre = c()
for (i in 1:length(links)) { 
  tv_link = read_html(links[i])
  genre_raw = html_nodes(tv_link,'.subtext > a[href^="/search"]')
  genre[i] = html_text(genre_raw)  
}
genre

#end year and start year
# we created empty vectors for both end year and start year.
# used for to loop through each url from the links
#used html_text to get the text part from the html_nodes
# we used substr,regexpr function to get the start year and end year from the string that had both the values together

end_year=c()
release_year = c()
for (i in 1:length(links)) {
  tv_link = read_html(links[i])
  release = html_node(tv_link,'.subtext > a:last-child')
  rele = html_text(release)
  release_year[i] = as.numeric(substr(rele,regexpr('s',rele)+3,regexpr('s',rele)+6))
  end_years = as.numeric(substr(rele,regexpr("s",rele)+8,regexpr("s",rele)+11))
  end_year[i]=end_years
}
end_year
release_year

# average runtime of episodes
# we created empty vectors for both end year and start year.
# used for to loop through each url from the links
# used html_text to get the text part from the html_nodes
# we used trimws function to remove all the whitespace from the texts.

runtime=c()
for (i in 1:length(links)) {
  tv_link = read_html(links[i])
  r = html_node(tv_link,'.subtext > time:nth-child(2)')
  run1 = html_text(r)
  runtime[i] = trimws(str_remove_all(run1,"\n"), which = c("both", "left", "right"), whitespace = "[ \t\r\n]")
}
runtime


## ratings
# we created the empty vector to add all the values we scrap.
# we used for loop to iterate each url in the links and scrap the respective values from the links
## we used as.numeric function to transform the values as numeric.

ratings=c()
for (i in 1:length(links)) {
  tv_link = read_html(links[i])
  rate = html_node(tv_link,'.ratingValue > strong:nth-child(1) > span:nth-child(1)')
  rate1 = as.numeric(html_text(rate))
  ratings[i]=rate1
}
ratings

#number of raters
# we created the empty vector to add all the values we scrap.
# we used for loop to iterate each url in the links and scrap the respective values from the links
# we removed the comma in between the numbers using gsub function.
number_of_raters = c()
for (i in 1:length(links)) { 
  tv_link = read_html(links[i])
  raters = html_nodes(tv_link,'span.small')
  number_of_raters[i] = as.numeric(gsub(",", "", html_text(raters)))
}
number_of_raters

# number of reviews #problem
# we created empty vectors named number_of_reviews to store the values we scraped
# used for to loop through each url from the links
# used html_text to get the text part from the html_nodes
# we used as.numeric, substr,regexpr function to get the required number_of_reviews

number_of_reviews = c()
for (i in 1:172) { 
  tv_link = read_html(links[i])
  reviews = html_nodes(tv_link,'div.titleReviewBarItem:nth-child(1) > div:nth-child(2) > span:nth-child(1) > a:nth-child(1)')
  number_of_reviews_text = gsub(",", "", html_text(reviews))
  number_of_reviews[i] = as.numeric(substr(number_of_reviews_text,1,regexpr('u',number_of_reviews_text)-1))
}
for (i in 173:length(links)) { 
  tv_link = read_html(links[i])
  reviews = html_nodes(tv_link,'div.titleReviewBarItem:nth-child(1) > div:nth-child(2) > span:nth-child(1) > a:nth-child(1)')
  number_of_reviews_text = gsub(",", "", html_text(reviews))
  number_of_reviews[i] = as.numeric(substr(number_of_reviews_text,1,regexpr('u',number_of_reviews_text)-1))
}
number_of_reviews

# number of critic reviews 
# we created empty vectors named number_of_critics_reviews to store the values we scraped
# used for to loop through each url from the links
# used html_text to get the text part from the html_nodes
# we used as.numeric, substr,regexpr function to get the required number_of_critics_reviews

number_of_critics_reviews = c()
for (i in 1:length(links)) {
  tv_link = read_html(links[i])
  critics = html_nodes(tv_link,'div.titleReviewBar> div.titleReviewbarItemBorder > div:nth-child(2) > span:nth-child(1)')
  critics_text = html_text(critics)
  number_of_critics_reviews[i] = as.numeric(substr(critics_text,regexpr('c',critics_text)-4,regexpr('c',critics_text)-1))
}
number_of_critics_reviews

#getting urls for keywords
keyword_urls = c()
for (i in 1:length(links)) {
  tv_link = read_html(links[i])
  key_word_url = html_node(tv_link,'nobr > a:nth-child(1)')
  keyword_urls[i] = html_attr(key_word_url, "href")
}

#pasting the missing "https://www.imdb.com" in front of the scraped urls
keywords = paste0("https://www.imdb.com",keyword_urls)

#scraping keywords as a string 

keywords_string = c()
for (i in 1:length(keywords)) {
  kw_link = read_html(keywords[i])
  kw_link1 = html_nodes(kw_link,'div.sodatext')
  kw_text = html_text(kw_link1)
  kw_text = trimws(kw_text, which = c("both", "left", "right"), whitespace = "[ \t\r\n]")
  keywords_string[i] = paste(kw_text, collapse = " ")
}


# creating dataframe
# we created data frame using pandas function and gave name for each column in the dataframe
imdb_df = data.frame(name_of_series, number_of_episodes, number_of_seasons, genre, release_year, end_year, runtime, ratings, number_of_raters, number_of_reviews, number_of_critics_reviews, keywords_string)
names(imdb_df)=c("Series_Name","Number_of_episodes","Number_of_seasons","Genre","Year_released","End_year","Avg_runtime","Rating","Number_of_raters","Number_of_reviews","Number_of_critics_review","Keywords")
imdb_df

# we have extracted the dataframe as tab delimited file
write.table(imdb_df,file = "ImdbTvSeries.txt", sep="\t")

