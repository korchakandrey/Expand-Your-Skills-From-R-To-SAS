df1<-read.table(header=TRUE,text ="
  col1 col2 col3 
  1 a T
  2 b T
  3 c F"
)
str(df1)
#'data.frame':	3 obs. of  3 variables:
#  $ col1: int  1 2 3
#$ col2: Factor w/ 3 levels "a","b","c": 1 2 3
#$ col3: logi  TRUE TRUE FALSE