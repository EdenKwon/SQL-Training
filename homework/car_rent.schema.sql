use carrent;

create table carrentcompany(
	company_id int unsigned not null primary key,
    company_name varchar(30) not null,
    company_addr varchar(50) not null,
    company_tel varchar(50) not null,
    manager_name varchar(50) not null,
    manager_email varchar(50) not null
);

create table cargarage(
	garage_id int unsigned not null primary key,
    garage_name varchar(30) not null,
    garage_addr varchar(50) not null,
    garage_tel varchar(13) not null,
    manager_name varchar(30) not null,
    manager_email varchar(30) not null
);

create table customer(
	drive_license_num varchar(15) not null primary key,
    customer_name varchar(30) not null,
    customer_addr varchar(50) not null,
    customer_tel varchar(13) not null,
    customer_email varchar(30),
    prev_used_date varchar(30) not null,
    prev_used_type varchar(20) not null
);

create table campingcar(
	car_id int unsigned not null,
    company_id int unsigned not null,
    car_name varchar(30) not null,
    car_num varchar(8) not null,
    car_people varchar(2),
    car_image_url varchar(50),
    car_detail varchar(1000),
    car_rent_fee varchar(10) not null,
    car_regis_date varchar(10) not null,
    primary key(car_id, company_id),
    foreign key(company_id) references carrentcompany(company_id)
);

create table carrepairinfo(
	repair_id int unsigned not null primary key,
	car_id int unsigned not null,
	garage_id int unsigned not null,
	company_id int unsigned not null,
	drive_license_num varchar(15) not null,
	repair_history varchar(1000),	
	repair_date varchar(20),
	repair_fee int not null,
	due_date varchar(20) not null,
    etc_repair_history varchar(1000),
    foreign key(car_id) references campingcar(car_id),
    foreign key(garage_id) references cargarage(garage_id),
    foreign key(company_id) references carrentcompany(company_id),
    foreign key(drive_license_num) references customer(drive_license_num)
);

create table carrent(
	rent_num int unsigned not null primary key,
	car_id int unsigned not null,
	drive_license_num varchar(15) not null,
	company_id int unsigned not null,
	rent_start_date varchar(20) not null,
	rent_period varchar(30) not null,
	billing_fee int not null,
	due_date varchar(20) not null,
	etc_billing_details varchar(1000),
	etc_billing_fee int,
    foreign key(car_id) references campingcar(car_id),
    foreign key(drive_license_num) references customer(drive_license_num),
    foreign key(company_id) references carrentcompany(company_id)
);
