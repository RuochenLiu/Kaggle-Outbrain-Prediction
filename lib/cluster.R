library(RODBC)
cnt <- odbcConnect(dsn = "project5243", uid = "bpeng", pwd = "qqqq123456")
cat_sample <- RODBC::sqlQuery(cnt, query = "SELECT * FROM Project5261.dbo.cat_sample")
topic_sample <- RODBC::sqlQuery(cnt, query = "SELECT * FROM Project5261.dbo.topic_sample")

cat_id_all <- sqlQuery(cnt, query = "select distinct cat_id from Project5261.dbo.doc_category")
topic_id_all <- sqlQuery(cnt, query = "select distinct topic_id from Project5261.dbo.documents_topics")

source("./functions.R")
cat <- cluster_cat(df_sample = cat_sample, id_all = cat_id_all, k=5)
cat_data <- cat[[1]]
cat_model <- cat[[2]]
topic <- cluster_topic(df_sample = topic_sample, id_all = topic_id_all, k=10)
topic_data <- topic[[1]]
topic_model <- topic[[2]]

write.csv(cat_data, file = "../output/cat_clustered.csv")

write.csv(topic_data, file = "../output/topic_clustered.csv")

save(cat_model, topic_model, file = "../output/clustermodel.RData")

