use _S22100229_DB;

# select distinct announcement_id, announcement_content, announcement, announcement_user_id,
#                 announcement_mod_date, announcement_reg_date, is_main_announce
# from Problem26.allrecords;

create table announcements (
    id tinyint primary key,
    is_main boolean not null default false,
    user_id varchar(20) not null,
    content varchar(500) not null,
    announcement varchar(50) not null,
    reg_date date not null,
    mod_date date not null
);

insert into announcements (id, is_main, user_id, content, announcement, reg_date, mod_date)
select distinct
    a.announcement_id,
    case
        when a.is_main_announce = 'true' then true
        else false
    end,
    a.announcement_user_id,
    a.announcement_content,
    a.announcement,
    a.announcement_reg_date,
    a.announcement_mod_date
from Problem26.allrecords a where a.announcement_id is not null;

# select distinct is_main_announce
# from Problem26.allrecords where isAdmin = 'true';