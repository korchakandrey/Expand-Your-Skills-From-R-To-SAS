setwd("C:/Users/Андрей/Desktop")

ds<-read.csv("survey.csv");
# the same result via:
##String as factor added on my own
ds<-read.table("survey.csv"
          , header = TRUE
          , sep = ","
          , quote = "\""
          , dec = "."
          , fill = TRUE
          , comment.char = ""
          , stringsAsFactors = FALSE);

# be carefull - gender or GENDER does not work - R is case sensetive languadge
gender<-unique(tolower(ds$Gender))
#gender<-tolower(gender)

#trans
trans_c<-c("trans","male leaning androgynous","fluid")
index <- grep(paste(trans_c, collapse = "|"), x = gender )
trans<-gender[ index ]
gender_remain<-gender[-index]

#females
female_c<-c("f","woman","female")
index <- grep(paste(female_c, collapse = "|"), gender_remain)
females<-gender_remain[index]
gender_remain<-gender_remain[-index]

#males
males_c<-c("man","male","m","guy")
index <- grep(paste(males_c, collapse = "|"), gender_remain)
males<-gender_remain[index]
gender_remain<-gender_remain[-index]

#other
other<-gender_remain

 write(x=trans,file = "data.txt",   sep = "' '",ncolumns = length(trans), append = FALSE)  
 write(x=males,file = "data.txt",   sep = "' '",ncolumns = length(males), append = TRUE)
 write(x=females,file = "data.txt", sep = "' '",ncolumns = length(females), append = TRUE)
 write(x=other,file = "data.txt",   sep = "' '",ncolumns = length(other), append = TRUE)

 gender1<-ds$Gender
 
 gender1[tolower(gender1) %in% trans]  <- "trans"
 gender1[tolower(gender1) %in% males]  <- "males"
 gender1[tolower(gender1) %in% females]<- "females"
 gender1[tolower(gender1) %in% other]  <- "other"
 