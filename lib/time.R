


times <- cut$timestamp
times <- as.numeric(times)
times <- times+1465876799998 
times <- times/1000
class(times) = c('POSIXt','POSIXct')
head(times)
library(lubridate)
pm(times)
sum(pm(times))





