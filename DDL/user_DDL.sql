# use _S22100229_DB;


use Team25;
create table user(
    id                    varchar(20)     primary key ,
    name                  varchar(5)         not null ,
    email                 varchar(40)         not null,
    institution_id        tinyint         not null,
    user_title            tinyint         not null,
    user_reg_date         date         not null,
    isAdmin               bool     not null,
    foreign key (institution_id) references institution_info(id),
    foreign key (user_title) references user_title_info(title_id)
);


create table institution_info(
    id  tinyint primary key,
    name char(5) not null
);


create table user_title_info(
    title_id tinyint primary key,
    title varchar(4) not null
);

create table saved_doc(
    has_key bigint unsigned not null,
    user_id varchar(20) not null,
    saved_date date not null,

    primary key (has_key,user_id),
    foreign key (has_key) references documents(has_key),
    foreign key (user_id) references user(id)
);

insert into institution_info (id, name)
values (0,'경북대학교'),
       (1,'고려대학교'),
       (2,'부산대학교'),
       (3,'서강대학교'),
       (4,'서울대학교'),
       (5,'연세대학교'),
       (6,'한동대학교'),
       (7,'한양대학교');

insert into user_title_info (title_id, title)
values (0,'교수'),
       (1,'일반회원'),
       (2,'대학생'),
       (3,'연구원'),
       (4,'교직원'),
       (5,'대학원생');

insert into user (id, name, email, institution_id, user_title, user_reg_date, isAdmin)
select distinct a.id,
       a.name,
       a.email,
       inst.id,
       title_info.title_id,
        a.user_reg_date,
        case
            when lower(a.isAdmin) = 'true' then true
            when lower(a.isAdmin) = 'false' then false
        end
from Problem26.allrecords a
    join institution_info inst on inst.name = a.institution
    join user_title_info title_info on title_info.title = a.user_title
where a.id is not null ;

-- encoding 방식 문제 해결
ALTER TABLE Team25.institution_info
    MODIFY name char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

ALTER TABLE Team25.user_title_info
    MODIFY title varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

insert into saved_doc (has_key, user_id, saved_date)
select distinct a.saved_doc_hash_key, a.user_id, a.saved_date
from Problem26.allrecords a where a.saved_doc_hash_key is not null;
