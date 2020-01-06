import psycopg2

#class Sentence to save information of sentence from table
class Sentence:
    def __init__(self, row):
        self.sentence_id = row[0]
        self.content = row[1]
        self.negative = row[2]
        self.positive = row[3]
        self.source = row[4]
        self.labeled = row[5]
        self.note = row[6]

#Connect to database
connection = psycopg2.connect(user='postgres',
                              password='123456',
                              host='127.0.0.1',
                              port='5432',
                              database='javy_db')
cursor = connection.cursor()

#Get data from table unlabeled_sentences
select_unlabled_query = """SELECT * FROM unlabeled_sentences"""
cursor.execute(select_unlabled_query)
unlabeled_record = cursor.fetchall()

#List of sentences in table unlabeled_sentences
unlabeled_sentences = []

for row in unlabeled_record:
    sentence = Sentence(row)
    unlabeled_sentences.append(sentence)

#Function check condition of sentence to move to labeled_sentences
def check_labeled(sentence):
    if((sentence.negative + sentence.positive) == 11):
        return 1

#Function to get label of sentence
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


for sentence in unlabeled_sentences:
    get_label(sentence)

cursor.close()
connection.close()