# newsfeedwebservicepy
> Python Webservice for News

## Table of Contents
* [Version](#version)
* [Important Note](#important-note)
* [Prerequisite Python Modules](#prerequisite-python-modules)
* [Gunicorn Manual Execution](#gunicorn-manual-execution)

### Version
* 0.0.1

### **Important Note**
* This script was written with Python 3 methods

### Prerequisite Python Modules
* List installed modules
  * `pip3.9 list`
* Module version
  * `pip3.9 show <modulename>`
* Module Outdated
  * `pip3.9 list --outdated`
* Module Upgrade
  * `pip3.9 install --upgrade <modulename>`
  * `pip3.9 install --upgrade <modulename> <modulename> <modulename>`
* MSSQL
  * `pip3.9 install pyodbc`
    * [PyODBC](https://pypi.org/project/pyodbc/)
* MySQL/MariaDB
  * `pip3.9 install mysqlclient`
    * [MySQL Client](https://pypi.org/project/mysqlclient/)
    * If "NameError: name '\_mysql' is not defined", then proceed with the following instead
      * `pip3.9 uninstall mysqlclient`
      * `pip3.9 install --no-binary mysqlclient mysqlclient`
        * Note: The first occurrence is the name of the package to apply the no-binary option to, the second specifies the package to install
* PostgreSQL
  * `pip3.9 install psycopg2-binary`
    * [Psycopg2 Binary](https://pypi.org/project/psycopg2/)
* flask
  * `pip3.9 install flask`
    * [Flask](https://pypi.org/project/Flask/)
* flask-restful
  * `pip3.9 install flask-restful`
    * [Flask Restful](https://pypi.org/project/Flask-RESTful/)
* Green Unicorn
  * `pip3.9 install gunicorn`
    * [Gunicorn](https://pypi.org/project/gunicorn/)
* Virtual Environment
  * `pip3.9 install virtualenv`
    * [Virtualenv](https://pypi.org/project/virtualenv/)
* pytz
  * `pip3.9 install pytz`
    * [PYTZ](https://pypi.org/project/pytz/)
* tzlocal
  * `pip3.9 install tzlocal`
    * [TZLocal](https://pypi.org/project/tzlocal/)
* sqlalchemy
  * `pip3.9 install sqlalchemy`
    * [SQLAlchemy](https://pypi.org/project/SQLAlchemy/)
* Install module in batch instead of Individual Installation
  * `pip3.9 install -r /path/to/requirements.txt`
* Upgrade module in batch instead of Individual Upgrades
  * `pip3.9 install --upgrade -r /path/to/requirements.txt`

### Gunicorn Manual Execution
* `/path/to/local/gunicorn --bind <ip_address>:<portnumber> --workers=2 --threads=25 --chdir /path/to/directory/newsfeedwebservice newsfeedwebservice:app`
