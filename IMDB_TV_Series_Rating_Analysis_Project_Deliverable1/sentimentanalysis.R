#install.packages('wordcloud')
#install.packages('udpipe')
#install.packages('textdata') 

library(wordcloud)
library(udpipe)
library(lattice)

library(tidyverse)
library(tidyr)
library(tidytext)

library(SnowballC)
library(tm)

#getting the present working dictionary
getwd()

#reading the csv file we scraped
data_csv = read.csv("imdbseries1.csv",header = T,sep = ",")

#selecting the Keywords column to analyse for sentiment
series_keywords = select(data_csv, seriesid, Keywords)

#unnesting the keyword string as individual tokens
tidy_dataset = unnest_tokens(series_keywords, word, Keywords)

counts = count(tidy_dataset, word)
result1 = arrange(counts, desc(n))

#preparing the data
#removing the stop words
data("stop_words")
tidy_dataset2 = anti_join(tidy_dataset, stop_words)
counts2 = count(tidy_dataset2, word)
arrange(counts2, desc(n))

#removing the numerical values

patterndigits = '\\b[0-9]+\\b'
tidy_dataset2$word = str_replace_all(tidy_dataset2$word, patterndigits, '')
counts3 = count(tidy_dataset2, word)
arrange(counts3, desc(n))

#using regular expressions, replace all new lines, tabs, and blank spaces and then filter out those values

tidy_dataset2$word = str_replace_all(tidy_dataset2$word, '[:space:]', '')
tidy_dataset3 = filter(tidy_dataset2,!(word == ''))
counts4 = count(tidy_dataset3, word)
arrange(counts4, desc(n))

#plot the words in the dataset with a proportion greater than 0.5.

frequency = tidy_dataset3 %>%
  count(word) %>%
  arrange(desc(n)) %>%
  mutate(proportion = (n / sum(n)*100)) %>%
  filter(proportion >= 0.5)

library(scales)

ggplot(frequency, aes(x = proportion, y = word)) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_color_gradient(limits = c(0, 0.001), low = "darkslategray4", high = "gray75") +
  theme(legend.position="none") +
  labs(y = 'Word', x = 'Proportion')

#removing the most frequent words

list_remove = c('title','tv','series','character','relationship','male','female','based')
tidy_dataset4 = filter(tidy_dataset3, !(word %in% list_remove))
counts5 = count(tidy_dataset4, word)
arrange(counts5, desc(n))

#stemming the words

tidy_dataset5 = mutate_at(tidy_dataset4, "word", funs(wordStem((.), language="en")))
counts6 = count(tidy_dataset5, word)
td5 = arrange(counts6, desc(n))

#getting positive and negative sentiment scores

newjoin = inner_join(td5, get_sentiments('bing'))
counts7 = count(newjoin, word, sentiment)
spread1 = spread(counts7, sentiment, n, fill = 0)
content_data = mutate(spread1, contentment = positive - negative, linenumber = row_number())
keyword_positive_negative = arrange(content_data, desc(contentment))

#filtering and analysing the positive words alone
positive = newjoin %>% 
  filter(sentiment == "positive")

positive2 = positive[1:15,1:2]
positive2 = rename(positive2, freq=n)


#frequency plot for top 10 positive words
colourCount = length(unique(positive2$word))
getPalette = colorRampPalette(brewer.pal(9, "Set1"))

positive2 %>%
  mutate(word = reorder(word, freq)) %>%
  ggplot(aes(x = word, y = freq)) +
  geom_col(fill = getPalette(colourCount)) +
  coord_flip()

# negative sentiment
negative = newjoin %>% 
  filter(sentiment == "negative")

negative2 = negative[1:15,1:2]
negative2 = rename(negative2, freq=n)


#frequency plot for top 10 negative words
colourCount = length(unique(negative2$word))
getPalette = colorRampPalette(brewer.pal(9, "Set1"))

negative2 %>%
  mutate(word = reorder(word, freq)) %>%
  ggplot(aes(x = word, y = freq)) +
  geom_col(fill = getPalette(colourCount)) +
  coord_flip()

write.csv(newjoin,file="Pos_neg.csv", row.names = FALSE)

#plot for top 20 positive words and top 20 negative words

(keyword_positive_negative2 = keyword_positive_negative %>%
    slice(1:10,355:364))
ggplot(keyword_positive_negative2, aes(x=linenumber, y=contentment, fill=word)) +
  coord_flip() +
  theme_light(base_size = 15) +
  labs(
    x='Index Value',
    y='Contentment'
  ) +
  theme(
    legend.position = 'bottom',
    panel.grid = element_blank(),
    axis.title = element_text(size = 10),
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10)
  ) +
  geom_col()

#sentiment score for joy $ sad

nrc_joysad = get_sentiments('nrc') %>%
  filter(sentiment == 'joy' | 
           sentiment == 'sadness')

nrow(nrc_joysad)

newjoin2 = inner_join(td5, nrc_joysad)
counts8 = count(newjoin2, word, sentiment)
spread2 = spread(counts8, sentiment, n, fill = 0)
content_data = mutate(spread2, contentment = joy - sadness, linenumber = row_number())
keywords_joysad = arrange(content_data, desc(contentment))

# joy sentiment
joy = newjoin2 %>% 
  filter(sentiment == "joy")

joy2 = joy[1:15,1:2]
joy2 = rename(joy2, freq=n)


#frequency plot for top 10 joy words
colourCount = length(unique(joy2$word))
getPalette = colorRampPalette(brewer.pal(9, "Set1"))

joy2 %>%
  mutate(word = reorder(word, freq)) %>%
  ggplot(aes(x = word, y = freq)) +
  geom_col(fill = getPalette(colourCount)) +
  coord_flip()

# sad sentiment
sad = newjoin2 %>% 
  filter(sentiment == "sadness")

sad2 = sad[1:15,1:2]
sad2 = rename(sad2, freq=n)


#frequency plot for top 10 sad words
colourCount = length(unique(sad2$word))
getPalette = colorRampPalette(brewer.pal(9, "Set1"))

sad2 %>%
  mutate(word = reorder(word, freq)) %>%
  ggplot(aes(x = word, y = freq)) +
  geom_col(fill = getPalette(colourCount)) +
  coord_flip()

#writing the newjoin2 as csv to find the overall joy sad sentiment
write.csv(newjoin2,file="Joy_Sad.csv", row.names = FALSE)

#Creating a plot for the top 20 values for joy and sadness

(keywords_joysad2 = keywords_joysad %>%
    slice(1:20,211:230))
ggplot(keywords_joysad2, aes(x=linenumber, y=contentment, fill=word)) +
  coord_flip() +
  theme_light(base_size = 15) +
  labs(
    x='Index Value',
    y='Contentment'
  ) +
  theme(
    legend.position = 'bottom',
    panel.grid = element_blank(),
    axis.title = element_text(size = 10),
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10)
  ) +
  geom_col()

