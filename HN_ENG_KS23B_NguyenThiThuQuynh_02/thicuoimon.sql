create database hotel_manager;
use hotel_manager;
-- 1
create table customer (
    customer_id varchar(10) primary key,
    customer_full_name varchar(150) not null,
    customer_email varchar(255) unique not null,
    customer_address varchar(255) not null
);
create table room (
    room_id varchar(20) primary key,
    room_price decimal(10,2) not null,
    room_status enum('Available', 'Booked') not null,
    room_area int not null
);
create table booking (
    booking_id int primary key auto_increment ,
    customer_id varchar(10) not null,
    room_id varchar(20) not null,
    check_in_date date not null,
    check_out_date date not null,
    total_amount decimal(10,2) not null,
    foreign key (customer_id) references customer(customer_id) on delete cascade,
    foreign key (room_id) references room(room_id) on delete cascade
);


create table payment (
    payment_id int primary key auto_increment,
    booking_id int not null,
    payment_method varchar(50) not null,
    payment_date date not null,
    payment_amount decimal(10,2) not null,
    foreign key (booking_id) references booking(booking_id) on delete cascade
);
-- Phan2
alter table room add column room_type enum("single", "double", "suite");
alter table customer add column customer_phone char(15) not null unique;
alter table booking add constraint total_amount check (total_amount >= 0);


-- Phan 3
-- 1
insert into customer (customer_id,customer_full_name,customer_email,customer_phone,customer_address)
values
('C001','Nguyen Anh Tu','tu.nguyen@example.com','0912345678','Hanoi, Vietnam'),
('C002','Tran Thi Mai','mai.tran@example.com','0923456789','Ho Chi Minh, Vietnam'),
('C003','Le Minh Hoang','hoang.le@example.com','0934567890','Danang, Vietnam'),
('C004','Pham Hoang Nam','nam.pham@example.com','0945678901','Hue, Vietnam'),
('C005','Vu Minh Thu','thu.vu@example.com','0956789012','HaiPhong, Vietnam'),
('C006','Nguyen Thi Lan','lan.nguyen@example.com','0967890123','Quang Ninh, Vietnam'),
('C007','Bui Minh Tuan','tuan.bui@example.com','0978901234','Bac Giang, Vietnam'),
('C008','Pham Quang Hieu','hieu.pham@example.com','0989012345','Quang Nam, Vietnam'),
('C009','Le Thi Lan','lan.le@example.com','0990123456','Da lat, Vietnam'),
('C010','Nguyen Thi Mai','mai.nguyen@example.com','0901234567','Can Tho, Vietnam');

insert into room (room_id,room_type,room_price,room_status,room_area)
values
('R001','Single',100.0,'Available',25),
('R002','Double',150.0,'Booked',40),
('R003','Suite',250.0,'Available',60),
('R004','Single',120.0,'Booked',30),
('R005','Double',160.0,'Available',35);

insert into booking (booking_id,customer_id,room_id,check_in_date,check_out_date,total_amount)
values
(1,'C001','R001','2025-03-01','2025-03-05',400.0),
(2,'C002','R002','2025-03-02','2025-03-06',600.0),
(3,'C003','R003','2025-03-03','2025-03-07',2000.0),
(4,'C004','R004','2025-03-04','2025-03-08',4080.0),
(5,'C005','R005','2025-03-05','2025-03-09',8000.0),
(6,'C006','R001','2025-03-06','2025-03-10',4000.0),
(7,'C007','R002','2025-03-07','2025-03-11',600.0),
(8,'C008','R003','2025-03-08','2025-03-12',1000.0),
(9,'C009','R004','2025-03-09','2025-03-13',480.0),
(10,'C010','R005','2025-03-10','2025-03-14',800.0);

