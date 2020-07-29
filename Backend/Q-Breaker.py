from sys import getsizeof
from flask import Flask, request
from flask_db2 import DB2
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# importing required modules

app = Flask(__name__)
app.config['DB2_DATABASE'] = 'BLUDB'
app.config['DB2_HOSTNAME'] = 'dashdb-txn-sbox-yp-lon02-06.services.eu-gb.bluemix.net'
app.config['DB2_PORT'] = 50000
app.config['DB2_PROTOCOL'] = 'TCPIP'
app.config['DB2_USER'] = 'snw47716'
app.config['DB2_PASSWORD'] = '4s23xgkv-p4sxnhn'
db = DB2(app)


@app.route('/cus_signup', methods=['GET', 'POST'])
def cus_signin():
    x = request.json
    username = x["username"]
    password = x["password"]
    phone = x["phone"]
    email = x["email"]
    pincode = x["pincode"]
# Getting the necessary details from the user
    cursor = db.connection.cursor()
    cursor.execute(
        "SELECT * FROM customer WHERE  phone=?", [phone])
    row = cursor.fetchone()
# Checking whether the user is already signed up
    if (row is not None):
        resp = "failure"
    else:
        sql = ("INSERT INTO customer(username,password,phone,email,pincode) VALUES(?,?,?,?,?)")
# If not Adding them into the Database
        cursor = db.connection.cursor()
        cursor.execute(sql, (username, password, phone, email, pincode))
        resp = "success"
    return resp

@app.route('/cus_login', methods=['GET', 'POST'])
def cus_login():
    x = request.json
    username = x["username"]
    password = x["password"]
# Getting username and password for login
    cursor = db.connection.cursor()
    cursor.execute(
        "SELECT * FROM customer WHERE username=? AND password=?", [username, password])
    print(getsizeof(cursor))
    row = cursor.fetchone()
# Checking the validation of the user
    print(row)
    if (row is None):
        resp = "failure"
    else:
        resp = "success"
    return resp

@app.route('/mer_signup', methods=['GET', 'POST'])
def mer_signin():
    x = request.json
    print(x)
    username = x["username"]
    password = x["password"]
    phone = x["phone"]
    email = x["email"]
    shopname = x["shopname"]
    allowances = x["allowance"]
    open_closed = x["open_closed"]
    address = x["address"]
    city = x["city"]
    state = x["state"]
    country = x["country"]
    pincode = x["pincode"]
# Getting Merchants's details
    cursor = db.connection.cursor()
    cursor.execute(
        "SELECT * FROM customer WHERE  phone=?", [phone])
    row = cursor.fetchone()
#
    if (row is not None):
        resp = "failure"
    else:
        sql = ("INSERT INTO merchantdata VALUES(?,?,?,?,?,?,?,?,?,?,?,?)")
        cursor = db.connection.cursor()
        cursor.execute(sql, (
        username, password, phone, email, shopname, allowances, open_closed, address, city, state, country, pincode))
# Merchant's details is fed into the database "MERCHANTDATA"
        resp = "success"
    return resp

@app.route('/mer_login', methods=['GET', 'POST'])
def mer_login():
    x = request.json
    username = x["username"]
    password = x["password"]
# Getting username and password from Merchant
    cursor = db.connection.cursor()
    cursor.execute(
        "SELECT * FROM merchantdata WHERE username=? AND password=?", [username, password])
    row = cursor.fetchone()
# Checking the validation of the merchant
    if (row is None):
        resp = "failure"
    else:
        resp = "success"
    return resp

@app.route('/data', methods=['GET', 'POST'])
def display():
    x = request.json
    number = x["number"]
    cursor = db.connection.cursor()
    cursor.execute(
        "SELECT shopname,address,pincode,phone,open_closed FROM merchantdata where merchantdata.phone=" + str(number))
    row = cursor.fetchall()
# Fetching the details of merchant from the table MERCHANTDATA
    list = []
    for i in row:
        name, loc, pin, ph, o_c = i
        b = {}
        b['name'] = name
        b['loc'] = loc
        b['pin'] = pin
        b['ph'] = ph
        if o_c == "OPEN":
            b['o_c'] = True
        else:
            b['o_c'] = False
        list.append(b)
        break
    return {"data": list}
#Sending the Merchant's details

@app.route('/customer', methods=['GET', 'POST'])
def customer():
    x = request.json
    name = x["name"]
    pin = x["pin"]
    cursor = db.connection.cursor()
    cursor.execute(
        "SELECT shopname,address,phone,open_closed FROM merchantdata WHERE merchantdata.pincode =" + str(pin))

    row = cursor.fetchall()
    cursor.execute("SELECT ID FROM customer WHERE customer.username=?", [name])
    ID = cursor.fetchall()
    list = []
    for i in row:
        mname, loc, num, o_c = i
        print(mname)
        cursor.execute("SELECT COUNT(*) FROM queue WHERE shopname='" + str(mname) + "'")
        data = cursor.fetchall()
# Fetching the no of counts of shop
        b = {}
        b['name'] = mname
        b['address'] = loc
        b['num'] = num
        b['o_c'] = o_c
        b['mdata'] = str(data[0][0])
        list.append(b)
    return {"data": list, "ID": ID[0][0]}
# Returning data

@app.route('/on_off', methods=['GET', 'POST'])
def on_off():
    x = request.json
    number = x["number"]
    value = x["value"]
    resp = "OPEN"
