use hospital;

create table doctor(
	doc_id int unsigned not null,
    medical_subject varchar(30),
    doc_name varchar(20) not null,
    doc_sex char(1) not null,
    doc_phone varchar(20),
    doc_email varchar(30),
    doc_rank varchar(20), -- not null
    primary key(doc_id)
);

create table nurse(
	nur_id int unsigned not null,
    assigned_task varchar(30),
    nur_name varchar(20) not null,
    nur_sex char(1) not null,
    nur_phone varchar(20),
    nur_email varchar(30),
    nur_rank varchar(20), -- not null;
    primary key(nur_id)
);

create table patient(
	pat_id int unsigned not null,
    nur_id int unsigned not null,
    doc_id int unsigned not null,
    pat_name varchar(20) not null,
    pat_sex char(1), --
    pat_rrn varchar(14), --
    pat_address varchar(40),
    pat_phone varchar(20),
    pat_email varchar(30),
    pat_job varchar(30),
    primary key(pat_id),
    foreign key (nur_id) references nurse(nur_id),
    foreign key (doc_id) references doctor(doc_id)
);

create table consultation(
	con_id int unsigned not null,
    pat_id int unsigned not null,
    doc_id int unsigned not null,
    con_content varchar(1000) not null,
    con_date date not null,
	primary key (con_id,pat_id,doc_id),
    foreign key (pat_id) references patient(pat_id),
    foreign key (doc_id) references doctor(doc_id)
);

create table chart(
	chart_num int unsigned not null,
    con_id int unsigned not null,
    doc_id int unsigned not null,
    pat_id int unsigned not null,
    nur_id int unsigned not null,
    chart_content varchar(1000) not null,
    primary key(chart_num,con_id,doc_id,pat_id),
    foreign key (con_id) references consultation(con_id),
    foreign key (doc_id) references consultation(doc_id),
    foreign key (pat_id) references consultation(pat_id),
    foreign key (nur_id) references nurse(nur_id)
);

drop table doctor;
drop table patient;
drop table consultation;
drop table nurse;
drop table chart;