use _S22100229_DB;

create table qna(
    id smallint primary key,
    title varchar(32) not null,
    content varchar(100) not null,
    user_id varchar(20) not null,
    status tinyint not null,
    reg_date date not null,
    mod_date date not null,

    foreign key (user_id) references user(id),
    foreign key (status) references  status_info(id)
);

create table status_info(
    id tinyint primary key,
    status varchar(10) not null default 'open'
);

create table reply(
    qna_id smallint not null,
    user_id varchar(20) not null,
    content varchar(150) not null,
    reply_date date not null,

    primary key (qna_id, user_id),
    foreign key (user_id) references user(id),
    foreign key (qna_id) references qna(id)
);

insert into status_info (id, status)
values (0 , 'open'), (1,'answered');

insert into qna (id, title, content, user_id, status, reg_date, mod_date)
select distinct a.qna_id,
       a.qna_title,
       a.qna_content,
       a.qna_user_id,
       s_info.id,
       a.qna_reg_date,
       a.qna_mod_date
from Problem26.allrecords a
join status_info s_info on a.status = s_info.status
where a.qna_id is not null;

insert into reply (qna_id, user_id, content, reply_date)
select distinct a.qna_id,
                a.reply_user_id,
                a.reply_content,
                a.reply_date
from Problem26.allrecords a where a.qna_id is not null and a.status = 'answered';