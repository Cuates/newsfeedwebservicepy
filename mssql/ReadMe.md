# MSSQL Function, Index, Stored Procedure, Table, and or View
> MSSQL database schema for this project

## Table of Contents
* [Important Note](#important-note)
* [Dependent MSSQL Function](#dependent-mssql-function)
* [Stored Procedure Usage](#stored-procedure-usage)

### **Important Note**
* This project was written with SQL Server 2019 methods

### Dependent MSSQL Function
* [Omit Characters](https://github.com/Cuates/omitcharactersmssql)

### Stored Procedure Usage
* `exec dbo.extractNewsFeed @optionMode = 'extractNewsFeed', @title = 'titleValue', @imageurl = 'imageUrlValue', @feedurl = 'feedUrlValue', @actualurl = 'actualUrlValue', @limit = '25', @sort = 'desc'`
* `exec dbo.insertupdatedeleteNewsFeed @optionMode = 'deleteNewsFeed', @title = 'titleValue'`
* `exec dbo.insertupdatedeleteNewsFeed @optionMode = 'insertNewsFeed', @title = 'titleValue', @imageurl = 'imageUrlValue', @feedurl = 'feedUrlValue', @actualurl = 'actualUrlValue', @publishdate = 'publishDateValue'`
* `exec dbo.insertupdatedeleteNewsFeed @optionMode = 'updateNewsFeed', @title = 'titleValue', @imageurl = 'imageUrlValue', @feedurl = 'feedUrlValue', @actualurl = 'actualUrlValue', @publishdate = 'publishDateValue'`