insert into payment (payment_id, booking_id, payment_method, payment_date, payment_amount) 
values
(1, 1, 'Cash', '2025-03-05', 400.0),
(2, 2, 'Credit Card', '2025-03-06', 600.0),
(3, 3, 'Bank Transfer', '2025-03-07', 200.0),
(4, 4, 'Cash', '2025-03-08', 4080.0),
(5, 5, 'Credit Card', '2025-03-09', 800.0),
(6, 6, 'Bank Transfer', '2025-03-10', 400.0),
(7, 7, 'Cash', '2025-03-11', 600.0),
(8, 8, 'Credit Card', '2025-03-12', 1000.0),
(9, 9, 'Bank Transfer', '2025-03-13', 480.0),
(10, 10, 'Cash', '2025-03-14', 800.0),
(11, 1, 'Credit Card', '2025-03-15', 400.0),
(12, 2, 'Bank Transfer', '2025-03-16', 600.0),
(13, 3, 'Cash', '2025-03-17', 1000.0),
(14, 4, 'Credit Card', '2025-03-18', 2040.0),
(15, 5, 'Bank Transfer', '2025-03-19', 4000.0),
(16, 6, 'Cash', '2025-03-20', 2000.0),
(17, 7, 'Credit Card', '2025-03-21', 600.0),
(18, 8, 'Bank Transfer', '2025-03-22', 1000.0),
(19, 9, 'Cash', '2025-03-23', 480.0),
(20, 10, 'Credit Card', '2025-03-24', 800.0);

-- 2

update booking b
join room r on b.room_id = r.room_id
set b.total_amount = r.room_price * (b.check_out_date - b.check_in_date) 
where r.room_status = 'booked'
and b.check_in_date < curdate();
-- 3
delete from payment
where payment_method = 'Cash' 
and payment_amount < 500;
-- phan 4 
-- 1. Lấy thông tin khách hàng gồm mã khách hàng, họ tên, email, số điện thoại và địa chỉ được sắp xếp theo họ tên khách hàng tăng dần.
select c.customer_id, c.customer_full_name, c.customer_email, c.customer_phone, c.customer_address
from customer c
order by c.customer_full_name asc;
-- 2. Lấy thông tin các phòng khách sạn gồm mã phòng, loại phòng, giá phòng và diện tích phòng, sắp xếp theo giá phòng giảm dần.
select r.room_id, r.room_type, r.room_price, r.room_area
from room r
order by r.room_price desc;
-- 3. Lấy thông tin khách hàng và phòng khách sạn đã đặt, gồm mã khách hàng, họ tên khách hàng, mã phòng, ngày nhận phòng và ngày trả phòng.
select b.customer_id, c.customer_full_name, b.room_id, b.check_in_date, b.check_out_date
from booking b
join customer c on b.customer_id = c.customer_id;
-- 4. Lấy danh sách khách hàng và tổng tiền đã thanh toán khi đặt phòng, gồm mã khách hàng, họ tên khách hàng, phương thức thanh toán và số tiền thanh toán, sắp xếp theo số tiền thanh toán giảm dần.
select c.customer_id, c.customer_full_name, p.payment_method, sum(p.payment_amount) as total_pay
from payment p
join booking b on p.booking_id = b.booking_id
join customer c on b.customer_id = c.customer_id
group by c.customer_id, c.customer_full_name, p.payment_method
order by total_pay desc;
-- 5. Lấy thông tin khách hàng từ vị trí thứ 2 đến thứ 4 trong bảng Customer được sắp xếp theo tên khách hàng.
select c.customer_id, c.customer_full_name, c.customer_email, c.customer_phone, c.customer_address
from customer c
order by c.customer_full_name
limit 3
offset 1;
-- 6. Lấy danh sách khách hàng đã đặt ít nhất 2 phòng và có tổng số tiền thanh toán trên 1000, gồm mã khách hàng, họ tên khách hàng và số lượng phòng đã đặt.
select c.customer_id, c.customer_full_name, 
count(b.booking_id) as total_bookings,
sum(b.total_amount) as total_amount
from customer c
join Booking b on b.customer_id = c.customer_id
join Payment p on b.booking_id = p.booking_id
group by c.customer_id, c.customer_full_name
having total_bookings >= 2 and total_amount > 1000;
--  7. Lấy danh sách các phòng có tổng số tiền thanh toán dưới 1000 và có ít nhất 3 khách hàng đặt, gồm mã phòng, loại phòng, giá phòng và tổng số tiền thanh toán.
select r.room_id, r.room_type, r.room_price, sum(b.total_amount)
from room r 
join booking b on r.room_id = b.room_id
join customer c on c.customer_id = b.customer_id
group by b.room_id
having sum(b.total_amount) < 1000 and count(b.room_id) >= 3;
-- 8. Lấy danh sách các khách hàng có tổng số tiền thanh toán lớn hơn 1000, gồm mã khách hàng, họ tên khách hàng, mã phòng, tổng số tiền thanh toán.
select c.customer_id, c.customer_full_name, b.room_id, sum(b.total_amount) as total_amount
from booking b
join customer c on b.customer_id = c.customer_id
group by c.customer_id, c.customer_full_name, b.room_id
having total_amount > 1000;
-- 9  Lấy danh sách các phòng có số lượng khách hàng đặt nhiều nhất và ít nhất, gồm mã phòng, loại phòng và số lượng khách hàng đã đặt
-- 10. Lấy danh sách các khách hàng có tổng số tiền thanh toán của lần đặt phòng cao hơn số tiền thanh toán trung bình của tất cả các khách hàng cho cùng phòng, gồm mã khách hàng, họ tên khách hàng, mã phòng, tổng tiền thanh toán

