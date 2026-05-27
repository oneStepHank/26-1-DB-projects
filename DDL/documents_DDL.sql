use _S22100229_DB;

use Team25;
create table topic(
                      topic_id tinyint primary key,
                      topic varchar(4) null
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

CREATE TABLE documents(
                          has_key bigint unsigned primary key,
                          doc_title             varchar(250)     not null ,
                          post_date             datetime  not null ,
                          topic_id                tinyint    not null,

                          foreign key (topic_id) references topic(topic_id)
);


create table keywords(
    hash_key bigint unsigned not null,
    term_id smallint not null,
    count int not null,

    primary key (hash_key, term_id),
    foreign key (hash_key) references documents(has_key),
    foreign key (term_id) references  keywords_dict(id)
);


-- keywords dictionary term
create table keywords_dict(
    id smallint auto_increment primary key,
    term varchar(255) not null unique
);

insert into keywords_dict (term)
select distinct term from Problem26.allrecords a where a.term is not null;

-- encoding 문제
ALTER TABLE Team25.keywords_dict
    MODIFY term VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

ALTER TABLE Team25.topic
    MODIFY topic VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;


# select distinct term
# from Problem26.allrecords where term is not null order by term;
# analyze table keywords_dict;
#
# select count(*)
# from keywords_dict;




-- documents table
insert into documents (has_key, doc_title, post_date, topic_id)
SELECT DISTINCT
    a.hash_key,
    a.doc_title,
    STR_TO_DATE(post_date, '%Y-%m-%d %h:%i:%s %p'),
    t.topic_id
FROM Problem26.allrecords a
         inner JOIN topic t
              ON a.topic <=> t.topic
WHERE a.hash_key IS NOT NULL;


-- keywords table
insert into keywords (hash_key, term_id, count)
select DISTINCT
    a.doc_hashkey,
    kd.id,
    a.count
from Problem26.allrecords a
join keywords_dict kd on kd.term = a.term
where doc_hashkey is not null;