# Initializing the value
    if value != True:
        resp = "CLOSED"
    sql = ("UPDATE merchantdata SET open_closed=? WHERE merchantdata.phone=" + str(number))
    cursor = db.connection.cursor()
    cursor.execute(sql, (resp,))
# Updating the database table
    return "success"

@app.route('/queue', methods=['GET', 'POST'])
def Queue():
    x = request.json
    ID = x["ID"]
    user = x["user"]
    shopname = x["shopname"]
    merch_phone = x["merch_phone"]
    status = x["status"]

    cursor = db.connection.cursor()
    cursor.execute(
        "SELECT * FROM queue WHERE queue.ID=? ", [ID])
    row = cursor.fetchone()
# fetching whether the person is in the queue already or not!
    if (row is not None):
        resp = "failure"
    else:
        sql = ("INSERT INTO queue(ID,username,shopname,merch_phone,status) VALUES(?,?,?,?,?)")
        cursor = db.connection.cursor()
        cursor.execute(sql, (ID, user, shopname, merch_phone, status))
# If not, inserting them into the (virtual Queue) database
        resp = "success"
    return resp

@app.route('/details', methods=['GET', 'POST'])
def details():
    x = request.json
    merch_phone = x["merch_phone"]
    cursor = db.connection.cursor()
    cursor.execute(
        "SELECT username,status FROM queue where queue.merch_phone=" + str(merch_phone))

    row = cursor.fetchall()
    list = []
    for i in row:
        cname, sts = i
        b = {}
        b['cname'] = cname
        b['sts'] = sts
        list.append(b)
# Returning the details
    return {"data": list}

@app.route('/qID', methods=['GET', 'POST'])
def qID():
    x = request.json
    ID = x["ID"]
    shop_name = x["shop_name"]
    cursor = db.connection.cursor()
    cursor.execute(
        "SELECT count(*) FROM queue WHERE shopname=? AND queue.status='ACTIVE' AND S_ID<=(SELECT S_ID FROM queue WHERE ID=?)",
        (shop_name, ID))
    row = cursor.fetchone()
# Fetching the no of counts in that queue list which have a status active!
    cursor.execute("SELECT allowances FROM merchantdata WHERE merchantdata.shopname=?", [shop_name])
    num = cursor.fetchone()
# num is fetching whether the max no of persons allowed in a shop at a time
    value = int(row[0])
    if value <= int(num[0]):
        return {'pos': str(row[0]), 'key': "YES"}
    else:
        return {'pos': str(row[0]), 'key': "NO"}
# Returning whether the person is below the no of allowances or above the no of allowances
# Returning thier positions

@app.route('/update', methods=['GEt', 'POST'])
def update():
    x = request.json
    ID = x["ID"]
    sql = ("DELETE FROM queue WHERE queue.ID=" + ID)
    cursor = db.connection.cursor()
    cursor.execute(sql, )
# updating the table after the person left from the shop
    return "success"

@app.route('/cus_reset', methods=['GET', 'POST'])
def cus_reset():
    x = request.json
    name = x["name"]
    cursor = db.connection.cursor()
    cursor.execute("SELECT password FROM customer WHERE customer.username=?", [name])
    num = cursor.fetchone()
#Fetching the previous password from the table
    cursor.execute("SELECT email FROM customer WHERE customer.username=?", [name])
    email = cursor.fetchone()
# Fetching the email id which is given in signup
    mail_content = "Your Previous Password is :  " + str(num[0])
# The mail addresses and password
    sender_address = 'queuebreakerr@gmail.com'
    sender_pass = 'qbreaker@sss'
    receiver_address = str(email[0])
# Setup the MIME
    message = MIMEMultipart()
    message['From'] = sender_address
    message['To'] = receiver_address
    message['Subject'] = 'RESET PASSWORD'  # The subject line
# The body and the attachments for the mail
    message.attach(MIMEText(mail_content, 'plain'))
# Create SMTP session for sending the mail
    session = smtplib.SMTP('smtp.gmail.com', 587)
# use gmail with port
    session.starttls()  # enable security
    session.login(sender_address, sender_pass)
# login with mail_id and password
    text = message.as_string()
    session.sendmail(sender_address, receiver_address, text)
    session.quit()
    return "success"

@app.route('/mer_reset', methods=['GET', 'POST'])
def mer_reset():
    x = request.json
    name = x["name"]
    cursor = db.connection.cursor()
    cursor.execute("SELECT password FROM merchantdata WHERE merchantdata.username=?", [name])
    num = cursor.fetchone()
    cursor.execute("SELECT email FROM merchantdata WHERE merchantdata.username=?", [name])
    email = cursor.fetchone()
    print(str(num[0]))
    print(str(email[0]))
    mail_content = "Your Previous Password is:" + str(num[0])
# The mail addresses and password
    sender_address = 'queuebreakerr@gmail.com'
    sender_pass = 'qbreaker@sss'
    receiver_address = str(email[0])
# Setup the MIME
    message = MIMEMultipart()
    message['From'] = sender_address
    message['To'] = receiver_address
    message['Subject'] = 'RESET PASSWORD' # The subject line
# The body and the attachments for the mail
    message.attach(MIMEText(mail_content, 'plain'))
# Create SMTP session for sending the mail
    session = smtplib.SMTP('smtp.gmail.com', 587)
# use gmail with port
    session.starttls()
# enable security
    session.login(sender_address, sender_pass)
# login with mail_id and password
    text = message.as_string()
    session.sendmail(sender_address, receiver_address, text)
    session.quit()
    return "success"

if __name__ == '__main__':
    app.run()
