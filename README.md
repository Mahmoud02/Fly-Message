# fly_message

A Fly Message is an app that enables you to share your messages with other users. You can register using your email to see other users' messages and easily send messages to all other users.

###  Technology used in this project:
* Flutter Framework 
* BLoC Pattern 
* Firebase
* Streams 
* RxDart
* Third Part libraries

### Arechitecture of the App
my main focus in this app to follow the concept of separation of concerns (SoC) and make each module responsible for one thing.
So, I used Block with Repository Pattern to architecture the app.

I used Streams in the app directly without using Third-Party libraries to gain experience in it.
when you see the app files, you will find that:
* 1-Screen/Widget
* 2-Blocks
* 3-Repository
* 4-Database

#### So let's talk first about Database Module
- this module will contain the classes that deal with the database directly.
- If you use Firebase as your back-end then you will create FirebaseClass that makes Firebase Operations.
- In the same app, you may want to deal with the SQLite database then you will create an SQLite class that makes SQLite operations.
- In the final database, classes will receive a request and process it then returns the result to the caller.

#### Repository
- in previous, you create the firebaseClass and sqliteClass, so who send the requests to them.
- the brief answer is:  the repositoryClass 
- repositoryClass receives requests and process them.
- Maybe there is a request that can be handled by firebaseClass another can be handled by sqliteClass. 

#### BLock
- blockClass receives requests from Screens then processes these requests.
- So how blockClass deal with requests?
- the block class maybe do its own logic to the data after finish its logic the next step is to call repositoryClass and give him the data and just wait for the result.
- *notice
    you should notice that the blockClass just call repositoryClass and doesn't know how it will get the data and we called this[ separation of concerns]
#### Screen/Widget
- the only concern is to display the widgets and format them.  

#### So in final let's brief that:
- when users go to home screens and the home screens should display other users' posts.
- the screen clas only know how to display widgets and make them look very good but it doesn't know how to get the data 
- so its call the blockClass and say that: hey I want posts data to combine it with my widgets and users can see them, so I will wait. 
- after that blockClass take the request then call repositoryClass then repositoryClass call the Database.

- Database returns the result to the repository then the repository sends the result to blockClass then blockClass will notify the screenClass about the result.
- then screenClass takes the result and render it.

### You may think that is too much code to do a simple thing, I agree with you, but in a large application Separation of concern will make your code so simple to understand and to refactor it. 

#### Images from th app
<img src="https://user-images.githubusercontent.com/18700494/104111236-4f39a400-52e8-11eb-9632-960e0498c6ed.png" width="400" height="600"/>
<img src="https://user-images.githubusercontent.com/18700494/104111235-4e087700-52e8-11eb-9077-a0073ae684f3.png" width="400" height="600"/>
<img src="https://user-images.githubusercontent.com/18700494/104111238-5bbdfc80-52e8-11eb-8a0d-306a06d393a7.png" width="400" height="600"/>
<img src="https://user-images.githubusercontent.com/18700494/104111242-65476480-52e8-11eb-82d1-b8b76e513542.png" width="400" height="600"/>
<img src="https://user-images.githubusercontent.com/18700494/104111245-77c19e00-52e8-11eb-97df-7f6292df0cad.png" width="400" height="600"/>



