require(dplyr)
setwd("E:/R/mental-health-in-tech-2016");
csv_file<-read.csv("mental-heath-in-tech-2016_20161114.csv", stringsAsFactors = FALSE)
dim(csv_file)
names(csv_file)
names(csv_file[,c(4,56:63)])


# Selecting only vars needed for Demographic Table
demog <- csv_file %>% select(contains("remotely",ignore.case = TRUE),
                             contains(".age.",ignore.case = TRUE),
                             contains(".gender.",ignore.case = TRUE),
                             ends_with(".IT.")
                             )
# Also, this task can be done by rename function
names(demog) <- c("REMOTE","AGE","GENDER","IT_ROLE")
str(demog)


# Preparing variants of gender Groups;
           
OTHER <- c("genderflux demi-girl","human","male 9:1 female, roughly"
           ,"male (trans, ftm)","genderqueer woman","other","afab","agender","androgynous"
           ,"bigender","enby","genderqueer","mtf","n/a","nb masculine","non-binary","nonbinary"
           ,"none of your business","unicorn","queer","transitioned, m2f","genderfluid (born female)"
           ,"other/transfeminine","genderfluid","fluid","male/genderqueer","transgender woman" )

FEMALE <- c("cis female","female assigned at birth","woman","female","female"
  ,"i identify as female.","female or multi-gender femme","female/woman"
  ,"cisgender female"," female","female (props for making this a freeform field, though)"
  ,"f", "fem","fm","female-bodied; no feelings about gender","cis-woman")

MALE <- c("male (cis)","cis man","cis male"
  ,"i'm a man why didn't you make this a drop down question. you should of asked sex? and i would of answered yes please. seriously how much text can this take?"
  ,"cis male","sex is male","male (cis)","male.","cis male","man","male","guy","cisdude", "dude", "dude",
  "m", "ml", "m|", "mail", "malr"  )

case_when1  <- list(GENDER_C = ~  case_when( GENDER %in% FEMALE ~ "Female",
                                           GENDER %in% MALE   ~ "Male",
                                           GENDER %in% OTHER  ~ "Other"  ))

# Cleaning the data
demog <- demog %>% mutate(  AGEN = if_else( AGE > 70 | AGE < 10 , true = NA_integer_, false =AGE )) %>% 
                   mutate( GENDER = trimws(tolower(GENDER)),
                           BIG_N = n()     ) %>% 
                   mutate_( .dots =  case_when1 ) %>% select( BIG_N, current_vars(), - GENDER, -AGE)
head(demog)

stable <- sapply(demog[,c("REMOTE", "IT_ROLE", "GENDER_C")],table)
s_f <- summary(demog$AGEN)

df_table <-  data.frame (Var = as.character(names(stable$REMOTE)),   Freq = as.vector(stable$REMOTE)   , param = "Remote?"       , stringsAsFactors = FALSE)
df_table1 <-  data.frame(Var = as.character(names(stable$GENDER_C)), Freq = as.vector(stable$GENDER_C) , param = "Gender"        , stringsAsFactors = FALSE)
df_table2 <-  data.frame(Var = as.character(names(stable$IT_ROLE)),  Freq = as.vector(stable$IT_ROLE)  , param = "It/Tech Role?" , stringsAsFactors = FALSE)
df_table3 <- data.frame (Var = as.character(names(s_f)),             Freq = as.vector(s_f)             , param = "Age"           , stringsAsFactors = FALSE)

big_n <- demog$BIG_N[1]

d_all_tabs <- bind_rows(df_table, df_table1, df_table2, df_table3)
d_all_tabs %>% select(param, Var, Freq) %>%
  mutate(VALUE = paste0( round(Freq,digits = 1)," (",round(Freq/(!!big_n )*100,digits = 2),"%)") ) %>%
  select( - Freq )
