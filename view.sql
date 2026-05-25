use _S22100229_DB;

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
-- show the term that has the third-highest number of occurrence and the number of occurrence of that term
select term, count(*) as occurrences
from Problem26.allrecords where term is not null group by term
order by occurrences desc;




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
-- Display the user id, saved hash key, saved date of the document, stored in ascending order by saved date


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

