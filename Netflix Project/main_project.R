# DATA ANALYSIS PROJECT - NETFLIX CATALOG
# by Henry Bertagna 



# 1. INITIAL STEPS : Load the libraries:
library(tidyverse)
library(lubridate)
library(showtext)
library(ggthemes)
library(patchwork)
library(RColorBrewer)

#2. DATA LOADING AND CLEANING
#----------------------------------------------------------------------

#Loading the dataset
netflix_csv <- read.csv("data/netflix_titles.csv")


#Load the font used in the project
font_add_google("Rubik", "rubik")
showtext_auto()

#Returns the sum of all empty lines
rowSums(is.na(netflix_csv))

#Initial cleaning and creation of new columns
netflix_cleaned <- netflix_csv %>% 
  filter(!is.na(release_year)) %>% 
  mutate(
    date_added = mdy(date_added),
    year_added = year(date_added),
    duration_num = parse_number(duration), #extracts only the number
    duration_type = str_extract(duration, "[A-Za-z]+") #extracts characters
  ) 
  
#3. ANALYSIS AND VISUALIZATION
#----------------------------------------------------------------------

#Calculates the percentage of each type of content
percent <- netflix_cleaned %>% 
  count(type) %>% 
  mutate(perc = n / sum(n),
         label = scales::percent(perc, accuracy = 0.1))

#First graph showing the percentage of each type of content
ggplot(percent, aes(x = type, y = n, fill = type)) +
  geom_col(size = 0.6, show.legend = FALSE) + 
  geom_text(aes(label = label), vjust = 3.75, color="white", size = 7, family= "rubik", fontface="bold")+
  scale_fill_manual(values = c("Movie" = "#b20710", "TV Show" = "#221f1f")) +
  labs(title = 'Number of Movies vs. TV Shows on Netflix', subtitle = "Movies represent more than double the number of series available on the platform", 
       x = NULL, y = NULL) + 
  theme_fivethirtyeight() +
  theme(
    text = element_text(family = "rubik"),
    axis.text.y = element_blank(),
    axis.text.x = element_text( family = "rubik", face = "bold", color = "white"),
    plot.background = element_rect(fill = "#787474", color = NA),
    panel.background = element_rect(fill = "#787474", color = NA),
    plot.title = element_text(color="white"),
    plot.subtitle = element_text(color="gray80"),
    axis.text = element_text(color="gray80"),
    axis.title = element_text(color = "white", face = "bold", size = 12),
    panel.grid.major = element_line(color = "gray30"),
    panel.grid.minor = element_line(color = "gray20"),
    )

#Second graph shows the number of contents added per year
netflix_cleaned %>%
  filter(!is.na(year_added)) %>%         
  count(year_added) %>%
  filter(n >= 20) %>%                       
  ggplot(aes(x = factor(year_added), y = n)) +
  geom_col(fill = "#6A1010") +
  labs(title = "Number of contents added per year",subtitle = "The volume of new titles has exploded since 2016, with a peak between 2018 and 2020",
       x = "Year", y = "Amount") +
  theme_fivethirtyeight()+ 
  theme(
    text = element_text(family = "rubik"),
    plot.background = element_rect(fill = "#787474", color = NA),
    panel.background = element_rect(fill = "#787474", color = NA),
    plot.title = element_text(color="white"),
    plot.subtitle = element_text(color="gray80"),
    axis.text = element_text(color="gray80"),
    axis.title = element_text(color = "white", face = "bold", size = 12),
    panel.grid.major = element_line(color = "gray30"),
    panel.grid.minor = element_line(color = "gray20"),
    axis.text.y = element_text(size = 12)
    )

#Creates a table with the annual count of Movies and TV Shows added since 2011
yearly_content_type <- netflix_cleaned %>% 
  filter(!is.na(year_added) & year_added >= 2011) %>% 
  group_by(year_added, type) %>% 
  summarise(qtd = n()) %>% 
  ungroup()

