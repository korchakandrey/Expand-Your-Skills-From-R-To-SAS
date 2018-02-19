gender<-data.frame(gender=trimws(tolower(demog$"GENDER")), stringsAsFactors = FALSE)
str(gender)

###trans
trans_c<-c("trans","male leaning androgynous","fluid")
index <- grep(paste(trans_c, collapse = "|"), x = gender$gender )
gender[ index,"sexc_o" ]<-"Other"
gender[ gender$gender %in% c("human","male/genderqueer","male 9:1 female, roughly","male (trans, ftm)","genderqueer woman","other","afab","agender","androgynous","bigender","enby","genderqueer","mtf","n/a","nb masculine","non-binary","nonbinary","none of your business","unicorn","queer"),"sexc_o"] <-"Other"
table(gender$sexc_o)
table(gender$gender[gender$sexc_o=="Other"])

###females
gender[ gender$gender %in% c("cis female","female assigned at birth","woman","female","female","i identify as female.","female or multi-gender femme","female/woman","cisgender female"," female","female (props for making this a freeform field, though)","f", "fem","fm","female-bodied; no feelings about gender","cis-woman"),"sexc_f" ] <- "Female"
table(gender$sexc_f)
table(gender$gender[gender$sexc_f=="Female"])

###males
gender[ gender$gender %in% c("male (cis)","cis man","cis male","i'm a man why didn't you make this a drop down question. you should of asked sex? and i would of answered yes please. seriously how much text can this take?","cis male","sex is male","male (cis)","male.","cis male","man","male","guy","cisdude", "dude", "dude", "m", "ml", "m|", "mail", "malr"  ),"sexc_m"] <-c("Male")
table(gender$sexc)
table(gender$gender[gender$sexc_m=="Male"])

str(gender)
gender[ is.na(gender$sexc_o) + is.na(gender$sexc_f)+ is.na(gender$sexc_m) ==3 & gender$gender!="", ]
unique(gender[ is.na(gender$sexc_o) + is.na(gender$sexc_f)+ is.na(gender$sexc_m) ==1 & gender$gender!="","gender" ])
unique(gender[ gender$gender=="", ])

gender$"sexc"<-with(gender,coalesce(sexc_o,sexc_f,sexc_m))
