##
#        File: newsfeedwebserviceconfig.py
#     Created: 11/10/2020
#     Updated: 11/18/2020
#  Programmer: Cuates
#  Updated By: Cuates
#     Purpose: News feed web service configuration
##

# Import modules
import re as regEx # regular expression

# Class
class NewsFeedWebServiceConfig:
  # Declare protected variables
  _filenameIgnore = None
  _filenameDelete = None
  _pathParent = None
  _pathLevelOne = None
  _pathLevelTwo = None
  _filenameMedia = None
  _driver = None
  _databasedialect = None
  _serverName = None
  _port = None
  _database = None
  _username = None
  _password = None
  _jsonConfigLogFilename = None
  _jsonErrorLogFilename = None
  _csvErrorLogFilename = None
  _logDebugFilename = None
  _logInfoFilename = None
  _logErrorFilename = None

  # Constructor
  def __init__(self):
    pass

  # Set database variable
  def _setConfigVars(self, type):
    # Define server information
    ServerInfo = 'DEV-SERVER'

    # Define list of dev words
    ServerType = ['dev']

    # Set production database information where server info does not consist of server type
    if not regEx.search(r'\b' + "|".join(ServerType) + r'\b', ServerInfo, flags=regEx.IGNORECASE):
      # Check if type is MariaDB
      if type == 'MariaDBSQLNews':
        # Set variables
        self._driver = 'MariaDB'
        self._databasedialect = 'mysql://'
        self._servername = ''
        self._port = ''
        self._database = ''
        self._username = ''
        self._password = ''
      # Else check if type is PGSQL
      elif type == 'PGSQLNews':
        # Set variables
        self._driver = 'PostgreSQL'
        self._databasedialect = 'postgresql://'
        self._servername = ''
        self._port = ''
        self._database = ''
        self._username = ''
        self._password = ''
      # Else check if type is MSSQL Linux
      elif type == 'MSSQLLNews':
        # Set variables
        self._driver = 'ODBC Driver 17 for SQL Server'
        self._databasedialect = 'mssql+pyodbc:///'
        self._servername = ''
        self._port = ''
        self._database = ''
        self._username = ''
        self._password = ''
      # Else check if type is MSSQL Windows
      elif type == 'MSSQLWNews':
        # Set variables
        self._driver = 'ODBC Driver 17 for SQL Server'
        self._databasedialect = 'mssql+pyodbc:///'
        self._servername = ''
        self._port = ''
        self._database = ''
        self._username = ''
        self._password = ''
      # Else
      else:
        self._driver = ''
        self._databasedialect = ''
        self._servername = ''
        self._port = ''
        self._database = ''
        self._username = ''
        self._password = ''
    else:
      # Else set development database information
      # Check if type is MariaDB
      if type == 'MariaDBSQLNews':
        # Set variables
        self._driver = 'MariaDB'
        self._databasedialect = 'mysql://'
        self._servername = ''
        self._port = ''
        self._database = ''
        self._username = ''
        self._password = ''
      # Else check if type is PGSQL
      elif type == 'PGSQLNews':
        # Set variables
        self._driver = 'PostgreSQL'
        self._databasedialect = 'postgresql://'
        self._servername = ''
        self._port = ''
        self._database = ''
        self._username = ''
        self._password = ''
      # Else check if type is MSSQL Linux
      elif type == 'MSSQLLNews':
        # Set variables
        self._driver = 'ODBC Driver 17 for SQL Server'
        self._databasedialect = 'mssql+pyodbc:///'
        self._servername = ''
        self._port = ''
        self._database = ''
        self._username = ''
        self._password = ''
      # Else check if type is MSSQL Windows
      elif type == 'MSSQLWNews':
        # Set variables
        self._driver = 'ODBC Driver 17 for SQL Server'
        self._databasedialect = 'mssql+pyodbc:///'
        self._servername = ''
        self._port = ''
        self._database = ''
        self._username = ''
        self._password = ''
      # Else
      else:
        self._driver = ''
        self._databasedialect = ''
        self._servername = ''
        self._port = ''
        self._database = ''
        self._username = ''
        self._password = ''

  # Get database variable
  def _getConfigVars(self):
    return {'Driver': self._driver, 'DatabaseDialect': self._databasedialect, 'Servername': self._servername, 'Port': self._port, 'Database': self._database, 'Username': self._username, 'Password': self._password}

  # Set filename variable
  def _setFilenameVars(self, feedAction):
    # Check if media action type is log
    if regEx.search(r'\bLog\b', feedAction, flags=regEx.IGNORECASE):
      self._pathParent = '/path/to/newsfeedwebservice'
      self._pathLevelOne = '/resource'
      self._pathLevelTwo = '/log'
      self._jsonConfigLogFilename = '/logging_dictConfig.json'
      self._filenameMedia = '/newsfeedwebservicepy.log'
      self._logDebugFilename = '/debug.log'
      self._logInfoFilename = '/info.log'
      self._logErrorFilename = '/errors.log'
      self._jsonErrorLogFilename = '/errors_log.json'
      self._csvErrorLogFilename = '/errors_log.csv'
    else:
      self._pathParent = ''
      self._pathLevelOne = ''
      self._pathLevelTwo = ''
      self._jsonConfigLogFilename = ''
      self._filenameMedia = ''
      self._logDebugFilename = ''
      self._logInfoFilename = ''
      self._logErrorFilename = ''
      self._jsonErrorLogFilename = ''
      self._csvErrorLogFilename = ''

  # Get filename variable
  def _getFilenameVars(self):
    return {'pathParent': self._pathParent, 'pathLevelOne': self._pathLevelOne, 'pathLevelTwo': self._pathLevelTwo, 'JSONConfigLogFilename': self._jsonConfigLogFilename, 'filenameMedia': self._filenameMedia, 'LogDebugFilename': self._logDebugFilename, 'LogInfoFilename': self._logInfoFilename, 'LogErrorFilename': self._logErrorFilename, 'JSONErrorLogFilename': self._jsonErrorLogFilename, 'CSVErrorLogFilename': self._csvErrorLogFilename}