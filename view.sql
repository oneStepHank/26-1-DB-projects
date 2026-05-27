use Team25;

-- view 1. user count (done)
create view original_user_count as
(
select count(distinct id) from Problem26.allrecords where id is not null
    );

select *
from original_user_count;

create view user_count as
(
select count(*)
from user
    );

-- view 2. doc_count (done)
create view original_doc_count as
(
select count(distinct hash_key) from Problem26.allrecords where hash_key is not null
    );

select *
from original_doc_count;

create view doc_count as (select count(*) from documents);
select *
from doc_count;

-- view 3. term_count_3rd todo: 문제 이해하기
# show the term that has the third-highest number of occurrence
# and the number of occurrence of that term

create view term_count_3rd as
select term, `count`
from keywords join Team25.keywords_dict kd on kd.id = keywords.term_id
order by `count` desc limit 1 offset 2;


-- 4. view: count_doc_title (done)
-- show the count of documents that contains ‘통일’ in document title
select count(distinct doc_title, hash_key)
from Problem26.allrecords where doc_title like '%통일%' and hash_key is not null;

create view count_doc_title as
(
select count(*) as cnt
from documents where doc_title like '%통일%'
    );

select *
from count_doc_title;

-- 5. view: saved_documents
-- Display the user id, saved hash key, saved date of the document,
# stored in ascending order by saved date
create view saved_documents as
(
select user_id, has_key, saved_date
from saved_doc
order by saved_date
);


# 6. view: user_inst_2nd
# show the second most common (institution, user title) tuple count among registered users

with user_info as (
    select distinct id, institution, user_title
    from Problem26.allrecords where id is not null
),
     inst_2nd as (
         select institution, user_title, count(*) as cnt
         from user_info
         group by institution, user_title
     )
select institution, user_title
from inst_2nd order by cnt desc limit 1 offset 1;

create view user_inst_2nd as
(
select inst.name , title.title
from user
         join institution_info inst on user.institution_id = inst.id
         join user_title_info title on user.user_title = title.title_id
group by inst.name, title.title
order by count(*) desc limit 1 offset 1
);

select *
from user_inst_2nd;


# 7. view: document_summary
# Show the attached document information by summarizing
# their hash key, title, timestamp stored in ascending order by timestamp

with original_summary as (
    select distinct
        hash_key, doc_title,
        STR_TO_DATE(post_date, '%Y-%m-%d %h:%i:%s %p') as `timestamp` , post_date
        from Problem26.allrecords where hash_key is not null
        order by `timestamp`
)
select o.hash_key, ds.has_key, o.doc_title, ds.doc_title,
       o.post_date, ds.post_date, o.post_date
from document_summary ds
left join original_summary o on o.hash_key <=> ds.has_key
order by ds.post_date
;


create view document_summary as
(
select has_key, doc_title, post_date
from documents
order by post_date
    );

select *
from document_summary;

# 8. view: qna_records
# Show the records for faq by summarizing
# user_id, qna_title, qna_content, status, reply date
# in descending order by reply date
create view qna_records as
(select q.user_id, q.title, q.content, st.status, reply_date
from qna q
join status_info st on q.status = st.id
left join reply on q.id = reply.qna_id
order by reply.reply_date desc);

select distinct qna_user_id, qna_title, qna_content, status, reply_date
from Problem26.allrecords where qna_user_id is not null order by  reply_date desc;