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

predict_result <- test %>% select(display_id,ad_id, clicked, prob) %>% group_by(display_id) 

unique(test$display_id)

setorderv(predict_result, c("display_id", "prob"), c(1,-1)) 

id <- table(test$display_id)
number <- as.numeric(id)
Rank <- c()
for (i in 1:length(number)){
  Rank <- c(Rank, 1:number[i])
}

predict_result$Rank <- Rank

#Evaluation

predict_result <- predict_result %>% mutate(score = as.numeric(paste(clicked))/Rank) 
final_score <- sum(predict_result$score)/length(unique(predict_result$display_id))
cat(final_score)
