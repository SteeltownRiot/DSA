ggplot(myData, aes(x = deaths, y = deaths, fill = gender)) + 
geom_bar(data = subset(myData, gender == "Female"), stat = "identity") +
geom_bar(data = subset(myData, gender == "Male"), stat = "identity", aes(y = -deaths)) +
coord_flip() +
# Order the axis
scale_x_discrete(limits = c("Under 5","6 to 11","12 to 14","15 to 17","18 to 24","25 to 49", 
                                    "50+"))

ggplot(myData, aes(x = deaths, y = deaths, fill = gender)) + 
geom_bar(data = subset(myData, gender == "Female"), stat = "identity") + 
geom_bar(data = subset(myData, gender == "Male"), stat = "identity", aes(y = -deaths)) + 
facet_wrap(~year) + 
coord_flip() + 
# make sure to have ordered axis
scale_x_discrete(limits = c("Under 5 years","5 to 13 years","14 to 17 years","18 to 24 years","25 to 44 years", 
                                    "45 to 64 years","65 years and over"))

ggplot(myData, aes(x = deaths, y = deaths, fill = ethnicity)) + 
geom_bar(data = subset(myData, gender == "Female"), stat = "identity") +
geom_bar(data = subset(myData, gender == "Male"), stat = "identity", aes(y = -deaths)) +
coord_flip() + 
ylab("Male Gun Deaths vs. Female Gun Deaths") +

scale_y_continuous(labels = abs) +
scale_fill_brewer(palette="Set2")


ggplot(myData, aes(x = ethnicity, y = deaths, fill = gender)) + 
geom_bar(data = subset(myData, gender == "Female"), stat = "identity") +
geom_bar(data = subset(myData, gender == "Male"), stat = "identity", aes(y = -deaths)) + 
facet_wrap(~year) + 
coord_flip()


p1 <- ggplot(myData, aes(x = year, group = 1)) +
    geom_line(aes(y = deaths), color = "black") +
    geom_point(aes(y = deaths)) +
    ylab("US Gun Deaths") +
    my_theme()

p1

cor

ethData <-
myData %>%
    group_by(year, ethnicity) %>%
    summarize(mean(deaths), sd(deaths))

line_plot <- ggplot(data = ethData, aes(x = year, y = `mean(deaths)`, color = ethnicity)) +
    geom_line() +
    my_theme()


genData <-
myData %>%
    group_by(year, gender) %>%
    summarize(mean(deaths), sd(deaths))

line_plot <- ggplot(data = ethData, aes(x = year, y = `mean(deaths)`, color = gender)) +
    geom_line() +
    my_theme()

line_plot

myData %>%
    group_by(ethnicity) %>%
    top_n(n = 1, wt = -deaths)

myData %>%
    group_by(ethnicity) %>%
    top_n(n = 1, wt = deaths)


cor(corrData$gender_code, corrData$deaths)

gen_data <-
    corrData %>%
    group_by(gender_code)

cor(gen_data$gender_code, gen_data$deaths)



## Go through each row to determine if value is zero
nonZero = apply(dd, 1, function(row) all(row !=0 ))
##Subset as usual
dd[nonZero,]



myData <- myData[!(myData$deaths == 0),]

myData


full <- myData        # Full data set
partial <- full[, -2]  # Background Data - full without the 4th column (gender)

ggplot(full, aes(x = deaths, fill = gender)) + # layer for partitioning by gender
  geom_histogram(data = partial, fill = "grey", alpha = .5) + # background layer
  geom_histogram(bins = 25) + 
  facet_wrap(~ gender) + 
  guides(fill = FALSE) # remove the legends



  g <- ggplot(crime, aes(x = age, y = ethnicity, size = deaths)) + 
    geom_point(aes(color = ethnicity), alpha = 0.7) +
    scale_color_continuous(low = "yellow", high = "purple") +
    scale_size(range = c(1, 20)) + 
    theme(legend.position = "none") + 
    geom_text(size = 2, aes(label = ethnicity)) + 
    xlab("Murder rate") + ylab("Burglary rate") + 
    ylim(200, 1400) + xlim(0, 11)

g




