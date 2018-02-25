if( FALSE){
  class(colnames(demog))
  or 
  type( data ( round))
}
#set.seed(12)
#numbers <- rnorm(1:100)
#sum(numbers)

sort(unique(demog$AGE))
#[1]   3  15  17  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35
#[21]  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55
#[41]  56  57  58  59  61  62  63  65  66  70  74  99 323

demog$AGE %>% unique %>% sort
#[1]   3  15  17  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35
#[21]  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55
#[41]  56  57  58  59  61  62  63  65  66  70  74  99 323

rep(1,2)
#[1] 1 1
rep(2,1)

#[1] 2
1 %>% rep(2)
#[1] 1 1
1 %>% rep(2,.)
#[1] 2

3 %>% demog[.,.]
#[1] "United Kingdom"
demog[3,3]
#[1] "United Kingdom"

names(demog)
#[1] "AGE"        "GENDER"     "COUNTRY"    "US_STATE"   "W_COUNTRY"  "W_US_STATE" "POSITION"  
#[8] "REMOTELY"

#If we want to select all adult responders from US by State 
STATES <- demog %>% filter(COUNTRY == "United States of America", AGE > 15 , AGE <100) %>% select( ends_with("STATE") ) 
str(STATES)
table(STATES)
sapply(STATES, table)

library(dplyr)
df1<-read.table(header=TRUE,stringsAsFactors = FALSE, text ="
                col1 col2 col3 
                1 a T
                2 b T
                3 c F"
)
str(df1)
df1_i <- df1 %>% filter(col3==1)
df1_i
#col1 col2 col3
#1    1    a TRUE
#2    2    b TRUE

df_w <- subset( df1, col3 == 1)
df_w

df_k <- df1 %>% select( c("col1","col2"))
str(df_k)

df_d <- df1 %>% select( -col3 )
df_d
#col1 col2
#1    1    a
#2    2    b
#3    3    c

#; #starts_with(), ends_with(),contains(),matches() and num_range()
#*** keeping all columns between col1 and col3 ***;
#keep col1-col3;
df1
df1_more_vars <- df1 %>% mutate( col4 = rnorm(1) , col0 = 1)
df1_k_betw <- df1 %>% select(num_range("col", 1:3))
df1_k_betw

# variables starts with ;
df1_k_st <- df1 %>% select(starts_with("col"))
df1_k_st

# # Block 3 for testing .
df1
d1_new_vars1 <- df1 %>% mutate( letter1 = letters[col1],
                                n_2 = n()/2,
                                cocat = if_else(row_number() >= n()/2
                                                ,paste("third negative",n_2,"dd")
                                                ,"third positive"
                                                ,"missing"
                                ),
                                col1 = col1 + 2.3
)
d1_new_vars1

# # Block 3 mutate function and creating new varbles ;
df1
df_new_var <- df1 %>% mutate(  
  n_2 = n()/2,
  col4 = if_else(row_number() >= n()/2
                 ,">= n/2","<n/2","missing"),
  col1 = col1 + 0.03
)
df_new_var

# Grouping varibles and statistics in R;
df2 <- read.table(header = TRUE,
                  stringsAsFactors = FALSE,
                  text = "
                  SUBJID TEST1 TEST2 PERIOD
                  S1 10 NA 1	
                  S1 8  7 2	
                  S2 7 4 1	
                  S2 5 3 2	
                  ");
df2

df2_s <- df2 %>%
  mutate( TEST = rowMeans(.[,c("TEST1","TEST2")],na.rm=TRUE ) )  %>%
  group_by( SUBJID ) %>%
  summarise(
  TEST_N    = n( ),
  TEST_MEAN = mean( TEST ,na.rm = TRUE),
  TEST_SDT  = sd ( TEST ,na.rm = TRUE),
  TEST_MIN  = min( TEST ,na.rm = TRUE),
  TEST_MAX  = max( TEST ,na.rm = TRUE)
)     %>% ungroup() %>%  
  mutate( TOT_TEST_MEAN = mean( TEST_MEAN ) )
df2_s
df2_s %>% as.data.frame


# lag and lead functions;
df2_lag_lead <- df2 %>% 
  select(SUBJID, TEST1) %>% 
  group_by( SUBJID) %>%
  mutate( 
    LAG = lag( TEST1 ),
    LEAD = lead( TEST1 )
    )
df2_lag_lead
# Note that lag() and lead() are working within groups;
                                                      

## Joins;
# Information about subjects;
df_add_info <- read.table(header = TRUE,
                stringsAsFactors = FALSE,
                text = "
SUBJID  NAME 
S1 Nick
S2 Cate 
S3 Josh 
");
df_add_info

df_test_name <- df2_s %>%
  left_join(y = df_add_info,
           by = c("SUBJID" = "SUBJID")) %>%
    select(NAME, TEST_MEAN )
df_test_name
