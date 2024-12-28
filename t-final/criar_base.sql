create table company
(
    id   int auto_increment
        primary key,
    name varchar(100) null
);

create table knowledge_area
(
    id   int auto_increment
        primary key,
    name varchar(100) null
);

create table mentoring_status
(
    id   int auto_increment
        primary key,
    name varchar(50) null
);

create table nationality
(
    id      int auto_increment
        primary key,
    country varchar(100) null
);

create table position
(
    id   int auto_increment
        primary key,
    name varchar(100) not null
);

create table role
(
    id   int auto_increment
        primary key,
    name varchar(100) null
);

create table skill
(
    id                int auto_increment
        primary key,
    name              varchar(100) null,
    knowledge_area_id int          not null,
    constraint skill_knowledge_area_id_fk
        foreign key (knowledge_area_id) references knowledge_area (id)
);

create table user
(
    id                int auto_increment
        primary key,
    email             varchar(50)   not null,
    password          varchar(500)  not null,
    name              varchar(100)  null,
    profile_image     mediumblob    null,
    role_id           int           null,
    nationality_id    int           null,
    short_description varchar(1000) null,
    verified          tinyint(1)    null,
    created_at        datetime      null,
    updated_at        datetime      null,
    constraint user_nationality_id_fk
        foreign key (nationality_id) references nationality (id),
    constraint user_role_id_fk
        foreign key (role_id) references role (id)
);

create table mentoring_plan
(
    id         int auto_increment
        primary key,
    cost       int      null,
    mentorr_id int      not null,
    duration   datetime null,
    constraint mentoring_plan_user_id_fk
        foreign key (mentorr_id) references user (id)
);

create table mentoring
(
    id                  int auto_increment
        primary key,
    date                datetime null,
    mentoring_status_id int      not null,
    mentorr_id          int      not null,
    client_id           int      not null,
    mentoring_plan_id   int      not null,
    constraint mentoring_mentoring_plan_id_fk
        foreign key (mentoring_plan_id) references mentoring_plan (id),
    constraint mentoring_mentoring_status_id_fk
        foreign key (mentoring_status_id) references mentoring_status (id),
    constraint mentoring_user_id_fk
        foreign key (mentorr_id) references user (id),
    constraint mentoring_user_id_fk_2
        foreign key (client_id) references user (id)
);

create table review
(
    id           int auto_increment
        primary key,
    rating       int           null,
    comment      varchar(2000) null,
    mentoring_id int           not null,
    created_at   datetime      null,
    constraint review_mentoring_id_fk
        foreign key (mentoring_id) references mentoring (id)
);

create table user_company
(
    id         int auto_increment
        primary key,
    user_id    int not null,
    company_id int not null,
    constraint user_company_company_id_fk
        foreign key (company_id) references company (id),
    constraint user_company_user_id_fk
        foreign key (user_id) references user (id)
);

create table user_knowledge_area
(
    id                int auto_increment
        primary key,
    user_id           int not null,
    knowlegde_area_id int not null,
    constraint user_knowledge_area_knowledge_area_id_fk
        foreign key (knowlegde_area_id) references knowledge_area (id),
    constraint user_knowledge_area_user_id_fk
        foreign key (user_id) references user (id)
);

create table user_position
(
    id          int auto_increment
        primary key,
    user_id     int not null,
    position_id int null,
    constraint user_position_position_id_fk
        foreign key (position_id) references position (id),
    constraint user_position_user_id_fk
        foreign key (user_id) references user (id)
);

create table user_skill
(
    id       int auto_increment
        primary key,
    user_id  int not null,
    skill_id int not null,
    constraint user_skill_skill_id_fk
        foreign key (skill_id) references skill (id),
    constraint user_skill_user_id_fk
        foreign key (user_id) references user (id)
);