-- phần 5 
-- 1 
create view book_room_before_2025_03_10 as select r.room_id, r.room_type,c.customer_id,c.customer_full_name
from booking b 
join customer c on b.customer_id = c.customer_id
join room r on b.room_id = r.room_id
where b.check_in_date  < '2025-03-10';
drop view book_room_before_2025_03_10;
select * from book_room_before_2025_03_10;
-- 2
create view big_room_booked as select c.customer_id, c.customer_full_name, r.room_id, r.room_area
from booking b
join customer c on b.customer_id = c.customer_id
join room r on b.room_id = r.room_id
where r.room_area > 30;
drop view big_room_booked;
select * from big_room_booked;
-- Phần 6 
-- 1. Hãy tạo một trigger check_insert_booking để kiểm tra dữ liệu mối khi chèn vào bảng Booking. Kiểm tra nếu ngày đặt phòng mà sau ngày trả phòng thì thông báo lỗi với nội dung “Ngày đặt phòng không thể sau ngày trả phòng được !” và hủy thao tác chèn dữ liệu vào bảng.
delimiter //
create trigger trg_check_insert_booking 
before insert on booking
for each row 
begin
    if NEW.check_in_date > NEW.check_out_date then
        signal sqlstate '45000'
        set message_text = 'Ngày đặt phòng không thể sau ngày trả phòng được!';
    end if;
end //
delimiter ;
insert into booking (booking_id, room_id, check_in_date, check_out_date) 
values (2, 102, '2025-04-15', '2025-04-10');
-- 2. Hãy tạo một trigger có tên là update_room_status_on_booking để tự động cập nhật trạng thái phòng thành "Booked" khi một phòng được đặt (khi có bản ghi được INSERT vào bảng Booking).
delimiter //
create trigger trg_update_room_status_on_booking  after insert on booking
for each row
begin
	update room
    set room_status = 'Booked' where room_id = NEW.room_id;
end //
delimiter;
insert into booking (booking_id, room_id, check_in_date, check_out_date) 
value (1, 101, '2025-03-20', '2025-03-25');

-- phần 7 
-- 1. Viết store procedure có tên add_customer để thêm mới một khách hàng với đầy đủ các thông tin cần thiết.
delimiter //
	create procedure add_customer(
    in p_customer_id varchar(10),
    in p_customer_full_name varchar(150),
    in p_customer_email varchar(255),
    in p_customer_phone char(15),
    in p_customer_address varchar(255)
)
	begin
		insert into customer (customer_id, customer_full_name, customer_email, customer_phone, customer_address)
		values (p_customer_id, p_customer_full_name, p_customer_email, p_customer_phone, p_customer_address);
	end 
//
delimiter ;
drop procedure add_customer;
call add_customer('C011', 'Do Van Tuan', 'tuan.do@example.com', '0911222333', 'Ha Noi, Vietnam');
-- 2 Hãy tạo một Stored Procedure  có tên là add_payment để thực hiện việc thêm một thanh toán mới cho một lần đặt phòng.
delimiter  //
	create procedure add_payment(
		in p_booking_id int,
        in p_payment_method varchar(50),
        in p_payment_amount decimal(10,2),
        in p_payment_date date
    )
    begin 
		-- thực hiện việc thêm một thanh toán mới cho một lần đặt phòng.
		if not exists (select 1 from booking where booking_id = p_booking_id) then
        signal sqlstate '45000'
        set message_text = 'Lỗi  Booking ID không tồn tại.';
    else
        insert into payment (booking_id, payment_method, payment_amount, payment_date)
        values (p_booking_id, p_payment_method, p_payment_amount, p_payment_date);
    end if;
    end 
    //
delimiter ;
call add_payment (3, 'Credit Card', 1500.00, '2025-03-10');
drop procedure add_payment;



