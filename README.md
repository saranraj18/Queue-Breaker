# Queue-Breaker
Queue Breaker, as the name suggests, this app breaks long queues which dismisses the spreading of CoVid-19.
One preferred way to prevent the spread is to maintain the social distancing at this situation.
So, we’ve developed a mobile application which can be used by both customers and merchants. 
Using this mobile app, we can avoid unwanted queue in markets and shops where maintaining social distancing is mandatory. 
By using this app, user can pre-block their position in the virtual queue, so that they need not stand in the line.  
Instead, they can be away from the shops and their position in the virtual queue is generated. 
This helps the customers to get rid of long queues and keeps them safe.
Customers can access their nearby shops, similarly Merchants can also access the queue for their shop.
For instance, we can use this in Pharmacy, Supermarkets, Fruits and Vegetable Stalls, etc., where people can avoid crowds.
Queue Breaker contains two interfaces, Merchant UI and Customer UI respectively.
Customers and Merchants travel in a different path where they are merged together through the virtual queue.
Basic detail of every customer is loaded into IBM DB2 Cloud Storage.
Similarly, Merchants load their basic details as well as their shop details to DB2 through SQL with Flask Web. 
Customer needs to enter the postal code which acts as the location provider and fetches back the available shop details.
Now, the fetched results are shown as a list in Customer’s UI with which they can access to join in the virtual queue of any particular shop at a time. 
Customers can see the address, phone number, availability of shop (Open/Closed) and the number of persons waiting in the queue of shops. 
Thus, it helps customers to plan accordingly and visit the shop safely by preventing the crowd. 
Customers know their position in the queue, which gets updated in real time when their positions get changed.
Exit button is pressed either when the customer wishes to go out in mid-by or after they finish their shopping.
Merchant’s UI contains the details of their shop. They need to add the number of customers to be allowed in their shop.
Merchants have a dedicated button where they can change the availability such as Open/Closed.
Merchants can view the number of customers waiting in their queue by pressing the Queue List Button. 
Thus, Queue Breaker can be used in any pandemic situations as well as in normal conditions which makes it as a User-Friendly application.
