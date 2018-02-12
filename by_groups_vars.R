 a<-sample(c(1:5),10,replace = T)
 b<-sample(c("a","b","c"),10,replace = T)
 df<-data.frame(data = a , group = b )
 
 tapply(X = df$data,INDEX = df$group, FUN = mean)
 #a        b        c 
 #3.166667 1.000000 3.666667 
 
 aggregate(data~group, data=df, mean)
 #group     data
 #1     a 3.166667
 #2     b 1.000000
 #3     c 3.666667

 by(df$data, df$group, mean )
 #df$group: a
 #[1] 3.166667
 #--------------------------------------------------- 
 #  df$group: b
 # [1] 1
 # ---------------------------------------------------
 #  df$group: c
 #[1] 3.666667
 
 g<-sample(c("g1","g2"),10, replace = T)
 df<-data.frame(data = a , group = b, group2= g )
 with(df,table(data,group,group2))
 
 
 
 -------------------
   
df1 <- data.frame(
x = c("B", "B", "B", "D", "D"),
y = 1:5
)
aggregate(y~x,data = df1, sum)
 
----------------------
  subset(products_sold, products_sold$price %in% c(10,15) , select = c("store","inventory","price","sold"))