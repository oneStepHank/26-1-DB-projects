use _S22100229_DB;

CREATE TABLE documents(
                          has_key varchar(32) primary key,
                          doc_title             longtext     not null ,
                          post_date             datetime  not null ,
                          topic_id                tinyint    not null,

                          foreign key (topic_id) references topic(topic_id)
);

create table topic(
                      topic_id tinyint primary key,
                      topic varchar(4) null
);

create table keywords(
                         hash_key varchar(32) not null,
                         term varchar(32) not null,
                         count int not null,

                         primary key (hash_key, term),
                         foreign key (hash_key) references documents(has_key)
);

-- topic mapping table
insert into topic (topic_id, topic)
values (0 , null),
       (1, '정치'),
       (2, '경제'),
       (3, '사회'),
       (4, '국제'),
       (5, 'IT과학'),
       (6,'스포츠'),
       (7,'문화');

-- documents table
insert into _S22100229_DB.documents (has_key, doc_title, post_date, topic_id)
SELECT DISTINCT
    a.hash_key,
    a.doc_title,
    STR_TO_DATE(post_date, '%Y-%m-%d %h:%i:%s %p'),
    t.topic_id
FROM Problem26.allrecords a
         JOIN _S22100229_DB.topic t
              ON a.topic <=> t.topic
WHERE a.hash_key IS NOT NULL;


-- keywords table
insert into _S22100229_DB.keywords (hash_key, term, count)
select DISTINCT
    a.doc_hashkey,
    a.term,
    a.count
from Problem26.allrecords a where doc_hashkey is not null;
