# Function: Reorganize df with all categories/topics columns
# Input  : df_sample: sample (dataframe); 
#          df_all: all data (dataframe):
#          variable: column name to cluster upon (string)
# Output : reorganized data frame (each column corresponds to one category/topic)

reorganize <- function(df_sample, df_all, variable){
  
  a <- colnames(df_sample)[-1]
  b <- unique(df_all[,variable])
  
  # Find the column names that need to be added
  add_col <- c()
  for (x in b){
    if (sum(a==x)==0){
      add_col <- c(add_col, x)
    }
  }
  add_df <- as.data.frame(matrix(0, 
                                 nrow = nrow(df_sample), 
                                 ncol = length(add_col)))
  colnames(add_df) <- add_col
  df_sample_com <- cbind(df_sample, add_df)
  
  # reorganize columns in ascending order
  df_col <- colnames(df_sample_com)
  df_organized <- df_sample_com[, order(df_col)]
  
  return(df_organized)
}




# Function: Cluster documents based on category/topic
# Input   : df_sample, df_all, variable (as in function "reorganize")
#           key_name (cat_id or topic_id)
# Output  : dataframe (columns: doc_id, new_cluster)

cluster <- function(df_sample, df_all, key_name, variable){
  
  new_doc_sample <- tidyr::spread(df_sample, key = key_name, value = con, fill = 0)
  
  doc_organized <- reorganize(df_sample = new_doc_sample, 
                              df_all = df_all,
                              variable = variale)
  # kmeans
  doc_cluster <- kmeans(x=doc_organized[,-ncol(doc_organized)])
  doc_organized$new_cluster <- doc_cluster$cluster
  doc_final <- doc_organized[, c("doc_id", "new_cluster")]
  
  return(doc_final)
}



cluster2 <- function(df_sample, key_name, variable){
  
  new_doc_sample <- tidyr::spread(df_sample, key = key_name, value = con, fill = 0)
  
  # kmeans
  doc_cluster <- kmeans(x=doc_organized[,-ncol(doc_organized)])
  doc_organized$new_cluster <- doc_cluster$cluster
  doc_final <- doc_organized[, c("doc_id", "new_cluster")]
  
  return(doc_final)
}







