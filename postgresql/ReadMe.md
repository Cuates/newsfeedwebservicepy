# PostgreSQL Function, Index, Stored Procedure, Table, and or View
> PostgreSQL database schema for this project

## Table of Contents
* [Important Note](#important-note)
* [Stored Procedure Usage](#stored-procedure-usage)
* [Function Usage](#function-usage)

### **Important Note**
* This project was written with PostgreSQL 13 methods

### Stored Procedure Usage
* `call insertupdatedeletenewsfeed ('deleteNewsFeed', 'titleValue', '', '', '', '')`
* `call insertupdatedeletenewsfeed ('insertNewsFeed', 'titleValue', 'imageUrlValue', 'feedUrlValue', actualUrlValue', 'publishDateValue')`
* `call insertupdatedeletenewsfeed ('updateNewsFeed', 'titleValue', 'imageUrlValue', 'feedUrlValue', actualUrlValue', 'publishDateValue')`

### Function Usage
* `select titlereturn as "Title", imageurlreturn as "Image URL", feedurlreturn as "Feed URL", actualurlreturn as "Acutal URL", publishdatereturn as "Publish Date" from extractnewsfeed ('extractNewsFeed', 'titleValue', 'imageUrlValue', 'feedUrlValue', actualUrlValue', 'limitValue', 'sortValue')`
