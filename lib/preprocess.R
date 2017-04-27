library(RODBC)
cnt <- odbcConnect(dsn = "project5243", uid = "bpeng", pwd = "qqqq123456")
final <- RODBC::sqlQuery(cnt, query = "SELECT * FROM Project5261.dbo.final")
full_index <- unique(final$display_id)
cut_index <- full_index[1:200000]
cut <- final[which(final$display_id %in% cut_index), ]

cut <- cut[,-c(2,3,4,7)]
cut <- cut[,-6]

for (i in 1:ncol(cut)) {
  cut[,i] <- as.factor(cut[,i])
}

save(cut, file = "../data/final_cutted.rdata")