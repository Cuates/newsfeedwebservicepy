##
#        File: newsfeedclass.py
#     Created: 11/10/2020
#     Updated: 11/17/2020
#  Programmer: Cuates
#  Updated By: Cuates
#     Purpose: News feed web service
#     Version: 0.0.1 Python3
##

# Import modules
import newsfeedwebserviceclass # news feed web service class
from flask import Flask, request, jsonify # Flask, request, jsonify
from flask_restful import Resource #Api # flask_restful, api, resource
import json # json

# Class
class NewsFeedClass(Resource):
  # Constructor
  def __init__(self):
    pass

  # Get method
  def get(self):
    # Initialize list, dictionary, and variables
    resultDict = {}
    returnDict = {}
    codeVal = 200

    # Create object of news feed web service class
    nfwsclass = newsfeedwebserviceclass.NewsFeedWebServiceClass()

    # try to execute the command(s)
    try:
      # Store headers
      wsHead = dict(request.headers)

      # Set variable
      #reqPath = request.path

      # Check if headers were provided
      webserviceHeaderResponse = nfwsclass._checkHeaders(wsHead)

      # Check if element exists
      if webserviceHeaderResponse.get('Status') != None:
        # Check if status is success
        if webserviceHeaderResponse['Status'] == 'Success':
          # Set list
          mandatoryParams = []

          # Check payload
          payloadResponse = nfwsclass._checkPayload(request.method, request.args, mandatoryParams)

          # Check if element exists
          if payloadResponse.get('Status') != None:
            # Check if status is success
            if payloadResponse['Status'] == 'Success':
              # Set variable
              statusVal = 'Success'
              messageVal = 'Processed request'
              selectColumn = 'select titlereturn as "Title", imageurlreturn as "Image URL", feedurlreturn as "Feed URL", actualurlreturn as "Acutal URL", publishdatereturn as "Publish Date"'

              # Initialize list
              possibleParams = ['title', 'imageurl', 'feedurl', 'actualurl', 'limit', 'sort']

              # Extract news feed
              resultDict = nfwsclass._extractNewsFeed('MariaDBSQLNews', 'extracting', '', 'extractnewsfeed', 'extractNewsFeed', possibleParams, payloadResponse['Result'])
              resultDict = nfwsclass._extractNewsFeed('PGSQLNews', 'extracting', selectColumn, 'extractnewsfeed', 'extractNewsFeed', possibleParams, payloadResponse['Result'])
              resultDict = nfwsclass._extractNewsFeed('MSSQLLNews', 'extracting', '', 'dbo.extractNewsFeed', 'extractNewsFeed', possibleParams, payloadResponse['Result'])
              resultDict = nfwsclass._extractNewsFeed('MSSQLWNews', 'extracting', '', 'dbo.extractNewsFeed', 'extractNewsFeed', possibleParams, payloadResponse['Result'])

              # Check if there is data
              if resultDict:
                # Loop through sub elements
                for systemEntries in resultDict:
                  # Check if elements exists
                  if systemEntries.get('SError') != None:
                    # Store status value
                    statusVal = systemEntries['SError']

                    # Store message value
                    messageVal = systemEntries['SMessage']

                    # Set code
                    codeVal = 500

                    # Break out of loop
                    break

                # Check if status value is success
                if statusVal == 'Success':
                  # Store Message
                  returnDict = {'Status': statusVal, 'Message': messageVal, 'Count': len(resultDict), 'Result': resultDict}
                else:
                  # Store Message
                  returnDict = {'Status': statusVal, 'Message': messageVal, 'Count': 0, 'Result': []}
              else:
                # Store Message
                returnDict = {'Status': 'Success', 'Message': 'Processed request', 'Count': 0, 'Result': []}
            else:
              # Store Message
              returnDict = {'Status': payloadResponse['Status'], 'Message': payloadResponse['Message'], 'Count': 0, 'Result': []}

              # Store code
              codeVal = 400
          else:
            # Store Message
            returnDict = {'Status': 'Error', 'Message': 'Issue with payload check', 'Count': 0, 'Result': []}

            # Store code
            codeVal = 400
        else:
          # Store Message
          returnDict = {'Status': webserviceHeaderResponse['Status'], 'Message': webserviceHeaderResponse['Message'], 'Count': 0, 'Result': []}

          # Store code
          codeVal = 400
      else:
        # Store Message
        returnDict = {'Status': 'Error', 'Message': 'Issue with header check', 'Count': 0, 'Result': []}

        # Store code
        codeVal = 400
    # Catch exceptions
    except Exception as e:
      # Store Message
      returnDict = {'Status': 'Error', 'Message': 'GET not implemented properly', 'Count': 0, 'Result': []}

      # Log message
      nfwsclass._setLogger('GET ' + str(e))

    # Return dictionary with code
    return returnDict, codeVal

  # Post method
  def post(self):
    # Initialize list, dictionary, and variables
    resultDict = {}
    returnDict = {}
    codeVal = 200

    # Create object of news feed web service class
    nfwsclass = newsfeedwebserviceclass.NewsFeedWebServiceClass()

    # try to execute the command(s)
    try:
      # Store headers
      wsHead = dict(request.headers)

      # Set variable
      #reqPath = request.path

      # Check if headers were provided
      webserviceHeaderResponse = nfwsclass._checkHeaders(wsHead)

      # Check if element exists
      if webserviceHeaderResponse.get('Status') != None:
        # Check if status is success
        if webserviceHeaderResponse['Status'] == 'Success':
          # Set list
          mandatoryParams = ['title', 'feedurl', 'publishdate']

          # Check payload
          payloadResponse = nfwsclass._checkPayload(request.method, request.data, mandatoryParams)

          # Check if element exists
          if payloadResponse.get('Status') != None:
            # Check if status is success
            if payloadResponse['Status'] == 'Success':
              # Set variable
              statusVal = 'Success'
              messageVal = 'Processed request'

              # Initailize list
              possibleParams = ['title', 'imageurl', 'feedurl', 'actualurl', 'publishdate']
              removeParams = []

              # Insert news feed
              resultDict = nfwsclass._insertupdatedeleteNewsFeed('MariaDBSQLNews', 'inserting', 'insertupdatedeletenewsfeed', 'insertNewsFeed', possibleParams, payloadResponse['Result'], removeParams)
              resultDict = nfwsclass._insertupdatedeleteNewsFeed('PGSQLNews', 'inserting', 'insertupdatedeletenewsfeed', 'insertNewsFeed', possibleParams, payloadResponse['Result'], removeParams)
              resultDict = nfwsclass._insertupdatedeleteNewsFeed('MSSQLLNews', 'inserting', 'dbo.insertupdatedeleteNewsFeed', 'insertNewsFeed', possibleParams, payloadResponse['Result'], removeParams)
              resultDict = nfwsclass._insertupdatedeleteNewsFeed('MSSQLWNews', 'inserting', 'dbo.insertupdatedeleteNewsFeed', 'insertNewsFeed', possibleParams, payloadResponse['Result'], removeParams)

              # Loop through sub elements
              for systemEntries in resultDict:
                # Check if elements exists
                if systemEntries.get('SError') != None:
                  # Store status value
                  statusVal = systemEntries['SError']

                  # Store message value
                  messageVal = systemEntries['SMessage']

                  # Set code
                  codeVal = 500

                  # Break out of the loop
                  break

              if statusVal == 'Success':
                # Store Message
                returnDict = {'Status': statusVal, 'Message': messageVal, 'Count': len(resultDict), 'Result': resultDict}
              else:
                # Store Message
                returnDict = {'Status': statusVal, 'Message': messageVal, 'Count': 0, 'Result': []}
            else:
              # Store Message
              returnDict = {'Status': payloadResponse['Status'], 'Message': payloadResponse['Message'], 'Count': 0, 'Result': []}

              # Store code
              codeVal = 400
          else:
            # Store Message
            returnDict = {'Status': 'Error', 'Message': 'Issue with payload check', 'Count': 0, 'Result': []}

            # Store code
            codeVal = 400
        else:
          # Store Message
          returnDict = {'Status': 'Error', 'Message': webserviceHeaderResponse['Message'], 'Count': 0, 'Result': []}
      else:
        # Store Message
        returnDict = {'Status': 'Error', 'Message': 'Issue with header check', 'Count': 0, 'Result': []}
    # Catch exceptions
    except Exception as e:
      # Store Message
      returnDict = {'Status': 'Error', 'Message': 'POST not implemented properly', 'Count': 0, 'Result': []}

      # Set code
      codeVal = 500

      # Log message
      nfwsclass._setLogger('POST ' + str(e))

    # Return dictionary with code
    return returnDict, codeVal

  # Put method
  def put(self):
    # Initialize list, dictionary, and variables
    resultDict = {}
    returnDict = {}
    codeVal = 200

    # Create object of news feed web service class
    nfwsclass = newsfeedwebserviceclass.NewsFeedWebServiceClass()

    # try to execute the command(s)
    try:
      # Store headers
      wsHead = dict(request.headers)

      ## Set variable
      #reqPath = request.path

      # Check if headers were provided
      webserviceHeaderResponse = nfwsclass._checkHeaders(wsHead)

      # Check if element exists
      if webserviceHeaderResponse.get('Status') != None:
        # Check if status is success
        if webserviceHeaderResponse['Status'] == 'Success':
          # Set list
          mandatoryParams = ['title', 'feedurl', 'publishdate']

          # Check payload
          payloadResponse = nfwsclass._checkPayload(request.method, request.data, mandatoryParams)

          # Check if element exists
          if payloadResponse.get('Status') != None:
            # Check if status is success
            if payloadResponse['Status'] == 'Success':
              # Set variable
              statusVal = 'Success'
              messageVal = 'Processed request'

              # Initailize list
              possibleParams = ['title', 'imageurl', 'feedurl', 'actualurl', 'publishdate']
              removeParams = []

              # Update news feed
              resultDict = nfwsclass._insertupdatedeleteNewsFeed('MariaDBSQLNews', 'updating', 'insertupdatedeletenewsfeed', 'updateNewsFeed', possibleParams, payloadResponse['Result'], removeParams)
              resultDict = nfwsclass._insertupdatedeleteNewsFeed('PGSQLNews', 'updating', 'insertupdatedeletenewsfeed', 'updateNewsFeed', possibleParams, payloadResponse['Result'], removeParams)
              resultDict = nfwsclass._insertupdatedeleteNewsFeed('MSSQLLNews', 'updating', 'dbo.insertupdatedeleteNewsFeed', 'updateNewsFeed', possibleParams, payloadResponse['Result'], removeParams)
              resultDict = nfwsclass._insertupdatedeleteNewsFeed('MSSQLWNews', 'updating', 'dbo.insertupdatedeleteNewsFeed', 'updateNewsFeed', possibleParams, payloadResponse['Result'], removeParams)

              # Loop through sub elements
              for systemEntries in resultDict:
                # Check if elements exists
                if systemEntries.get('SError') != None:
                  # Store status value
                  statusVal = systemEntries['SError']

                  # Store message value
                  messageVal = systemEntries['SMessage']

                  # Set code
                  codeVal = 500

                  # Break out of the loop
                  break

              if statusVal == 'Success':
                # Store Message
                returnDict = {'Status': statusVal, 'Message': messageVal, 'Count': len(resultDict), 'Result': resultDict}
              else:
                # Store Message
                returnDict = {'Status': statusVal, 'Message': messageVal, 'Count': 0, 'Result': []}
            else:
              # Store Message
              returnDict = {'Status': payloadResponse['Status'], 'Message': payloadResponse['Message'], 'Count': 0, 'Result': []}

              # Store code
              codeVal = 400
          else:
            # Store Message
            returnDict = {'Status': 'Error', 'Message': 'Issue with payload check', 'Count': 0, 'Result': []}

            # Store code
            codeVal = 400
        else:
          # Store Message
          returnDict = {'Status': 'Error', 'Message': webserviceHeaderResponse['Message'], 'Count': 0, 'Result': []}
      else:
        # Store Message
        returnDict = {'Status': 'Error', 'Message': 'Issue with header check', 'Count': 0, 'Result': []}
    # Catch exceptions
    except Exception as e:
      # Store Message
      returnDict = {'Status': 'Error', 'Message': 'PUT not implemented properly', 'Count': 0, 'Result': []}

      # Set code
      codeVal = 500

      # Log message
      nfwsclass._setLogger('PUT ' + str(e))

    # Return dictionary with code
    return returnDict, codeVal

  # Delete method
  def delete(self):
    # Initialize list, dictionary, and variables
    resultDict = {}
    returnDict = {}
    codeVal = 200

    # Create object of news feed web service class
    nfwsclass = newsfeedwebserviceclass.NewsFeedWebServiceClass()

    # try to execute the command(s)
    try:
      # Store headers
      wsHead = dict(request.headers)

      ## Set variable
      #reqPath = request.path

      # Check if headers were provided
      webserviceHeaderResponse = nfwsclass._checkHeaders(wsHead)

      # Check if element exists
      if webserviceHeaderResponse.get('Status') != None:
        # Check if status is success
        if webserviceHeaderResponse['Status'] == 'Success':
          # Set list
          mandatoryParams = ['title']

          # Check payload
          payloadResponse = nfwsclass._checkPayload(request.method, request.data, mandatoryParams)

          # Check if element exists
          if payloadResponse.get('Status') != None:
            # Check if status is success
            if payloadResponse['Status'] == 'Success':
              # Set variable
              statusVal = 'Success'
              messageVal = 'Processed request'

              # Initailize list
              possibleParams = ['title', 'imageurl', 'feedurl', 'actualurl', 'publishdate']
              removeParams = ['imageurl', 'feedurl', 'actualurl', 'publishdate']

              # Delete news feed
              resultDict = nfwsclass._insertupdatedeleteNewsFeed('MariaDBSQLNews', 'deleting', 'insertupdatedeletenewsfeed', 'deleteNewsFeed', possibleParams, payloadResponse['Result'], removeParams)
              resultDict = nfwsclass._insertupdatedeleteNewsFeed('PGSQLNews', 'deleting', 'insertupdatedeletenewsfeed', 'deleteNewsFeed', possibleParams, payloadResponse['Result'], removeParams)
              resultDict = nfwsclass._insertupdatedeleteNewsFeed('MSSQLLNews', 'deleting', 'insertupdatedeleteNewsFeed', 'deleteNewsFeed', possibleParams, payloadResponse['Result'], removeParams)
              resultDict = nfwsclass._insertupdatedeleteNewsFeed('MSSQLWNews', 'deleting', 'dbo.insertupdatedeleteNewsFeed', 'deleteNewsFeed', possibleParams, payloadResponse['Result'], removeParams)

              # Loop through sub elements
              for systemEntries in resultDict:
                # Check if elements exists
                if systemEntries.get('SError') != None:
                  # Store status value
                  statusVal = systemEntries['SError']

                  # Store message value
                  messageVal = systemEntries['SMessage']

                  # Set code
                  codeVal = 500

                  # Break out of the loop
                  break

              if statusVal == 'Success':
                # Store Message
                returnDict = {'Status': statusVal, 'Message': messageVal, 'Count': len(resultDict), 'Result': resultDict}
              else:
                # Store Message
                returnDict = {'Status': statusVal, 'Message': messageVal, 'Count': 0, 'Result': []}
            else:
              # Store Message
              returnDict = {'Status': payloadResponse['Status'], 'Message': payloadResponse['Message'], 'Count': 0, 'Result': []}

              # Store code
              codeVal = 400
          else:
            # Store Message
            returnDict = {'Status': 'Error', 'Message': 'Issue with payload check', 'Count': 0, 'Result': []}

            # Store code
            codeVal = 400
        else:
          # Store Message
          returnDict = {'Status': 'Error', 'Message': webserviceHeaderResponse['Message'], 'Count': 0, 'Result': []}
      else:
        # Store Message
        returnDict = {'Status': 'Error', 'Message': 'Issue with header check', 'Count': 0, 'Result': []}
    # Catch exceptions
    except Exception as e:
      # Store Message
      returnDict = {'Status': 'Error', 'Message': 'DELETE not implemented properly', 'Count': 0, 'Result': []}

      # Set code
      codeVal = 500

      # Log message
      nfwsclass._setLogger('DELETE ' + str(e))

    # Return dictionary with code
    return returnDict, codeVal