#Third graph shows the number of movies and TV shows added per year
ggplot(yearly_content_type, aes(x = year_added, y= qtd, color = type))+
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  scale_color_manual(values = c("Movie" = "#b20710", "TV Show" = "gray90"))+
  scale_x_continuous(breaks = unique(yearly_content_type$year_added)) +
  labs(title = "Evolution of movies and series added per year on Netflix", subtitle = "Despite the rapid growth of both formats, Netflix has consistently prioritized the addition of movies.",
       x = "Year", 
       y = "Amount", 
       color = "Type") + theme_fivethirtyeight() + 
  theme(
        text = element_text(family = "rubik"),
        plot.background = element_rect(fill = "#787474", color = NA),
        panel.background = element_rect(fill = "#787474", color = NA),
        plot.title = element_text(color="white"),
        plot.subtitle = element_text(color="gray80"),
        axis.text = element_text(color="gray95"),
        axis.title = element_text(color = "white", face = "bold", size = 12),
        panel.grid.major = element_line(color = "gray30"),
        panel.grid.minor = element_line(color = "gray20"),
        axis.text.y = element_text(size = 12),
        legend.position = "bottom", 
        legend.background = element_rect(fill = "#787474"), 
        legend.key = element_rect(fill = "#787474", color = NA), 
        legend.text = element_text(color = "white", size = 10), 
        legend.title = element_text(color = "white", face = "bold", size = 11)
        )

# Creates a count of titles by country, separating co-productions into individual lines
country_count <- netflix_cleaned %>% 
  filter(!is.na(country)) %>% 
  separate_rows(country, sep = ",") %>% 
  mutate(country = str_trim(country)) %>% 
  filter(country != "") %>% 
  count(country, sort = TRUE)



#Fourth graph shows the top 10 countries with the most content
country_count %>%  
  slice_max(n, n = 10) %>% 
  ggplot(aes(x = reorder(country, n), y = n, fill = country))+
  geom_col(show.legend = FALSE) +
  scale_fill_manual(values = netflix_colors)+
  coord_flip() +
  labs(title = "Top 10 Countries with the most titles on Netflix", subtitle = "While the US dominates the total volume, India shows the fastest growth in recent additions.", x = "Contry", y = "Number of titles") +
  theme_fivethirtyeight()+ 
  theme(text = element_text(family = "rubik"),
        plot.background = element_rect(fill = "#787474", color = NA),
        panel.background = element_rect(fill = "#787474", color = NA),
        plot.title = element_text(color="white"),
        plot.subtitle = element_text(color="gray80"),
        axis.text = element_text(color="gray95"),
        axis.title = element_text(color = "white", face = "bold", size = 12),
        panel.grid.major = element_line(color = "gray30"),
        panel.grid.minor = element_line(color = "gray20"),
        axis.text.y = element_text(size = 12)
        )

#Creates a filtered and organized table that returns the count of each genre
listed <- netflix_cleaned %>% 
  filter(!is.na(listed_in)) %>% 
  separate_rows(listed_in, sep = ",") %>%
  mutate(listed_in = str_trim(listed_in)) %>% 
  count(listed_in, sort = TRUE)

#Fifth graph shows the top 10 most common genres
listed %>% 
  slice_max(n , n =10) %>% 
  ggplot(aes(x = reorder(listed_in, n), y = n)) +
  geom_col(show.legend = FALSE, fill = "#8c0c13", width = 0.65) +
  scale_fill_manual(values = netflix_palette) +
  coord_flip() +
  labs(title = "Top 10 most common genres on Netflix",subtitle = "International content and dramas lead the way, showing the platform's focus on global productions and adult narratives.", x = "Genre", y = "Number of titles") +
  theme_fivethirtyeight() + 
  theme(text = element_text(family = "rubik"),
        plot.background = element_rect(fill = "#787474", color = NA),
        panel.background = element_rect(fill = "#787474", color = NA),
        plot.title = element_text(color="white"),
        plot.subtitle = element_text(color="gray80"),
        axis.text = element_text(color="gray95"),
        axis.title = element_text(color = "white", face = "bold", size = 12),
        panel.grid.major = element_line(color = "gray30"),
        panel.grid.minor = element_line(color = "gray20"),
        axis.text.y = element_text(size = 12),
        )

#Create a table that counts the amount of content added per year by each country
country_year <- netflix_cleaned %>% 
  filter(!is.na(country), !is.na(year_added)) %>% 
  separate_rows(country, sep = ",") %>% 
  mutate(country = str_trim(country)) %>% 
  filter(country != "") %>% 
  count(year_added, country, sort = TRUE)


#In this section I chose 5 countries to analyze, 2 Western and 3 Eastern
top_countries <- c("United States", "India", "United Kingdom", "South Korea", "Japan")

