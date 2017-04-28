library(data.table)
events <- fread('events.csv')
setkeyv( events, c("display_id","document_id") )

####Load Train and Test
train<- fread(" ../data/train.Rdata" )
test <- fread( "../test.Rdata" )

####Map document_id to train and test
promoted <- fread( "promoted_content.csv" )
setkeyv( promoted , "ad_id" )
train[, document_id := promoted[J(train$ad_id)]$document_id ] 
test[ , document_id := promoted[J(test$ad_id )]$document_id ] 
rm(promoted); gc()


####Calculate ad_id probabilities
prob_by_adid <- train[,list( mean(clicked), length(clicked) ),keyby="ad_id"]; gc()
M <- mean( train$clicked)
prob_by_adid[, likelihood := ((V1*V2)+(12*M))/(12+V2)  ]
print( head(prob_by_adid) )


####Build test predictions
print("Now Map testset probs")
test[             , prob := prob_by_adid[J(test$ad_id)]$likelihood ]#Map probabilities
print( head(test,20) )
rm(prob_by_adid, events);gc()

#Prediction
setorderv( test, c("display_id","prob"), c(1,-1)  );gc() #Sort by -prob
test[             , sort := 1:.N , by="display_id" ]; gc()
head(test,20)
print( mean( test[, sum(clicked/sort) , by="display_id" ]$V1 ) ); gc()
