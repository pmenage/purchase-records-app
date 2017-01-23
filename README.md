# Purchase records app

This mobile app was made to help roommates check their purchase records.

## Installation

This app needs Node.js, npm, and MySQL installed.

Change the password in server.js to connect to the database. To launch the app, write the following commands:

    sudo service mysql start
    node server.js
    
## Tests    

You can also check out the database requests in sql/requetes_mysql_test directly in MySQL. Once in MySQL, connect to the database by typing the command:

    use COLOC;
    
##  Notes

Due to the academic nature of the project, all the database requests are in separate files instead of being inline and reloaded for each request. This is not meant to be a production-ready app.