getwd()
setwd("E:/R/mental-health-in-tech-2016")

csv_file<-read.csv("mental-heath-in-tech-2016_20161114.csv", stringsAsFactors = FALSE)
dim(csv_file)
str(csv_file)
names(csv_file)
names(csv_file[,56:63])
### Let`s start with demographic data:
# [56] "What.is.your.age."                                                                                                                                                               
# [57] "What.is.your.gender."                                                                                                                                                            
# [58] "What.country.do.you.live.in."                                                                                                                                                    
# [59] "What.US.state.or.territory.do.you.live.in."                                                                                                                                      
# [60] "What.country.do.you.work.in."                                                                                                                                                    
# [61] "What.US.state.or.territory.do.you.work.in."
# [62] "Which.of.the.following.best.describes.your.work.position."                                                                                                                       
# [63] "Do.you.work.remotely."  

# Selecting All Rows ( first argument of []) and certain columns( numbers specified ) into another DATA.FRAME;
### The same can be done by SAS - keep statment in dataset options.
demog <- csv_file[,c(56:63)]
dim(demog)
str(demog)
head(demog)
table(demog$"What.is.your.age.")
hist(demog$"What.is.your.age.")

names(demog)<-c("AGE","GENDER","COUNTRY","US_STATE","W_COUNTRY","W_US_STATE","POSITION","REMOTELY")
str(demog)
summary(demog$"AGE")
summary(demog$"GENDER")
table(demog$"GENDER")