country_year_top <- country_year %>%
  filter(country %in% top_countries)

#Palette used for this graphic
myColors = c("#5e0308","#914747", "gray88", "#E50914", "#2b0000" )

#The sixth graph shows the evolution of bonds added per year by each country.
country_year_top %>% 
  ggplot(aes(x =  year_added, y = n, color = country)) +
  geom_line(size = 1.5, alpha = 0.8) +
  scale_color_manual(values = myColors) +
  labs(title = "Evolution of titles by countries on Netflix",subtitle = "Visualizing Netflix's globalization strategy through the growth of its key markets", x = "Year added", y = "Amount", color= "Country") + 
  theme_fivethirtyeight() +  scale_x_continuous(breaks = seq(2008, 2021, by = 2)) + 
  theme(text = element_text(family = "rubik"),
        plot.background = element_rect(fill = "#787474", color = NA),
        panel.background = element_rect(fill = "#787474", color = NA),
        plot.title = element_text(color="white"),
        plot.subtitle = element_text(color="gray80"),
        axis.text = element_text(color="gray95"),
        axis.title = element_text(color = "white", face = "bold", size = 12),
        panel.grid.major = element_line(color = "gray30"),
        panel.grid.minor = element_line(color = "gray20"),
        axis.text.y = element_text(size = 12),
        legend.position = "bottom", 
        legend.background = element_rect(fill = "#787474"), 
        legend.key = element_rect(fill = "#787474", color = NA), 
        legend.text = element_text(color = "white", size = 10), 
        legend.title = element_text(color = "white", face = "bold", size = 11)
        )

#Separates only valid ratings for analysis
valid_ratings <- c("TV-MA", "R", "PG-13", "TV-14", "PG", "TV-PG", "TV-Y", "TV-Y7", "TV-G", "G", "NC-17", "NR", "UR")

netflix_ratings_cleaned <- netflix_cleaned %>%
  filter(rating %in% valid_ratings)

#Take only the top 7 ratings
top_ratings_cleaned <- netflix_ratings_cleaned %>%
  count(rating, sort = TRUE) %>%
  slice_max(n, n = 7) %>%
  pull(rating)

#Creates a table that counts each rating
rating_by_type_cleaned <- netflix_ratings_cleaned %>%
  filter(rating %in% top_ratings_cleaned) %>%
  count(type, rating) %>%
  group_by(type) %>%
  mutate(percent = n / sum(n)) %>%
  mutate(
    rating = factor(rating, levels = c("TV-MA", "R", "PG-13", "TV-14", "PG", "TV-PG", "TV-Y", "TV-G", "TV-Y7"))
  )


#Palette used for this graphic
test_palette <- c(
  "TV-MA" = "#831010",   
  "R" = "#B20710",      
  "PG-13" = "#E50914",   
  "TV-14" = "#8C8C8C",  
  "PG" = "#B0B0B0",     
  "TV-PG" = "#DCDCDC",  
  "TV-Y" = "#FFFFFF",   
  "TV-G" = "#F5F5F1"    
)

#The seventh graph shows the distribution of each rating by type (Movies and TV shows).
ggplot(rating_by_type_cleaned, aes(x = type, y=percent , fill = rating)) +
  geom_col() +
  scale_fill_manual(values = test_palette) +
  labs(title = "Age Distribution by Content Type on Netflix",subtitle = "Films have a higher concentration of mature ratings (TV-MA, R) compared to series.", x = NULL , y = "Proportion (%)", fill = "Age Rating")+
  theme_fivethirtyeight() + 
  theme(text = element_text(family = "rubik"),
        plot.background = element_rect(fill = "#787474", color = NA),
        panel.background = element_rect(fill = "#787474", color = NA),
        plot.title = element_text(color="white"),
        plot.subtitle = element_text(color="gray80"),
        axis.text = element_text(color="gray95"),
        axis.title = element_text(color = "white", face = "bold", size = 12),
        panel.grid.major = element_line(color = "gray30"),
        panel.grid.minor = element_line(color = "gray20"),
        axis.text.y = element_text(size = 12),
        legend.position = "bottom", 
        legend.background = element_rect(fill = "#787474"), 
        legend.key = element_rect(fill = "#787474", color = NA), 
        legend.text = element_text(color = "white", size = 10), 
        legend.title = element_text(color = "white", face = "bold", size = 11)
        )

