library(RODBC)
cnt <- odbcConnect(dsn = "project5243", uid = "bpeng", pwd = "qqqq123456")
cat_sample <- RODBC::sqlQuery(cnt, query = "SELECT * FROM Project5261.dbo.cat_sample")
topic_sample <- RODBC::sqlQuery(cnt, query = "SELECT * FROM Project5261.dbo.topic_sample")

