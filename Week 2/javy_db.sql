DROP TABLE IF EXISTS unlabeled_sentences;
DROP TABLE IF EXISTS labeled_sentences;

CREATE TABLE IF NOT EXISTS unlabeled_sentences(
	sentence_id VARCHAR (20) PRIMARY KEY,
	content	TEXT,
	negative INT DEFAULT 0,
	positive INT DEFAULT 0,
	source VARCHAR (30),
	labeled VARCHAR (10) DEFAULT NULL,
	note TEXT DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS labeled_sentences(
	sentence_id VARCHAR (20) PRIMARY KEY,
	content	TEXT,
	negative INT DEFAULT 0,
	positive INT DEFAULT 0,
	source VARCHAR (30),
	labeled VARCHAR (10),
	note TEXT DEFAULT NULL
);

INSERT INTO unlabeled_sentences (sentence_id, content, negative, positive, source)
VALUES
	('a0001', 'ib thì sáng đến tối không rep lại, gọi điện cũng k thấy onl để đặt đồ. hôm sau đặt qua web chờ 4 hôm gọi lại thì kêu đơn trên web không ai nhận. không hiểu đi xin hay đi mua đồ nữa', 7, 4, 'facebook'),
	('a0002', 'Đã là Fan trung thành của gỏi đã 2 năm chất lượng đồ tốt , vải mặc bền , giá cả phải chăng hợp túi tiền . Sẽ tiếp tục ủng hộ những sản phẩm mới của shop', 3, 8, 'facebook'),
	('a0003', 'Hàng khá ok! Mua áo longtee chất rất thoải mái...', 3, 4, 'message'),
	('a0004', 'nt nhiều lần mà shop ko bao giờ rep :(((((', 7, 1, 'facebook'),
	('a0005', 'Mà mình có vài điều góp ý là: còn hơi ít mẫu để lựa và shop nên nâng cao chất lượng dù đã ok r đó nhưng phải hơn nữa.', 5, 6, 'facebook'),
	('a0006', 'Shop hàng đẹp chất liệu oke lắm..nhưng bạn nào thích style unises hoặc bụi thì shop là đúng gu luôn. NV tư vấn siêu nhiệt tình. Sẽ ủng hộ shop dài dài', 5, 5, 'message'),
	('a0007', 'đặt hàng bên shop nhưng khi gửi hàng bị nhầm size, mình có thông báo cho shop biết về sự nhầm lẫn, biết là bận nhưng đâu bận đến nỗi ko nói được 1 lời xin lỗi.', 9, 2, 'facebook'),
	('a0008', 'Đồ shop đẹp cực luôn. Hợp với phong cách của mình. Đồ chất lắm luôn . Cực thích😍', 10, 1, 'facebook'),
	('a0009', 'Tui là nữ, mà cũng bị ghiền mua đồ shop này mặc lắm :))) nhân viên dễ thương, mà quần áo lại đẹp :)))', 1, 3, 'facebook');
