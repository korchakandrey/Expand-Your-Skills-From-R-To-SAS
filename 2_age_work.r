#unusual results
head(ds$Age)
#[1] 37 44 32 31 31 33

#tell smth about ( na.rm = TRUE) 


summary(ds$Age)
#Min.    1st Qu.     Median       Mean    3rd Qu.       Max. 
#-1.726e+03  2.700e+01  3.100e+01  7.943e+07  3.600e+01  1.000e+11 
min(ds$Age)
#[1] -1726
 max(ds$Age)
#[1] 1e+11
 
 #correct notation
 summary(ds$Age[(ds$Age <150 & ds$Age>0 ) ])   
 #Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 #5.00   27.00   31.00   32.02   36.00   72.00 
 
 #incorrect notation
 #Min.     1st Qu.      Median        Mean     3rd Qu.        Max. 
 #-1726          27          31    79428148          36 99999999999 
 
 ds1$agec<-sapply(as.vector(ds$Age), function(x)
   if (x < 0 | x > 150) "missing"
   else if (x <= 25 ) "<=25"
   else if (x <= 30 ) "26-30"
   else if (x <= 35 ) "31-35"
   else if (x <= 40 ) "36-40"
   else if (x <= 45 ) "41-45"
   else ">45" )
  table(ds1$agec)
 #<=25     >45   26-30   31-35   36-40   41-45 missing 
 #220      56     362     339     185      92       5
 