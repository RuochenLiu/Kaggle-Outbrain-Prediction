library(RODBC)
library(lubridate)

cnt <- odbcConnect(dsn = "project5243", uid = "bpeng", pwd = "qqqq123456")
final <- RODBC::sqlQuery(cnt, query = "SELECT * FROM Project5261.dbo.final")
full_index <- unique(final$display_id)
cut_index <- sample(full_index, 200000)
cut <- final[which(final$display_id %in% cut_index), ]

times <- cut$timestamp
times <- as.numeric(times)
times <- times+1465876799998 
times <- times/1000
class(times) = c('POSIXt','POSIXct')
pm(times)
sum(pm(times))
cut$pm <- pm(times)


cut$geo_location <- as.character(cut$geo_location)
cut$geo_location <- substr(cut$geo_location, start = 1, stop = 2)

cut_country <- data.frame(c(1:nrow(cut)),cut[,"geo_location"])
colnames(cut_country) <- c("index", "country")
continent <- read.csv("../data/all.csv")[, c("alpha.2", "region")]
colnames(continent) <- c("country", "region")

country_region <- merge(x = cut_country, y = continent, all.x = T)
sorted_country <- country_region[order(country_region$index), ]

region <- sorted_country[ ,"region"]
cut$region <- region

cut <- na.omit(cut)
for (i in 1:ncol(cut)) {
  cut[,i] <- as.factor(cut[,i])
}


full_index <- unique(cut$display_id)
train_index <- sample(full_index, 180000)
train <- cut[which(cut$display_id %in% train_index), ]
test <- cut[-which(cut$display_id %in% train_index), ]

save(train, file = "../data/train.rdata")
save(test, file = "../data/test.rdata")