#Take the top 8 countries with the most content
top_8_countries <- country_count %>% 
  slice_max(n, n=8) %>% 
  pull(country)

#Take the top 10 most common genres
top_10_genres <- listed %>% 
  slice_max(n, n =10) %>% 
  pull(listed_in)

#Create a table that prepares the heatmap for Countries vs. Genres
country_genre_data <- netflix_cleaned %>% 
  filter(!is.na(country) & !is.na(listed_in)) %>%
  separate_rows(country, sep = ", ") %>%
  mutate(country = str_trim(country)) %>%
  separate_rows(listed_in, sep = ", ") %>%
  mutate(listed_in = str_trim(listed_in)) %>%
  filter(country %in% top_8_countries & listed_in %in% top_10_genres) %>% 
  count(country, listed_in, sort = TRUE) %>% 
  mutate(
    country = fct_reorder(country, n, .fun = 'sum', .desc = FALSE),
    listed_in = fct_reorder(listed_in, n, .fun = 'sum', .desc = TRUE)
)

#Eighth graph shows the heatmap
ggplot(country_genre_data, aes(x=listed_in, y=country, fill = n)) +
  geom_tile(color = "white", lwd = 0.5) +
  geom_text(aes(label = n), color = "black", size = 3) +
  scale_fill_gradient(low = "#fee8c8", high = "#B20710") + 
  labs(
    title = "Content Specialties by Country",
    subtitle = "What each country produces most for Netflix",
    x = "Genre",
    y = "Country",
    fill = "Number of Titles") +
  theme_fivethirtyeight() + 
  theme(
    text = element_text(family = "rubik"),
    axis.text.x = element_text(angle = 45, hjust = 1, color = "gray95", family = "rubik", face = "bold"),
    legend.position = "none",
    axis.text = element_text(family = "rubik", color = "gray95"),
    plot.background = element_rect(fill = "#787474", color = NA),
    panel.background = element_rect(fill = "#787474", color = NA),
    plot.title = element_text(color="white"),
    plot.subtitle = element_text(color="gray90", family ="rubik"),
    axis.text.y = element_text(face = "bold", color = "gray95", family = "rubik"),
    axis.title = element_text(color = "white", face = "bold", size = 12),
    panel.grid.major = element_line(color = "gray30"),
    panel.grid.minor = element_line(color = "gray20")
  )

#Prepares the data for the monthly timeline graph
monthly_additions <- netflix_cleaned %>% 
  filter(!is.na(date_added)) %>% 
  mutate(
    year_added = year(date_added), 
    month_added = month(date_added)
  ) %>% 
  count(year_added, month_added, name = "count") %>% 
  mutate(date = make_date(year = year_added, month = month_added, day = 1)) %>% 
  filter(date >= "2015-01-01")

#Ninth graph shows content added per month
ggplot(monthly_additions, aes(x = date, y = count)) +
  geom_line(color = "#B20710", size = 1) +
  geom_point(color = "#B20710", alpha = 0.5)+
  annotate("rect",
           xmin = as.Date("2018-01-01"), xmax = as.Date("2019-12-31"),
           ymin = -Inf, ymax = Inf,
           alpha = 0.1, fill = "blue") +
  annotate("text", as.Date("2019-02-01"), y = 230,
           label="Hyper Growth Period", family = "rubik", color = "gray90", fontface = "bold", size = 4) +
  geom_vline(xintercept = as.Date("2021-01-01"), 
             linetype = "dashed", color = "gray90", size = 1)+
  labs(title = "Peak content additions on Netflix (Monthly)",
       subtitle = "The graph highlights the pre-pandemic ‘hyper-growth’ and the subsequent drop in pace from 2021 onwards (dotted line).", 
       x= "Date added", y="Number of titles added") + 
  scale_x_date(date_labels = "%b %Y", date_breaks = "1 year") +
  theme_fivethirtyeight() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    text = element_text(family = "rubik"),
    plot.background = element_rect(fill = "#787474", color = NA),
    panel.background = element_rect(fill = "#787474", color = NA),
    plot.title = element_text(color="white"),
    plot.subtitle = element_text(color="gray80"),
    axis.text = element_text(color="gray95"),
    axis.title = element_text(color = "white", face = "bold", size = 12),
    panel.grid.major = element_line(color = "gray30"),
    panel.grid.minor = element_line(color = "gray20"),
    axis.text.y = element_text(size = 12)
  )

