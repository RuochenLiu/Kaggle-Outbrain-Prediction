--merge tables: all-info of doc
select 
documents_categories.document_id as doc_id,
documents_categories.category_id as category_id,
documents_categories.confidence_level as category_confidence,
documents_meta.source_id as source_id,
documents_meta.publish_time as publish_time,
documents_meta.publisher_id as publisher_id,
documents_topics.topic_id as topic_id, 
documents_topics.confidence_level as topic_confidence
into doc_info
from documents_categories
join documents_meta on documents_categories.document_id=documents_meta.document_id
join documents_topics on documents_categories.document_id = documents_topics.document_id;


--create doc_category with same doc_id as in doc_info 
select * into unique_doc_cat_id
from (
select distinct document_id from documents_categories
intersect
select distinct doc_id from doc_info) as a;

select 
a.document_id as doc_id,
a.category_id as cat_id,
a.confidence_level as cat_con
into doc_category
from documents_categories a
inner join unique_doc_cat_id b
on a.document_id  =  b.document_id;


--create doc_topic with same doc_id as in doc_info 
select * into unique_doc_topic_id
from (
select distinct document_id from documents_topics
intersect
select distinct doc_id from doc_info) as a;

select 
a.document_id as doc_id,
a.topic_id as topic_id,
a.confidence_level as cat_con
into doc_topic
from documents_topics a
inner join unique_doc_topic_id b
on a.document_id  =  b.document_id;



--create doc_meta with same doc_id as in doc_info 
select * into unique_doc_meta_id
from (
select distinct document_id from documents_meta
intersect
select distinct doc_id from doc_info) as a;

select 
a.document_id as doc_id,
a.source_id as source_id,
a.publisher_id as publisher,
a.publish_time as time
into doc_meta
from documents_meta a
inner join unique_doc_meta_id b
on a.document_id  =  b.document_id;



--sample 200000 doc_id 
select top 200000 * into doc_id_sample
from unique_doc_cat_id;


--sampled doc_category with 200000 sampled doc_id 
select 
a.doc_id as doc_id,
a.cat_id as cat_id,
a.cat_con as con
into cat_sample
from doc_category a
inner join doc_id_sample b
on a.doc_id  =  b.document_id;


--sampled doc_topic with 200000 sampled doc_id 
select 
a.doc_id as doc_id,
a.topic_id as topic_id,
a.cat_con as con
into topic_sample
from doc_topic a
inner join doc_id_sample b
on a.doc_id  =  b.document_id;


--sampled doc_meta with 200000 sampled doc_id 
select 
a.doc_id as doc_id,
a.source_id as source_id,
a.publisher as publisher,
a.time as publish_time
into meta_sample
from doc_meta a
inner join doc_id_sample b
on a.doc_id  =  b.document_id;


--merged doc with new clusters for categories and topics 
select 
a.doc_id as doc_id,
a.new_cluster as cat,
b.new_cluster as topic,
c.source_id as source_id,
c.publisher as publisher,
c.publish_time as publish_time
into doc_merge
from cat_clustered a
join topic_clustered b on a.doc_id=b.doc_id
join meta_sample c on a.doc_id=c.doc_id;


--get the final table with all data merged with sampled doc_id
SELECT 
clicks_train.display_id, 
clicks_train.ad_id, 
clicks_train.clicked,
clicks_events.document_id, 
clicks_events.geo_location, 
clicks_events.platform, 
clicks_events.timestamp, 
clicks_events.uuid
INTO sum_clicks_events
FROM clicks_train, clicks_events
WHERE clicks_train.display_id = clicks_events.display_id
ORDER BY clicks_train.display_id ASC;


--update the final table with geo_location represents only countries
UPDATE final
SET geo_location = LEFT(geo_location, 2);
