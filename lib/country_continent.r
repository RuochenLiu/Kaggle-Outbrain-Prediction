load("../data/final_uncutted.RData")

# add column "region": the region of each country
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