#Calculates the 10 most common series lengths (in number of seasons)
seasons_count <- netflix_cleaned %>% 
  filter(type == "TV Show") %>% 
  count(duration, sort = TRUE) %>% 
  mutate(num_seasons = parse_number(duration)) %>% 
  slice_max(order_by = n, n =10)

#Separate only the top 10 amounts of seasons
top_10_seasons <- seasons_count %>% 
  slice_max(n, n =10)

#Tenth graph shows the number of the most common seaons in series
tvshows_top10 <- ggplot(top_10_seasons, aes(x = reorder(duration, num_seasons), y = n))+
  geom_col(fill = "#B20710", show.legend = FALSE) +
  geom_text(aes(label = n), hjust = -0.2, color = "#5e0308", size = 4, fontface = "bold") +
  coord_flip() +
  scale_y_continuous(limits = c(0, max(seasons_count$n) * 1.1)) +
  labs(
    title = "Series: Focus on short productions", subtitle = "Most only have 1 season",
    x = NULL, y = NULL
    ) + 
  theme_fivethirtyeight()+
  theme(
    text = element_text(family = "rubik"),
    plot.background = element_rect(fill = "#787474", color = NA),
    panel.background = element_rect(fill = "#787474", color = NA),
    plot.title = element_text(color="white"),
    plot.subtitle = element_text(color="gray90"),
    axis.text = element_text(color="gray95"),
    axis.title = element_text(color = "white", face = "bold", size = 12),
    panel.grid.major = element_line(color = "gray30"),
    panel.grid.minor = element_line(color = "gray20"),
    axis.text.y = element_text(size = 12)
  )



#Eleventh graph shows the minute count of the movies
plot_movies <- netflix_cleaned %>% 
  filter(type == "Movie", !is.na(duration_num)) %>% 
  ggplot(aes(x = duration_num)) +
  geom_histogram(binwidth = 10, fill = "#B20710", color = "white", alpha = 0.95)+
  geom_vline(xintercept = avg_movie_duration,
             color = "gray80", linetype= "dashed", size = 1)+
  labs(title = "Movies : Consistent pattern", subtitle = paste0("Concentration between 85-120 min.\nThe dotted line indicates the average: ", rounded_avg, "min."),
        x = "Duration (Minutes) ", y= "Count") + 
  theme_fivethirtyeight() +
  theme(text = element_text(family = "rubik"),plot.background = element_rect(fill = "#787474", color = NA), panel.background = element_rect(fill = "#787474", color = NA),
        plot.title = element_text(color="white"),
        plot.subtitle = element_text(color="gray90"),
        axis.text = element_text(color="gray95"),
        axis.title = element_text(color = "white", face = "bold", size = 12),
        panel.grid.major = element_line(color = "gray30"),
        panel.grid.minor = element_line(color = "gray20")) +
  scale_x_continuous(breaks = seq(0 , 250, by = 30))+
  coord_cartesian(xlim = c(0,250))

#Calculates the average minutes of movies
avg_movie_duration <- netflix_cleaned %>% 
  filter(type == "Movie") %>% 
  summarise(mean_duration = mean(duration_num, na.rm = TRUE)) %>% 
  pull(mean_duration)

rounded_avg <- round(avg_movie_duration)


#Combine the two graphs in a single dashboard           
duration_dashboard <- tvshows_top10 + plot_movies


#Adjust the dashboard for visualization
final_dashboard <- duration_dashboard + plot_annotation(
  title = "Predictable Movies, Disposable Series?", 
  subtitle = "The format of the series favors short productions, while the films follow a cinematic pattern.",
  caption = "Analysis by Henry Bertagna",
  theme = theme(
    plot.background = element_rect(fill = "#787474", color = NA),
    plot.title = element_text(size = 22, family = "rubik", face = "bold", hjust = 0.5, color = "#B20710"),
    plot.subtitle = element_text(size = 16, family = "rubik", hjust = 0.5, margin = margin(t = 5, b=20), color = "white"),
    plot.caption = element_text(size = 10, family = "rubik", hjust = 0.9)
  ))
  

final_dashboard
