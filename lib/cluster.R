library(RODBC)
cnt <- odbcConnect(dsn = "project5243", uid = "bpeng", pwd = "qqqq123456")
cat_sample <- RODBC::sqlQuery(cnt, query = "SELECT * FROM Project5261.dbo.cat_sample")
topic_sample <- RODBC::sqlQuery(cnt, query = "SELECT * FROM Project5261.dbo.topic_sample")

cat <- cluster2(df_sample = cat_sample, variable = "cat_id",k=10)
topic <- cluster3(df_sample = topic_sample, variable = "topic_id",k=10)

write.csv(cat, file = "../output/cat_clustered.csv")
write.csv(topic, file = "../output/topic_clustered.csv")
