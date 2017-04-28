# Function: Reorganize df with all categories/topics columns
# Input  : df_sample: sample (dataframe); 
#          id_all: all unique ids (either for categories or for topics)
# Output : reorganized data frame (each column corresponds to one category/topic)

reorganize <- function(df_sample, id_all){
  
  a <- colnames(df_sample)[-1]
  
  # Find the column names that need to be added
  add_col <- c()
  for (x in id_all){
    if (sum(a==rep(x,length(a)))==0){
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
# Input   : df_sample, id_all, k (centers for kmeans)
# Output  : dataframe (columns: doc_id, new_cluster)

cluster_cat <- function(df_sample, id_all=cat_id_all, k){
  
  # long to wide
  new_doc_sample <- tidyr::spread(df_sample, key = cat_id, value = con, fill = 0)
  
  doc_organized <- reorganize(df_sample = new_doc_sample,id_all)
  
  # kmeans
  doc_cluster <- kmeans(x=doc_organized[,-ncol(doc_organized)], centers = k)
  doc_organized$new_cluster <- doc_cluster$cluster
  doc_final <- doc_organized[, c("doc_id", "new_cluster")]
  
  return(list(doc_final, doc_cluster))
}


cluster_topic <- function(df_sample, id_all=topic_id_all, k){
  
  # long to wide
  new_doc_sample <- tidyr::spread(df_sample, key = topic_id, value = con, fill = 0)
  
  doc_organized <- reorganize(df_sample = new_doc_sample, id_all)
  
  # kmeans
  doc_cluster <- kmeans(x=doc_organized[,-ncol(doc_organized)], centers = k)
  doc_organized$new_cluster <- doc_cluster$cluster
  doc_final <- doc_organized[, c("doc_id", "new_cluster")]
  
  return(list(doc_final, doc_cluster))
}



cluster2 <- function(df_sample, variable, k){
  
  new_doc_sample <- tidyr::spread(df_sample, key = cat_id, value = con, fill = 0)
  
  # kmeans
  doc_cluster <- kmeans(x=new_doc_sample[, -1], centers = k)
  new_doc_sample$new_cluster <- doc_cluster$cluster
  doc_final <- new_doc_sample[, c("doc_id", "new_cluster")]
  
  return(doc_final)
}




cluster3 <- function(df_sample, variable, k){
  
  new_doc_sample <- tidyr::spread(df_sample, key = topic_id, value = con, fill = 0)
  
  # kmeans
  doc_cluster <- kmeans(x=new_doc_sample[, -1], centers = k)
  new_doc_sample$new_cluster <- doc_cluster$cluster
  doc_final <- new_doc_sample[, c("doc_id", "new_cluster")]
  
  return(doc_final)
}





