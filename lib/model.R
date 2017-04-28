ad <- sort(table(train$advertiser_id), decreasing = T)
ad <- data.frame(ad_id = names(ad), count = as.numeric(ad))
plot(ad$count)
ad_else <- ad$ad_id[701:3299]

library(dplyr)
model3 <- speedglm(clicked~cat_cluster+topic_cluster+pm+platform+advertiser, 
                   data = train, family = binomial(logit), fitted = T)


test <- test %>% 
  mutate( advertiser = 
            ifelse(as.character(advertiser_id) %in% train$advertiser,
                   as.character(advertiser_id), 0))

for (i in 1:14) {
  test[,i] <- as.factor(test[,i])
}
test.predict <- predict(model3, test)

prob <- function(x){
  return(exp(x)/(1+exp(x)))
}

test.prob <- prob(test.predict)

test$prob <- test.prob

a <- test %>% select(display_id,ad_id, clicked, prob)    group_by(display_id) 

%>% arrange(desc(prob)) %>% mutate(Rank=order(prob))  

save(test.predict, file = "testprediction.RData")
