##
#        File: newsfeedwebserviceclass.py
#     Created: 11/10/2020
#     Updated: 11/16/2020
#  Programmer: Cuates
#  Updated By: Cuates
#     Purpose: News feed web service class
#     Version: 0.0.1 Python3
##

# Import modules
import newsfeedwebserviceconfig # news feed web service configuration
import logging # logging
import logging.config # logging configuration
import json # json
import re as regEx # regular expression
import datetime # datetime
import pytz # pytz
import tzlocal # tz local
import sqlalchemy # sqlalchemy
import urllib # urllib
import pathlib # pathlib
import csv # csv
import os # os
import traceback # traceback

# Class
class NewsFeedWebServiceClass():
  # Constructor
  def __init__(self):
    pass

  # Extract news feed
  def _extractNewsFeed(self, type, actionWord, selectColumn, procedure, optionMode, possibleParams, feedStorage):
    # Initialize list and dictionary
    returnMessage = []

    # Try to execute the command(s)
    try:
      # Open connection
      connectionStatus = self.__openConnection(type)

      # Check if element does not exists
      if connectionStatus.get('SError') == None and 'SError' not in connectionStatus:
        # Initialize list and variable
        query = ''
        messageResponse = ''

        # Loop through list elements
        for feedStorageElement in feedStorage:
          # Execute rearrange
          rearrangeStatus = self._rearrangeParameterValue(possibleParams, feedStorageElement)

          # Loop through rearrangeStatus
          for rearrangeEntry in rearrangeStatus:
            # Check if parameter does not exist
            if rearrangeEntry.get('SError') == None:
              # Execute build query
              buildQueryStatus = self._buildQueryStatement(rearrangeStatus, type, possibleParams)

              # Initialize list
              bindParamHeader = []

              # Loop through possible parameters
              for possParamEntry in possibleParams:
                # Bind parameters based on possible parameter entry
                bindParamHeader.append(sqlalchemy.bindparam(possParamEntry))

              # Loop through build query status
              for buildQueryEntry in buildQueryStatus:
                # Check if parameter does not exist
                if buildQueryEntry.get('SError') == None:
                  # MariaDB query statement
                  if regEx.match(r'MariaDBSQL[a-zA-Z]{0,}', type, flags=regEx.IGNORECASE):
                    # Convert statement to text
                    query = sqlalchemy.text('call ' + procedure + ' (\'' + optionMode + '\'' + buildQueryEntry['Query'] + ');', bindparams=bindParamHeader)
                  # PostgreSQL query statement
                  elif regEx.match(r'PGSQL[a-zA-Z]{0,}', type, flags=regEx.IGNORECASE):
                    # Check if variable is an empty string
                    if selectColumn.strip() == '':
                      # Set variable
                      selectColumn = 'select titlereturn as "Title"'

                    # Convert statement to text
                    query = sqlalchemy.text(selectColumn + ' from ' + procedure + ' (\'' + optionMode + '\'' + buildQueryEntry['Query'] + ');', bindparams=bindParamHeader)
                  # MSSQL query statement
                  elif regEx.match(r'MSSQL[a-zA-Z]{0,}', type, flags=regEx.IGNORECASE):
                    # Convert statement to text
                    query = sqlalchemy.text('exec ' + procedure + ' @optionMode = \'' + optionMode + '\'' + buildQueryEntry['Query'], bindparams=bindParamHeader)

                  # Check if query is empty
                  if query != '':
                    # Execute many queries
                    messageResponse = self.connection.execute(query, rearrangeStatus)

                    # Fetch a record
                    fetchRecord = messageResponse.fetchall()

                    # Check if data was retrieved
                    if len(fetchRecord):
                      # Store column headers
                      columnHeader = messageResponse.keys()

                      # Loop through database response
                      for entry in fetchRecord:
                        # Append column headers with records
                        returnMessage.append(dict(zip(columnHeader, entry)))
                  else:
                    # Set message
                    returnMessage = [{'SError': 'Error', 'SMessage': 'Query not defined'}]
                else:
                  # Set message
                  returnMessage = [{'SError': 'Error', 'SMessage': buildQueryEntry['SMessage']}]

                  # Break from loop
                  break
            else:
              # Set message
              returnMessage = [{'SError': 'Error', 'SMessage': rearrangeEntry['SMessage']}]

              # Break from loop
              break

        # Check if execution has executed
        if (messageResponse):
          # Close execution
          messageResponse.close()

        ## Check if connection was established
        #if (self.connection):
          ## Close database connection
          #self.connection.close()
      else:
        # Set message
        returnMessage = [{'SError': 'Error', 'SMessage': connectionStatus['SError']}]

    # Catch exceptions
    except Exception as e:
      # Set message
      returnMessage = [{'SError': 'Error', 'SMessage': 'Caught ' + actionWord + ' news feed execution failure'}]

      # Log message
      self._setLogger('Issue ' + actionWord + ' news feed : ' + str(e))
    # Finally closing connection
    finally:
      # Check if connection is not None
      if self.connection is not None:
        # Close database connnection
        self.connection.close()
        # Will close all connections of the connection pool.
        self.engine.dispose()
        #print('Database connection close.')

    # Return message
    return returnMessage

  # Insert, Update, or Delete news feed
  def _insertupdatedeleteNewsFeed(self, type, actionWord, procedure, optionMode, possibleParams, feedStorage, removeParams):
    # Initialize list/dictionary
    returnMessage = []

    # Try to execute the command(s)
    try:
      # Open connection
      connectionStatus = self.__openConnection(type)

      # Check if element does not exists
      if connectionStatus.get('SError') == None and 'SError' not in connectionStatus:
        # Initialize list, dictionary, and variables
        query = ''
        messageResponse = ''

        # Loop through list elements
        for feedStorageElement in feedStorage:
          # Execute rearrange
          rearrangeStatus = self._rearrangeParameterValue(possibleParams, feedStorageElement)

          # Loop through rearrangeStatus
          for rearrangeEntry in rearrangeStatus:
            # Check if parameter does not exist
            if rearrangeEntry.get('SError') == None:
              # Execute build query
              buildQueryStatus = self._buildQueryStatement(rearrangeStatus, type, possibleParams)

              # Initialize list
              bindParamHeader = []

              # Loop through possible parameters
              for possParamEntry in possibleParams:
                # Bind parameters based on possible parameter entry
                bindParamHeader.append(sqlalchemy.bindparam(possParamEntry))

              # Loop through build query status
              for buildQueryEntry in buildQueryStatus:
                # Check if parameter does not exist
                if buildQueryEntry.get('SError') == None:
                  # MariaDB query statement
                  if regEx.match(r'MariaDBSQL[a-zA-Z]{0,}', type, flags=regEx.IGNORECASE):
                    # Convert statement to text
                    query = sqlalchemy.text('call ' + procedure + ' (\'' + optionMode +  '\'' + buildQueryEntry['Query'] + ');', bindparams=bindParamHeader)
                  # PostgreSQL query statement
                  elif regEx.match(r'PGSQL[a-zA-Z]{0,}', type, flags=regEx.IGNORECASE):
                    # Convert statement to text
                    query = sqlalchemy.text('call ' + procedure + ' (\'' + optionMode +  '\'' + buildQueryEntry['Query'] + ');', bindparams=bindParamHeader)
                  # MSSQL query statement
                  elif regEx.match(r'MSSQL[a-zA-Z]{0,}', type, flags=regEx.IGNORECASE):
                    # Convert statement to text
                    query = sqlalchemy.text('exec ' + procedure + ' @optionMode = \'' + optionMode +  '\'' + buildQueryEntry['Query'], bindparams=bindParamHeader)

                  # Check if query is empty
                  if query != '':
                    # Execute many queries
                    messageResponse = self.connection.execute(query, rearrangeStatus)

                    # Fetch a record
                    fetchRecord = messageResponse.fetchall()

                    # Check if data was retrieved
                    if len(fetchRecord):
                      # Loop through response
                      for entry in fetchRecord:
                        # Initialize dictionary
                        newDictionary = {}

                        # Merge empty and rearranged dictionaries
                        newDictionary.update(rearrangeEntry)

                        # Merge rearranged and response dictionaries
                        newDictionary.update(json.loads(entry['status']))

                        # Append to list
                        returnMessage.append(newDictionary)

                      # Check if list is not empty
                      if returnMessage:
                        # Check if list is not empty
                        if removeParams:
                          # Loop through sub elements
                          for subEntries in returnMessage:
                            # Loop through possible remove params
                            for popEntry in removeParams:
                              # Check if key exists
                              if subEntries.get(popEntry) != None:
                                # Remove item by key name
                                del subEntries[popEntry]
                  else:
                    # Set message
                    returnMessage = [{'SError': 'Error', 'SMessage': 'Query statement not defined'}]
                else:
                  # Set message
                  returnMessage = [{'SError': 'Error', 'SMessage': buildQueryEntry['SMessage']}]

                  # Break from loop
                  break
            else:
              # Set message
              returnMessage = [{'SError': 'Error', 'SMessage': rearrangeEntry['SMessage']}]

              # Break from loop
              break

        # Check if execution has executed
        if (messageResponse):
          # Close execution
          messageResponse.close()

        ## Check if connection was established
        #if (self.connection):
          ## Close database connection
          #self.connection.close()
      else:
        # Set message
        returnMessage = [{'SError': 'Error', 'SMessage': connectionStatus['SError']}]
    # Catch exceptions
    except Exception as e:
      # Set message
      returnMessage = [{'SError': 'Error', 'SMessage': 'Caught ' + actionWord + ' news feed execution failure'}]

      # Log message
      self._setLogger('Issue ' + actionWord + ' news feed : ' + str(e))
    # Finally closing connection
    finally:
      # Check if connection is not None
      if self.connection is not None:
        # Close database connnection
        self.connection.close()
        # Will close all connections of the connection pool.
        self.engine.dispose()
        #print('Database connection close.')

    # Return message
    return returnMessage

  # ** IMPORTANT NOTE Do not modify below this line **
  # Check headers
  def _checkHeaders(self, wsHead):
    # Initialize dictionary
    returnDict = {}
    AcceptVal = None
    contenttypeVal = None
    charsetVal = None

    # try to execute the command(s)
    try:
      # Check if Accept is not none
      if wsHead.get('Accept') != None:
        # Store accept in lower case
        AcceptVal = wsHead['Accept'].lower()

      # Check if Content Type is not none
      if wsHead.get('Content-Type') != None:
        # Store content type in lower case
        contenttypeVal = wsHead['Content-Type'].lower()

      # Check if Accept Charset is not none
      if wsHead.get('Accept-Charset') != None:
        # Store charset in lower case
        charsetVal = wsHead['Accept-Charset'].lower()

      # Check if HTTP Accept is provided
      if AcceptVal == 'application/json':
        # Check if HTTP Accept Content Type is provided
        if contenttypeVal == 'application/json':
          # Check if HTTP Accept Charset is provided
          if charsetVal == 'utf-8':
            # Store Message
            returnDict = {'Status': 'Success', 'Message': 'Headers are valid'}
          else:
            # Store Message
            returnDict = {'Status': 'Error', 'Message': 'Charset invalid'}
        else:
          # Store Message
          returnDict = {'Status': 'Error', 'Message': 'Content type invalid'}
      else:
        # Store Message
        returnDict = {'Status': 'Error', 'Message': 'HTTP accept invalid'}
    # Catch exceptions
    except Exception as e:
      # Store Message
      returnDict = {'Status': 'Error', 'Message': 'Check headers'}

      # Log message
      self._setLogger('Check headers ' + str(e))

    # Return dictionary
    return returnDict

  # Check payload
  def _checkPayload(self, requestMethod, payload, mandatoryParams):
    # Initialize list and dictionary
    returnDict = {}
    payloadNew = []

    # try to execute the command(s)
    try:
      # Check if request method is GET
      if requestMethod.lower() == 'get':
        # Set list with dictionary values and lower key strings
        payloadSubElement = dict((k.lower(), v) for k, v in payload.items())

        # Set list with dictionary
        payloadNew.append(payloadSubElement)

        # Set list dictionary
        returnDict = {"Status": "Success", "Message": "Valid payload", "Result": payloadNew}

      # Else check if request method is POST, PUT, DELETE
      elif requestMethod.lower() == 'post' or requestMethod.lower() == 'put' or requestMethod.lower() == 'delete':
        # try to execute the command(s)
        try:
          # Check raw data
          if payload:
            # Store input values
            payloadNew = json.loads(payload)
          else:
            # Set to none
            payloadNew = None

          # Check if payload is a list
          if isinstance(payloadNew, list):
            # Check if list is not empty
            if payloadNew:
              # Loop through the list
              for dataInput in payloadNew:
                # Check if the length of each sub element is less than or equal to zero
                if len(dataInput) <= 0:
                  # Set to none
                  payloadNew = None

                  # Break the loop
                  break

              # Check if payload exists
              if payloadNew != None:
                # Initialize list
                payloadStorage = []

                # Loop through all elements
                for payloadEntries in payloadNew:
                  # Initialize list
                  payloadSubElement = {}

                  # Lower case key string
                  payloadSubElement = dict((k.lower(), v) for k, v in payloadEntries.items())

                  # Check if mandatory parameters exists
                  if all(key in payloadSubElement for key in mandatoryParams):
                    # Append payload sub element
                    payloadStorage.append(payloadSubElement)
                  else:
                    # Set empty list
                    payloadStorage = []

                    # Break the loop
                    break

                # Check if list has elements
                if payloadStorage:
                  # Store Message
                  returnDict = {"Status": "Success", "Message": "Valid payload", "Result": payloadStorage}
                else:
                  # Store Message
                  returnDict = {"Status": "Error", "Message": "Process halted, mandatory parameters were not provided", "Result": []}
              else:
                # Store Message
                returnDict = {'Status': 'Error', 'Message': 'Process halted, payload elements missing sub elements', 'Result': []}
            else:
              # Store Message
              returnDict = {'Status': 'Error', 'Message': 'Process halted, payload elements missing', 'Result': []}
          else:
            # Store Message
            returnDict = {'Status': 'Error', 'Message': 'Process halted, invalid payload format', 'Result': []}
        except ValueError as ve:
          # Store Message
          returnDict = {'Status': 'Error', 'Message': 'Process halted, invalid payload', 'Result': []}

          # Log message
          self._setLogger('Invalid JSON payload ' + str(ve))
      else:
        # Store Message
        returnDict = {'Status': 'Error', 'Message': 'Process halted, method not supported', 'Result': []}
    except Exception as e:
      # Store Message
      returnDict = {'Status': 'Error', 'Message': 'Process halted, payload check issue', 'Result': []}

      # Log message
      self._setLogger('Issue with payload check ' + str(e))

    # Return message
    return returnDict

  # Rearrange parameter and values
  def _rearrangeParameterValue(self, possibleParams, feedStorage):
    # Initialize dictionary
    entryNew = {}
    feedStorageNew = []

    # Try to execute the command(s)
    try:
      # Loop through each possible parameter
      for paramEntry in possibleParams:
        # Check if parameter does not exist
        if feedStorage.get(paramEntry) == None:
          # Append parameter
          entryNew[paramEntry] = ''
        else:
          # Append parameter
          entryNew[paramEntry] = feedStorage.get(paramEntry)

      # Append dictionary to list
      feedStorageNew.append(entryNew)
    # Catch exceptions
    except Exception as e:
      # Set message
      feedStorageNew = [{'SError': 'Error', 'SMessage': 'Caught rearrange parameter value failure'}]

      # Log message
      self._setLogger('Rearrange parameter value : ' + str(e))

    # Return message
    return feedStorageNew

  # Build query statement
  def _buildQueryStatement(self, feedStorage, type, possibleParams):
    # Initialize variable
    paramQuery = ''
    returnQuery = []

    # Try to execute the command(s)
    try:
      # Loop through each entry
      for entry in feedStorage:
        # Loop through input items
        for k, v in entry.items():
          # MariaDB query statement
          if regEx.match(r'MariaDBSQL[a-zA-Z]{0,}', type, flags=regEx.IGNORECASE):
            # Check if parameter is in possible parameters
            if k in possibleParams:
              # Set parameter query
              paramQuery += ', :' + k
          # PostgreSQL query statement
          elif regEx.match(r'PGSQL[a-zA-Z]{0,}', type, flags=regEx.IGNORECASE):
            # Check if parameter is in possible parameters
            if k in possibleParams:
              # Set parameter query
              paramQuery += ', :' + k
          # MSSQL query statement
          elif regEx.match(r'MSSQL[a-zA-Z]{0,}', type, flags=regEx.IGNORECASE):
            # Check if parameter is in possible parameters
            if k in possibleParams:
              # Set parameter query
              paramQuery += ', @' + k + ' = :' + k

        ## Break from loop
        #break

      # Store message
      returnQuery = [{'Query': paramQuery}]
    # Catch exceptions
    except Exception as e:
      # Store message
      returnQuery = [{'SError': 'Error', 'SMessage': 'Caught build query statement failure'}]

      # Log message
      self._setLogger('Build query statement : ' + str(e))

    # Return message
    return returnQuery

  # Open connection based on type
  def __openConnection(self, type = 'notype'):
    # Create empty dictionary
    returnDict = {}

    # Try to execute the command(s)
    try:
      # Create object of configuration script
      nfwsconfig = newsfeedwebserviceconfig.NewsFeedWebServiceConfig()

      # Set variables based on type
      nfwsconfig._setConfigVars(type)

      # Create empty dictionary
      conVars = {}

      # Get dictionary of values
      conVars = nfwsconfig._getConfigVars()

      # Set credentials from dictionary
      self.Driver = conVars['Driver']
      self.DatabaseDialect = conVars['DatabaseDialect']
      self.Server = conVars['Servername']
      self.Port = conVars['Port']
      self.Database = conVars['Database']
      self.User = conVars['Username']
      self.Pass = conVars['Password']

      # Set connection to no connection
      self.connection = None

      # Check if database type is MySQL or the alternative MariaDB
      if regEx.match(r'MariaDBSQL[a-zA-Z]{0,}', type, flags=regEx.IGNORECASE):
        # # Set variable with string
        # print('mysql:host=' + self.Server + ';port=' + self.Port + ';dbname=' + self.Database, self.User, self.Pass)

        # Set engine
        # dialect+driver://username:password@host:port/database
        self.engine = sqlalchemy.create_engine(self.DatabaseDialect + self.User + ':' + self.Pass + '@' + self.Server + ':' + self.Port + '/' + self.Database + '?charset=utf8mb4&autocommit=true')
        # self.engine = sqlalchemy.create_engine(self.DatabaseDialect + self.User + ':' + self.Pass + '@' + self.Server + ':' + self.Port + '/' + self.Database + '?charset=utf8mb4&autocommit=true', echo=True) # for debugging purposes only

        # Connect to engine
        self.connection = self.engine.connect()

        # Set meta data based on engine
        metadata = sqlalchemy.MetaData(self.engine)

        # # Debugging purposes only
        # print ('Driver: ' + self.Driver + ' DatabaseDialect: ' + self.DatabaseDialect + ' ServerName: ' + self.Server + ' Connection successful<br /><br />')

        # # Check if connection was established
        # if (self.connection):
          # # Close database connection
          # self.connection.close()

      # Else check if database type is PGSQL
      elif regEx.match(r'PGSQL[a-zA-Z]{0,}', type, flags=regEx.IGNORECASE):
        # # Check else if database type is PostgreSQL
        # print('pgsql:host=' + self.Server + '; port=' + self.Port + '; dbname=' + self.Database + '; user=' + self.User + '; password=' + self.Pass + ';')

        # Set engine
        # dialect+driver://username:password@host:port/database
        self.engine = sqlalchemy.create_engine(self.DatabaseDialect + self.User + ':' + self.Pass + '@' + self.Server + ':' + self.Port + '/' + self.Database).execution_options(autocommit=True)
        # self.engine = sqlalchemy.create_engine(self.DatabaseDialect + self.User + ':' + self.Pass + '@' + self.Server + ':' + self.Port + '/' + self.Database, echo=True).execution_options(autocommit=True) # for debugging purposes only

        # Connect to engine
        self.connection = self.engine.connect()

        # Set meta data based on engine
        metadata = sqlalchemy.MetaData(self.engine)

        # # Debugging purposes only
        # print ('Driver: ' + self.Driver + ' DatabaseDialect: ' + self.DatabaseDialect + ' ServerName: ' + self.Server + ' Connection successful<br /><br />')

        # # Check if connection was established
        # if (self.connection):
          # # Close database connection
          # self.connection.close()

      # Else check if database type is MSSQL
      elif regEx.match(r'MSSQL[a-zA-Z]{0,}', type, flags=regEx.IGNORECASE):
        # # Check if database type is Microsoft
        # print('odbc:Driver=' + self.Driver + '; Servername=' + self.Server + '; Port=' + self.Port + '; Database=' + self.Database + '; UID=' + self.User + '; PWD=' + self.Pass + ';')

        # Set engine
        # dialect+driver://username:password@host:port/database
        params = urllib.parse.quote_plus('DRIVER={' + self.Driver + '};SERVER=' + self.Server + ';DATABASE=' + self.Database + ';UID=' + self.User + ';PWD=' + self.Pass + ';TDS_Version=8.0;Port=' + self.Port + ';')

        self.engine = sqlalchemy.create_engine(self.DatabaseDialect+ '?odbc_connect={}&autocommit=true'.format(params))
        # self.engine = sqlalchemy.create_engine(self.DatabaseDialect + '?odbc_connect={}&autocommit=true'.format(params), echo=True) # for debugging purposes only

        # Connect to engine
        self.connection = self.engine.connect()

        # Set meta data based on engine
        metadata = sqlalchemy.MetaData(self.engine)

        # # Debugging purposes only
        # print ('Driver: ' + self.Driver + ' DatabaseDialect: ' + self.DatabaseDialect + ' ServerName: ' + self.Server + ' Connection successful<br /><br />')
      else:
        # Set server error
        returnDict ['SError'] = 'Cannot connect to the database'
    # Catch exceptions
    except Exception as e:
      # Set exception error
      returnDict['SError'] = 'Cannot connect to the database - ' + str(e)

      # Log message
      self._setLogger('Cannot connect to the database - ' + str(e))

    # Return message
    return returnDict

  # Write data to CSV file
  def _writeToCSVFile(self, pathAndFileName, headData, dictData):
    # Initialize variable
    returnMessage = []

    # Try to execute the command(s)
    try:
      # Write to CSV file using a context manager
      with open(pathAndFileName, 'w', newline = '', encoding = 'utf8') as csvExportFile:
        # Write set up the dictionary writer parameters
        writer = csv.DictWriter(csvExportFile, fieldnames = headData, quoting = csv.QUOTE_ALL)

        # Write header information
        writer.writeheader()

        # Write the rows from the dictionary
        writer.writerows(dictData)

      # Read and write to CSV file using a context manager
      with open(pathAndFileName, 'r+', newline = '', encoding = 'utf8') as csvExportFile:
        # Get the status of a file descriptor
        stat = os.fstat(csvExportFile.fileno())

        # Truncate the \r\n from the end of the file
        truncateResponse = csvExportFile.truncate(stat.st_size - 2)

      # System calls on path objects to instantiate concrete paths
      filenamePath = pathlib.Path(pathAndFileName)

      # Check if file exists and if file is a file
      if filenamePath.exists() and filenamePath.is_file():
        returnMessage = [{'Status': 'Success', 'Message': 'CSV file exist'}]
      else:
        # Else issue with file
        returnMessage = [{'SError': 'Error', 'SMessage': 'CSV file does not exist'}]
    # Set error message
    except Exception as e:
      # Set exception error
      returnMessage = [{'SError': 'Error', 'SMessage': 'Caught write to CSV file failure'}]

      # Log string
      self._setLogger('Write to CSV file - ' + str(e))

    # Return message
    return returnMessage

  # Write data to JSON file
  def _writeToJSONFile(self, pathAndFileName, dictData):
    # Initialize variable
    returnMessage = []

    # Try to execute the command(s)
    try:
      # Write to JSON file
      with open(pathAndFileName, 'w', newline = '', encoding = 'utf8') as jsonExportFile:
        # Write JSON to a file
        # Keep Unicode characters untouched
        # Make JSON human readable "pretty printing"
        json.dump(dictData, jsonExportFile, ensure_ascii = False, indent = 2)

      # System calls on path objects to instantiate concrete paths
      filenamePath = pathlib.Path(pathAndFileName)

      # Check if file exists and if file is a file
      if filenamePath.exists() and filenamePath.is_file():
        returnMessage = [{'Status': 'Success', 'Message': 'JSON file exist'}]
      else:
        # Else issue with file
        returnMessage = [{'SError': 'Error', 'SMessage': 'JSON file does not exist'}]
    # Set error message
    except Exception as e:
      # Set exception error
      returnMessage = [{'SError': 'Error', 'SMessage': 'Caught write to JSON file failure'}]

      # Log string
      self._setLogger('Write to JSON file - ' + str(e))

    # Return message
    return returnMessage

  # Write data to file
  def _writeToFile(self, pathAndFileName, stringData):
    # Initialize variable
    returnMessage = []

    # Try to execute the command(s)
    try:
      # Write to file
      with open(pathAndFileName, 'w', newline = '', encoding = 'utf8') as exportFile:
        # Write to a file
        exportFile.write(stringData)

      # System calls on path objects to instantiate concrete paths
      filenamePath = pathlib.Path(pathAndFileName)

      # Check if file exists and if file is a file
      if filenamePath.exists() and filenamePath.is_file():
        returnMessage = [{'Status': 'Success', 'Message': 'File exist'}]
      else:
        # Else issue with file
        returnMessage = [{'SError': 'Error', 'SMessage': 'File does not exist'}]
    # Set error message
    except Exception as e:
      # Set exception error
      returnMessage = [{'SError': 'Error', 'SMessage': 'Caught write to file failure'}]

      # Log string
      self._setLogger('Write to file - ' + str(e))
      # print(str(e))

    # Return message
    return returnMessage

  # Set logging dictionary configuration
  def _setLogDictConfig(self):
    # Set dictionary
    returnDict = {}

    # Set variable
    feedType = 'news'

    # create object of news feed parser config
    nfwsconfig = newsfeedwebserviceconfig.NewsFeedWebServiceConfig()

    # Set variables based on type
    nfwsconfig._setFilenameVars('Log')

    # Get dictionary of values
    dictFeedType = nfwsconfig._getFilenameVars()

    # Set path
    pathDirectory = dictFeedType['pathParent'] + dictFeedType['pathLevelOne'] + dictFeedType['pathLevelTwo']

    # Set dictionary
    returnDict['file_name'] = 'logging_dictConfig.json'
    returnDict['created'] = '11/02/2020'
    returnDict['updated'] = '11/14/2020'
    returnDict['programmer'] = 'Cuates'
    returnDict['updated_by'] = 'Cuates'
    returnDict['purpose'] = 'Logging settings and locations to save and display logging messages'
    returnDict['version'] = 1
    returnDict['disable_existing_loggers'] = True
    returnDict['formatters'] = {}
    returnDict['formatters']['standard'] = {}
    returnDict['formatters']['standard']['format'] = '%(asctime)s - %(levelname)s:%(levelno)s [%(module)s] [%(pathname)s:%(filename)s:%(lineno)d:%(funcName)s] %(message)s'
    returnDict['handlers'] = {}
    returnDict['handlers']['console'] = {}
    returnDict['handlers']['console']['class'] = 'logging.StreamHandler'
    returnDict['handlers']['console']['level'] = 'DEBUG'
    returnDict['handlers']['console']['formatter'] = 'standard'
    returnDict['handlers']['console']['stream'] = 'ext://sys.stdout'
    returnDict['handlers']['debug_file_handler'] = {}
    returnDict['handlers']['debug_file_handler']['class'] = 'logging.handlers.RotatingFileHandler'
    returnDict['handlers']['debug_file_handler']['level'] = 'DEBUG'
    returnDict['handlers']['debug_file_handler']['formatter'] = 'standard'
    returnDict['handlers']['debug_file_handler']['filename'] = pathDirectory + dictFeedType['LogDebugFilename']
    returnDict['handlers']['debug_file_handler']['maxBytes'] = 10000000
    returnDict['handlers']['debug_file_handler']['backupCount'] = 5
    returnDict['handlers']['debug_file_handler']['encoding'] = 'utf8'
    returnDict['handlers']['info_file_handler'] = {}
    returnDict['handlers']['info_file_handler']['class'] = 'logging.handlers.RotatingFileHandler'
    returnDict['handlers']['info_file_handler']['level'] = 'INFO'
    returnDict['handlers']['info_file_handler']['formatter'] = 'standard'
    returnDict['handlers']['info_file_handler']['filename'] = pathDirectory + dictFeedType['LogInfoFilename']
    returnDict['handlers']['info_file_handler']['maxBytes'] = 10000000
    returnDict['handlers']['info_file_handler']['backupCount'] = 5
    returnDict['handlers']['info_file_handler']['encoding'] = 'utf8'
    returnDict['handlers']['error_file_handler'] = {}
    returnDict['handlers']['error_file_handler']['class'] = 'logging.handlers.RotatingFileHandler'
    returnDict['handlers']['error_file_handler']['level'] = 'ERROR'
    returnDict['handlers']['error_file_handler']['formatter'] = 'standard'
    returnDict['handlers']['error_file_handler']['filename'] = pathDirectory + dictFeedType['LogErrorFilename']
    returnDict['handlers']['error_file_handler']['maxBytes'] = 10000000
    returnDict['handlers']['error_file_handler']['backupCount'] = 5
    returnDict['handlers']['error_file_handler']['encoding'] = 'utf8'
    returnDict['handlers']['error_file_handler_json'] = {}
    returnDict['handlers']['error_file_handler_json']['class'] = 'logging.handlers.RotatingFileHandler'
    returnDict['handlers']['error_file_handler_json']['level'] = 'ERROR'
    returnDict['handlers']['error_file_handler_json']['formatter'] = 'standard'
    returnDict['handlers']['error_file_handler_json']['filename'] = pathDirectory + dictFeedType['JSONErrorLogFilename']
    returnDict['handlers']['error_file_handler_json']['maxBytes'] = 10000000
    returnDict['handlers']['error_file_handler_json']['backupCount'] = 5
    returnDict['handlers']['error_file_handler_json']['encoding'] = 'utf8'
    returnDict['loggers'] = {}
    returnDict['loggers'][''] = {}
    returnDict['loggers']['']['level'] = 'DEBUG'
    returnDict['loggers']['']['handlers'] = ["console", "debug_file_handler"]
    returnDict['loggers']['']['propagate'] = False
    returnDict['loggers'][feedType + 'feedwebserviceinfo'] = {}
    returnDict['loggers'][feedType + 'feedwebserviceinfo']['level'] = 'INFO'
    returnDict['loggers'][feedType + 'feedwebserviceinfo']['handlers'] = ["info_file_handler"]
    returnDict['loggers'][feedType + 'feedwebserviceinfo']['propagate'] = False
    returnDict['loggers'][feedType + 'feedwebserviceinfo'] = {}
    returnDict['loggers'][feedType + 'feedwebserviceinfo']['level'] = 'ERROR'
    returnDict['loggers'][feedType + 'feedwebserviceinfo']['handlers'] = ["error_file_handler"]
    returnDict['loggers'][feedType + 'feedwebserviceinfo']['propagate'] = False

    # Return message
    return returnDict

  # Set Logger
  def _setLogger(self, logString):
    # Initialize dictionary
    config_dict = {}

    # Set variable
    feedType = 'news'

    # create object of news feed parser config
    nfwsconfig = newsfeedwebserviceconfig.NewsFeedWebServiceConfig()

    # Set variables based on type
    nfwsconfig._setFilenameVars('Log')

    # Get dictionary of values
    dictFeedType = nfwsconfig._getFilenameVars()

    # Set path
    pathDirectory = dictFeedType['pathParent'] + dictFeedType['pathLevelOne'] + dictFeedType['pathLevelTwo']

    # Set variable
    pathResourceFolder = pathlib.Path(pathDirectory)

    # Set file name
    logFilename = pathDirectory + dictFeedType['filenameMedia']

    # Set json config log
    pathJsonConfigFilename = dictFeedType['pathParent'] + dictFeedType['JSONConfigLogFilename']

    # Set variable for JSON configuration
    logConfigFilename = pathlib.Path(pathJsonConfigFilename)

    # Set json error log filename
    pathJsonErrorLogFilename = dictFeedType['pathParent'] + dictFeedType['pathLevelOne'] + dictFeedType['pathLevelTwo'] + dictFeedType['JSONErrorLogFilename']

    # Check if the following directory and or file exists
    if not pathResourceFolder.exists():
      # Recursively creates the directory and does not raise an exception if the directory already exist
      # Parent can be skipped as an argument if not needed or want to create parent directory
      pathlib.Path(pathResourceFolder).mkdir(parents=True, exist_ok=True)

    # Store loggin dict config JSON
    config_dict = self._setLogDictConfig()

    # Check if element exists
    if config_dict.get('file_name') != None:
      # Set configuration based on JSON schema
      logging.config.dictConfig(config_dict)
    else:
      # Configure basic logging
      # logging.basicConfig(filename=logFilename,level=logging.INFO, format='{"": %(asctime)s, "": %(levelname)s, "": %(levelno)s, "": %(module)s, "": %(pathname)s, "": %(filename)s, "": %(lineno)d, "": %(funcName)s, "": %(message)s}')
      logging.basicConfig(filename=logFilename,level=logging.DEBUG, format='%(asctime)s - %(levelname)s:%(levelno)s [%(module)s] [%(pathname)s:%(filename)s:%(lineno)d:%(funcName)s] %(message)s')

    # # Set info logger
    # logger = logging.getLogger(feedType + 'feedwebserviceinfo')

    # # Log string for info and provide traceback with exc_info=true
    # logger.info(logString, exc_info=True)
    # # logger.info((regEx.sub(r" +", ' ', regEx.sub(r"\n", ' ', logString)) + regEx.sub(r" +", ' ', regEx.sub(r"\n", ' ', traceback.format_exc()))).strip())

    # Set error logger
    logger = logging.getLogger(feedType + 'feedwebserviceerror')

    # Log string for errors and provide traceback with exc_info=true
    logger.error(logString, exc_info=True)

    # print (logging.getLogRecordFactory())
    # logger.error((regEx.sub(r" +", ' ', regEx.sub(r"\n", ' ', logString)) + regEx.sub(r" +", ' ', regEx.sub(r"\n", ' ', traceback.format_exc()))).strip())

    # Get current time stamp
    dateTimeObj = datetime.datetime.now()

    # Convert date time to string
    timestampStr = dateTimeObj.strftime('%Y-%m-%d %H:%M:%S.%f')

    # Check if path exist and check if file size is empty
    if os.path.exists(pathJsonErrorLogFilename) and os.stat(pathJsonErrorLogFilename).st_size == 0:
      # Restructure JSON output
      feedStorageNested = {feedType: {'created_date': timestampStr, 'updated_date': timestampStr, 'count': 1, 'children': [{'timestamp': timestampStr, 'error': (regEx.sub(r" +", ' ', regEx.sub(r"\n", ' ', logString))).strip(), 'traceback': (regEx.sub(r" +", ' ', regEx.sub(r"\n", ' ', traceback.format_exc()))).strip()}]}}

      # Write to json file
      self._writeToJSONFile(pathJsonErrorLogFilename, feedStorageNested)
    else:
      # File does not exist or size greater than zero (0)
      # Try the following code
      try:
        # Read from file
        with open(pathJsonErrorLogFilename, 'r', newline = '', encoding = 'utf8') as jsonFile:
          # Convert JSON to dictionary
          jsonData = json.load(jsonFile)

        # Check if element exists
        if jsonData.get(feedType, {}).get('children') != None:
          # Add another parameter at the next level
          jsonData[feedType]['children'].append({'timestamp': timestampStr, 'error': (regEx.sub(r" +", ' ', regEx.sub(r"\n", ' ', logString))).strip(), 'traceback': (regEx.sub(r" +", ' ', regEx.sub(r"\n", ' ', traceback.format_exc()))).strip()})

          # Retrieve count of data
          dataLength = len(jsonData[feedType]['children'])

          # Increment the count
          jsonData[feedType]['count'] = dataLength

          # Update the date
          jsonData[feedType]['updated_date'] = timestampStr

          # Write to json file
          self._writeToJSONFile(pathJsonErrorLogFilename, jsonData)
        else:
          # Rewrite the log file as there were issues with the current file
          # Restructure JSON output
          feedStorageNested = {feedType: {'created_date': timestampStr, 'updated_date': timestampStr, 'count': 1, 'children': [{'timestamp': timestampStr, 'error': (regEx.sub(r" +", ' ', regEx.sub(r"\n", ' ', logString))).strip(), 'traceback': (regEx.sub(r" +", ' ', regEx.sub(r"\n", ' ', traceback.format_exc()))).strip()}]}}

          # Write to json file
          self._writeToJSONFile(pathJsonErrorLogFilename, feedStorageNested)
      except ValueError as ve:
        # Restructure JSON output
        feedStorageNested = {feedType: {'created_date': timestampStr, 'updated_date': timestampStr, 'count': 1, 'children': [{'timestamp': timestampStr, 'error': (regEx.sub(r" +", ' ', regEx.sub(r"\n", ' ', str(ve)))).strip(), 'traceback': (regEx.sub(r" +", ' ', regEx.sub(r"\n", ' ', traceback.format_exc()))).strip()}]}}

        # Write to json file
        self._writeToJSONFile(pathJsonErrorLogFilename, feedStorageNested)

    # # Set root logger
    # logger = logging.getLogger(__name__)

    # # Log string for debugging and provide traceback with exc_info=true
    # logger.debug(logString, exc_info=True)
    # # logger.debug((regEx.sub(r" +", ' ', regEx.sub(r"\n", ' ', logString)) + regEx.sub(r" +", ' ', regEx.sub(r"\n", ' ', traceback.format_exc()))).strip())
