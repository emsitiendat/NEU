
CREATE TABLE DMLOP (MALOP CHAR(10) PRIMARY KEY,
TENLOP NCHAR(100), SOSV INT);

CREATE TABLE SINHVIEN (MASV CHAR(10) PRIMARY KEY, 
TENSV NCHAR(50), GIOITINH NCHAR(5), 
NGAYSINH DATE, MALOP CHAR(10) REFERENCES DMLOP(MALOP), 
NOISINH NCHAR(100), HOCBONG FLOAT);

CREATE TABLE MONHOC (MAMH CHAR(10) PRIMARY KEY, 
TENMH NCHAR(50), SOTC INT);

CREATE TABLE DIEM
(MASV CHAR(10) NOT NULL REFERENCES SINHVIEN(MASV),
MAMH CHAR(10) NOT NULL REFERENCES MONHOC(MAMH),
DCHUYENCAN FLOAT, DKTRA FLOAT, DTHI FLOAT, 
DHOCPHAN FLOAT PRIMARY KEY(MASV,MAMH));
insert into DMLOP (MALOP, TENLOP, SOSV) values
('L2', 'ABC', '200')
insert into SINHVIEN (MASV, TENSV, GIOITINH, NGAYSINH, MALOP, NOISINH, HOCBONG) values 
('SV2', 'Thu Dat', 'Nu', '2005-09-04', 'L2', 'Ha Noi', '2.5')
insert into DIEM (MASV, MAMH, DCHUYENCAN, DKTRA, DTHI) values 
('SV2', 'MH2', '9', '9', '7');
insert into MONHOC (MAMH, TENMH, SOTC) values
('MH2', 'Tieng anh', '2')


create trigger trg_tinhdiemhp on DIEM after insert
as
begin
update DIEM
set	DHOCPHAN = (inserted.DCHUYENCAN*0.1 + inserted.DKTRA*0.4 + inserted.DTHI*0.5)
from DIEM, inserted
where DIEM.MASV = inserted.MASV and DIEM.MAMH = inserted.MAMH
end
go

select * from DIEM
select * from DMLOP
select * from MONHOC
select * from SINHVIEN

insert into DIEM (MASV, MAMH, DCHUYENCAN, DKTRA, DTHI) values
('SV2', 'MH2', '9', '9', '4')

--create trigger Trg_THEMHANGBAN on HANGBAN for insert
--as
--begin
--update DMHANGHOA
--set soluongton = soluongton - (
	--select soluongban from inserted
	--where inserted.Mahang = DMHANGHOA.Mahang)
	--from DMHANGHOA, inserted where DMHANGHOA.Mahang = inserted.Mahang
	--update HANGBAN set thanhtien = inserted.soluongban*dongia
	--from DMHANGHOA, HANGBAN, inserted
	--where DMHANGHOA.Mahang = HANGBAN.Mahang and HANGBAN.Maban = inserted.Maban
	--end
	--go

	--execute sp_themhangban 'MB101', 'HH1', '12/01/2004', 'Hong', 200
	
	--create trigger trg_SUAHANGBAN on HANGBAN for update
	--as
	--begin
	--update DMHANGHOA set SOLUONGTON = SOLUONGTON - 


	drop table DMLOP


create proc sp_thongke1 @option int, @ma varchar(10), @so varchar(30)
as
begin
	if @option = 1
	begin
		select count(*) as tongsophong from
		(select maphong, count(maphong) as sosv from dangkyphongo
		where namhoc = @so group by maphong) as a where a.sosv < 15
	end
	if @option = 2
	begin
		select ((select sum(soluongcho) as tongcho from phongo
		where manha = @ma) - (select count(*) as tongchodao from dangkyphongo, phongo
		where dangkyphongo.maphong = phongo.maphong and phongo. manha = @ma)) as sochocontrong
	end
end
exec sp_thongke1 '1', 'N01', '2020'
exec sp_thongke1 '2', 'N01', '2020'