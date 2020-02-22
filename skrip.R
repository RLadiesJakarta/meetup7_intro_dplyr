setwd('D:\\r ladies jkt 7')

########################################################################################################
#dplyr is a new package which provides a set of tools for efficiently manipulating datasets in R.  
#dplyr is the next iteration of plyr, focussing on only data frames. dplyr is faster, 
#has a more consistent API and should be easier to use. There are three key ideas that underlie dplyr:
#  
#1.  Your time is important, so Romain Francois has written the key pieces in Rcpp to 
#provide blazing fast performance. Performance will only get better over time, 
#especially once we figure out the best way to make the most of multiple processors.
#
#2. Tabular data is tabular data regardless of where it lives, 
#so you should use the same functions to work with it. With dplyr, 
#anything you can do to a local data frame you can also do to a remote database table. 
#PostgreSQL, MySQL, SQLite and Google bigquery support is built-in; 
#adding a new backend is a matter of implementing a handful of S3 methods.
#
#3. The bottleneck in most data analyses is the time it takes for you to figure out 
#what to do with your data, and dplyr makes this easier 
#by having individual functions that correspond 
#to the most common operations (group_by, summarise, mutate, filter, select and arrange). 
#Each function does one only thing, but does it well.
#
########################################################################################################

#dataset: https://www.kaggle.com/claudiodavi/superhero-set/

library(tidyverse)
ds<-as_tibble(read.csv("ds.csv"))

#1. What is dplyr?
#2. Select and drop columns
#3. Reorder columns
#4. Rename and reformat columns
#5. Select and filter rows
#6. Data sorting
#7. Create new variable
#8. Summarize data
#9. Dplyr and ggplot integration

library(vtable)
#check variables of the dataset
vtable(ds, index=T)

#Select and drop columns by name

#Select column by name
select(ds, Eye.color, Race)

#Select many columns
select(ds, name:Hair.color)

#Drop column
select(ds, -Gender, -Hair.color)
select(ds, -c(Gender, Hair.color))

#Now let's use the pipe operater %<%

ds %>% 
  select(Eye.color,Race)

ds %>% 
  select(-c(Gender, Hair.color))

ds %>% 
  select(name:Hair.color)

#Select and drop by columns number

ds %>% 
  select(3,5)

ds %>% 
  select(1:4)

ds %>% 
  select(-3,-5)

ds %>% 
  select(-c(1:4))

#select columns based on partial column names

ds %>% 
  select(starts_with("Weight"))

ds %>% 
  select(Publisher, starts_with("Weight"))

ds %>% 
  select(starts_with("W"))

ds %>% 
  select(ends_with("color"))

ds %>% 
  select(contains("color"))

ds %>% 
  select(contains("sher"), ends_with("ment"))

#select_if

ds %>% 
  select_if(is.numeric)

ds %>% 
  select_if(is.factor)

##Reorder columns

ds %>% 
  select(Gender, Eye.color, name)

#assign as new variable
ds.t<-ds %>% 
  select(Gender, Eye.color, name)

##rename columns using select()

ds %>% 
  select(heroes_name=name, m_or_f=Gender)

##rename, but keep all columns

ds %>% 
  rename(heroes_name=name, m_or_f=Gender)

#reformat columns

#to uppercase

ds %>% 
  select_all(toupper)

#to lowercase

ds %>% 
  select_all(tolower)

## Select and filter rows
### Chaining code

ds %>% 
  select(Gender, Eye.color) %>% 
  select_all(tolower)

### Filter rows based on numeric variable
# The most used operators for this are >, >=, <, <=, == and !=

ds %>% 
  select(name, Weight.kg) %>% 
  filter(Weight.kg > 100)

ds %>% 
  select(name, Weight.kg) %>% 
  filter(Weight.kg > 100, Weight.kg <120)

ds %>% 
  select(name, Weight.kg) %>% 
  filter(between(Weight.kg,100,120))

#filter based on exact character variable matches

levels(ds$Publisher)

ds %>% 
  select(name, Publisher, Skin.color) %>% 
  filter(Publisher == "Marvel Comics")

ds %>% 
  select(name, Publisher, Skin.color) %>% 
  filter(Publisher == "J. K. Rowling")

ds %>% 
  select(name, Publisher, Skin.color) %>% 
  filter(Publisher == "George Lucas")

#to filter out use != operator

ds %>% 
  select(name, Publisher, Skin.color) %>% 
  filter(Publisher != "DC Comics")

#select more than one record

ds %>% 
  select(name, Publisher) %>% 
  filter(Publisher == "Marvel Comics" | Publisher == "DC Comics")

ds %>% 
  select(name, Publisher) %>% 
  filter(Publisher %in% c("George Lucas","J. R. R. Tolkien"))

