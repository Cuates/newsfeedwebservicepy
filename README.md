# newsfeedwebservicepy
> Python Webservice for News

## Table of Contents
* [Version](#version)
* [Important Note](#important-note)
* [Prerequisite Python Modules](#prerequisite-python-modules)
* [Gunicorn Manual Execution](#gunicorn-manual-execution)
* [Python Script](#python-script)

### Version
* 0.0.1

### **Important Note**
* This script was written with Python 3 methods

### Prerequisite Python Modules
* List installed modules
  * `pip3.10 list`
* Module version
  * `pip3.10 show <modulename>`
* Module Outdated
  * `pip3.10 list --outdated`
* Module Upgrade
  * `pip3.10 install --upgrade <modulename>`
  * `pip3.10 install --upgrade <modulename> <modulename> <modulename>`
* MSSQL
  * `pip3.10 install pyodbc`
    * [PyODBC](https://pypi.org/project/pyodbc/)
* MySQL/MariaDB
  * `pip3.10 install mysqlclient`
    * [MySQL Client](https://pypi.org/project/mysqlclient/)
    * If "NameError: name '\_mysql' is not defined", then proceed with the following instead
      * `pip3.10 uninstall mysqlclient`
      * `pip3.10 install --no-binary mysqlclient mysqlclient`
        * Note: The first occurrence is the name of the package to apply the no-binary option to, the second specifies the package to install
* PostgreSQL
  * `pip3.10 install psycopg2-binary`
    * [Psycopg2 Binary](https://pypi.org/project/psycopg2/)
* flask
  * `pip3.10 install flask`
    * [Flask](https://pypi.org/project/Flask/)
* flask-restful
  * `pip3.10 install flask-restful`
    * [Flask Restful](https://pypi.org/project/Flask-RESTful/)
* flask-cors
  * `pip3.10 install flask-cors`
    * [Flask CORS](https://pypi.org/project/Flask-Cors/)
* Green Unicorn
  * `pip3.10 install gunicorn`
    * [Gunicorn](https://pypi.org/project/gunicorn/)
* Virtual Environment
  * `pip3.10 install virtualenv`
    * [Virtualenv](https://pypi.org/project/virtualenv/)
* pytz
  * `pip3.10 install pytz`
    * [PYTZ](https://pypi.org/project/pytz/)
* tzlocal
  * `pip3.10 install tzlocal`
    * [TZLocal](https://pypi.org/project/tzlocal/)
* sqlalchemy
  * `pip3.10 install sqlalchemy`
    * [SQLAlchemy](https://pypi.org/project/SQLAlchemy/)
* Install module in batch instead of Individual Installation
  * `pip3.10 install -r /path/to/requirements.txt`
* Upgrade module in batch instead of Individual Upgrades
  * `pip3.10 install --upgrade -r /path/to/requirements.txt`

### Gunicorn Manual Execution
* `/path/to/local/gunicorn --bind <ip_address>:<portnumber> --workers=2 --threads=25 --chdir /path/to/directory/newsfeedwebservice newsfeedwebservice:app`

### Python Script
* Python project within an environment
  * Create a directory where the project will live
    * `sudo mkdir /path/to/project`
  * Make sure you are a directory above the project you just created
    * Create virtual environment
      * `cd /path/above/project/created`
      * `python3.10 -m venv /path/to/project`
  * Activate environment
    * `cd /path/to/project`
    * `source bin/activate`
  * Install all modules you will need for the project; This can be done individually or in a batch
    * `pip3.10 install -r /path/to/requirements.txt`
  * Deactivate virtual environment
    * `deactivate`
  * Code whatever project you are trying to accomplish
 * Login to the server as root user
   * Create a file name "newsfeedwebservice.service" in the following directory '/etc/systemd/system/'
     * The path to your project will vary
     * Paste the following into the file
       * <pre>
           [Unit]
           Description=news feed web service service
           After=network.target

           [Service]
           User=root
           Group=root
           WorkingDirectory=/path/to/your/project
           ExecStart=/usr/local/bin/gunicorn --bind 127.0.0.1:4817 --workers=2 --threads=25 --chdir /path/to/your/project newsfeedwebservice:app

           [Install]
           WantedBy=multi-user.target
         </pre>
     * Save and Exit
   * Now you can start the script manually and check if the python API calls are working
     * `sudo systemctl start moviefeedwebservice.service`
   * Check the status of the script to make sure there are no issue when started
     * `sudo systemctl status moviefeedwebservice.service`
   * Enable at startup if everything is in good working order
     * `sudo systemctl enable moviefeedwebservice.service`
* To test the script point the python to the environment python you created
  * `/path/to/your/project/bin/python3.10 /path/to/your/python_script.py`
