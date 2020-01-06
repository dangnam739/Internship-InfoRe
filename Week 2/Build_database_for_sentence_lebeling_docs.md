# Build Database for sentence-labeling

### 1. Create Tables

**a. unlabeled_sentences**

Bảng này chứa những câu văn đang (hoặc chưa) trong quá trình dán nhãn.
Các câu văn này sẽ được lấy ra và gửi cho người dùng để họ dán nhãn.

Bao gồm các cột:

- `sentence_id` : `VARCHAR (20)` , id của các câu văn, ví dụ: "a0001", a0002",...
- `content`     : `TEXT`, nội dung của câu văn. 
- `negative`    : `INT`, số lượng dán nhãn của người dùng là ` tiêu cực `, mặc định = `0`.
- `positive`    : `INT`, số lượng dãn nhãn của người dùng là ` tích cực `. mặc định = `0`.
- `source`      : `VARCHAR (30)`, nơi lấy câu văn, vd: facebook, instagram, youtube,...
- `labeled `    : `VARCHAR (10)`, nhãn của câu văn, mặc định là `NULL` vì chưa được gán nhãn.
- `note`        : `TEXT`, ghi chú nếu có gì thêm.

```postgresql
CREATE TABLE IF NOT EXISTS unlabeled_sentences(
	sentence_id VARCHAR (20) PRIMARY KEY,
	content	TEXT,
	negative INT DEFAULT 0,
	positive INT DEFAULT 0,
	source VARCHAR (30),
	labeled VARCHAR (10) DEFAULT NULL,
	note TEXT DEFAULT NULL
);
```


**b. labeled_sentences**

Bảng này chứa những câu văn đã được gán nhãn từ việc tính xác suất dán nhãn của người dùng.

Khi một câu văn từ bảng `unlabeled_sentences` đạt tổng 11 lần dán nhãn từ người dùng. Nếu số lượng `negative` nhiều hơn `positive` thì đặt `labeled = "negative"` và ngược lại `labeled = "positive"`.

Bao gồm các cột:

- `sentence_id` : `VARCHAR (20)` , id của các câu văn, ví dụ: "a0001", a0002",...
- `content`     : `TEXT`, nội dung của câu văn. 
- `negative`    : `INT`, số lượng dán nhãn của người dùng là ` tiêu cực `, mặc định = `0`.
- `positive`    : `INT`, số lượng dãn nhãn của người dùng là ` tích cực `. mặc định = `0`.
- `source`      : `VARCHAR (30)`, nơi lấy câu văn, vd: facebook, instagram, youtube,...
- `labeled`     : `VARCHAR (10)`, nhãn của câu văn, `labeled` có thể là `negative` hoặc `positive`.
- `note`        : `TEXT`, ghi chú nếu có gì thêm.

```postgresql
CREATE TABLE IF NOT EXISTS labeled_sentences(
	sentence_id VARCHAR (20) PRIMARY KEY,
	content	TEXT,
	negative INT DEFAULT 0,
	positive INT DEFAULT 0,
	source VARCHAR (30),
	labeled VARCHAR (10),
	note TEXT DEFAULT NULL
);
```


### 2. Write function

**a. check_labeled()**

Chức năng: Kiểm tra một câu đã đủ điều kiện để dán nhãn hay chưa.

```python
#Function check condition of sentence to move to labeled_sentences
def check_labeled(sentence):
    if((sentence.negative + sentence.positive) == 11):
        return 1
```

**b. get_label()**

Chức năng: Xác định nhãn của câu đẫ đủ điều kiện để dán nhãn. Sau đó xóa khỏi bảng `unlabeled_sentences` và thêm vào bảng `labeled_sentences`.

```python
def get_label(sentence):
    if(check_labeled(sentence)):
        if(sentence.negative > sentence.positive):
            sentence.labeled = "negative"
        else:
            sentence.labeled = "positive"

        record_to_insert = (sentence.sentence_id, sentence.content, sentence.negative, sentence.positive,
                            sentence.source, sentence.labeled, sentence.note)
        delete_sentence_id = sentence.sentence_id

        # Insert new sentence from unlabeled_sentences to labeled_sentences
        insert_query = """INSERT INTO labeled_sentences VALUES (%s, %s, %s, %s, %s, %s, %s)"""

        # Delete sentence from unlabeled_sentences
        delete_sentence_query = """DELETE FROM unlabeled_sentences WHERE sentence_id = %s"""

        cursor.execute(delete_sentence_query, (delete_sentence_id,))
        connection.commit()

        cursor.execute(insert_query, record_to_insert)
        connection.commit()
```

[Create table]()
[Code](https://github.com/dangnam739/Internship-InfoRe/blob/master/Week%202/check_label.py)