#Filter rows based on partial column names that have similar pattern

ds %>% 
  select(name, Publisher) %>% 
  filter(str_detect(name, pattern = "man"))

#We can also use multiple condition!

ds %>% 
  select(name, Publisher) %>% 
  filter(str_detect(name, pattern = "man"), Publisher=="DC Comics")

#Filter out empty rows

ds %>% 
  select(name, Publisher) %>% 
  filter(!is.na(Publisher)) 

#There are many other functions related to this, have a look on the modul!

###Data sorting

ds %>% 
  select(name, Publisher) %>% 
  arrange(name)

ds %>% 
  select(name, Publisher) %>% 
  arrange(Publisher)

ds %>% 
  select(name, Publisher) %>% 
  arrange(desc(Publisher))

#sort by multiple column

ds %>% 
  select(name, Publisher, Race) %>% 
  arrange(Publisher, name)

#Create new variable

ds %>% 
  select(name, Publisher, Weight) %>% 
  mutate(Publisher2 = paste("DC Comics"))

ds %>% 
  select(name, Publisher, Weight, Weight.kg) %>% 
  mutate(Weight_kg2 = Weight/2.205)

ds %>% 
  select(name, Publisher, Weight) %>% 
  mutate(ID = paste("COMic.CHARACTER.NR", row_number()))


#Create new discrete columns

ds %>% 
  select(name, Weight.kg) %>% 
  mutate(weight.class = if_else(Weight.kg >100, "Heavy", "Light"))

ds %>% 
  select(name, Weight.kg) %>% 
  mutate(weight.class = case_when(
    Weight.kg >20 ~ "Light",
    Weight.kg >50 ~ "Medium",
    Weight.kg >100 ~"Heavy",
    TRUE~"Super light"))

###Summarise data
#Count the number of observations: count() function

ds %>% 
  count(Publisher)

ds %>% 
  count(Skin.color)

ds %>% 
  count(Alignment)

#Add the number of observations in a column
#tally() - count the total number of cases
#add_tally() - count the total number of cases and mutate to new column
#add_count() - takes a variable as argument, and adds a column 
#which the number of observations

ds %>% 
  select(name, Publisher, Alignment) %>% 
  add_count(Publisher)

#Summarise Data 44. The basic: summarise() function
#To use the summarise() function, just add new column name, 
#and the equal sign the mathematics of what
#needs to happen: column_name = function(variable).

ds %>% 
  select(name, Weight.kg, Height) %>% 
  summarise(mean_weight=mean(na.omit(Weight.kg)),
            mean_height=max(na.omit(Height)))


# omit all NAs and its variation

new.ds<-ds %>%
  mutate_all(funs(replace(., . == -99, NA))) %>% 
  mutate_all(funs(replace(., . == "-", NA))) %>% 
  filter(!is.na(Weight.kg)) %>% 
  filter(!is.na(Height))

new.ds %>% 
  select(name, Weight.kg, Height) %>% 
  summarise(mean_weight=mean(na.omit(Weight.kg)),
            mean_height=max(na.omit(Height)))

new.ds %>% 
  summarise(mean_weight=mean(na.omit(Weight.kg)),
            mean_height=max(na.omit(Height)))

new.ds %>%  
  group_by(Publisher) %>% 
  summarise(Weight.kg = sum(Weight.kg)) 

b<-new.ds %>% 
  group_by(Alignment,Hair.color) %>% 
  summarise(Weight.kg = sum(Weight.kg)) 

#visualization

write.csv(b,"alignment.csv", row.names = FALSE)

b

ggplot(b, aes(fill=Hair.color,y=Weight.kg, x=Alignment)) +
  geom_bar(position="stack", stat="identity") +
  labs(x="Alignment",y="Weight (kg)", fill="Hair color")+
  theme_bw(base_size = 19) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        axis.text.x = element_text(angle = 90, hjust = 1))+
  theme(
    legend.position = c(.98, .95),
    legend.justification = c("right", "top"),
    legend.box.just = "right",
    legend.margin = margin(6, 6, 6, 6)
  )

c<-new.ds %>% 
  group_by(Alignment,Publisher) %>% 
  summarise(Weight.kg = sum(Weight.kg)) 

write.csv(c,"alignment_publisher.csv", row.names = FALSE)

c
ggplot(c, aes(fill=Publisher,y=Weight.kg, x=Alignment)) +
  geom_bar(position="stack", stat="identity") +
  labs(x="Alignment",y="Weight (kg)", fill="Publisher")+
  theme_bw(base_size = 19) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        axis.text.x = element_text(angle = 90, hjust = 1))+
  theme(
    legend.position = c(.98, .95),
    legend.justification = c("right", "top"),
    legend.box.just = "right",
    legend.margin = margin(6, 6, 6, 6)
  )
