[![Build Status](https://travis-ci.org/ChickenFur/HumanImpact.png)](https://travis-ci.org/ChickenFur/HumanImpact)

Human Impact
================================

What is it:
-------------------------------
  Type in a person's name, hit enter and we pull in all the people who are related to this person according to wikipedia links.

  Click on one of those people and we display all the people who are connected to that person.

How to run it:
-------------------------------
  
  You will need to setup your own mongo db to cache the results.  We used http://mongohq.com. 

  After you have your db up and running be sure to add a user.

  On the computer running the serve set up the following environment variables.

  ```
  PORT
  mongoDBURL
  mongoPWD
  mongoUser
  ```

  Then download the source

  ```
  git clone git@github.com:ChickenFur/HumanImpact.git


  cd humanimpact
  ```

  Install the necessary packages and run it.

  ```
  npm install
  node js/appServer.js
  ```


See it running live:
-------------------------------

  http://HI.whitepinedev.com

Created By
-------------------------------
  Adnan Wahab, Megan Tulac and Christen Thompson

MIT LICENSE