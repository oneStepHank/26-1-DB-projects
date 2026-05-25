use _S22100229_DB;

create table faq(
    faq_id                tinyint      primary key ,
    faq_category          varchar(4)      not  null,
    faq_title             varchar(32)    not null,
    faq_content           varchar(500)       not  null,
    faq_user_id           varchar(20)    not null
);

insert into faq (faq_id, faq_category, faq_title, faq_content, faq_user_id)
SELECT distinct
    a.faq_id,
    a.faq_category,
    a.faq_title,
    a.faq_content,
    a.faq_user_id
    from Problem26.allrecords a

    where a.faq_id is not null;

-- faq_user_id <-> user_id mapping 확인용
select user_id
from Problem26.allrecords
where user_id in (select distinct faq_user_id
                  from Problem26.allrecords
    );