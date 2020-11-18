##
#        File: newsfeedwebservice.py
#     Created: 11/10/2020
#     Updated: 11/18/2020
#  Programmer: Cuates
#  Updated By: Cuates
#     Purpose: News feed web service
#     Version: 0.0.1 Python3
##

# Import modules
from flask import Flask, request, jsonify # Flask, request, jsonify
from flask_restful import Api # flask_restful, api
import json # json
import newsfeedwebserviceclass # news feed web service class
from newsfeedclass import NewsFeedClass # news feed web service class

# Create objects
app = Flask(__name__)
api = Api(app)

# Set object
nfwsclass = newsfeedwebserviceclass.NewsFeedWebServiceClass()

# try to execute the command(s)
try:
  # Error handler
  @app.errorhandler(Exception)
  def errorHandling(eh):
    # Initialize variables
    messageVal = ''
    codeVal = 500

    # try to execute the command(s)
    try:
      # Set message
      messageVal = str(eh.code) + ' ' + str(eh.name) + ' ' + str(eh.description)

      # Set code
      codeVal = eh.code
    # Catch exceptions
    except Exception as e:
      # Set message
      messageVal = 'ErrorHandler'

      # Log message
      nfwsclass._setLogger('ErrorHandler ' + str(e))

    # Return message
    return {'Status': 'Error', 'Message': messageVal, 'Count': 0, 'Result': []}, codeVal

  # Store possible methods
  validMethods = ['GET', 'POST', 'PUT', 'DELETE']

  # Before request
  @app.before_request
  def before_request_func():
    # Check if request method is in the list
    if request.method not in validMethods:
      # Return message
      return {'Status': 'Error', 'Message': 'Method invalid or not implemented', 'Count': 0, 'Result': []}, 501

  # Add resource for api web service call news feed
  api.add_resource(NewsFeedClass, '/api/newsfeed', methods = validMethods)
# Catch exceptions
except Exception as e:
  # Log message
  nfwsclass._setLogger('Issue executing main PY file ' + str(e))

# Run program
if __name__ == '__main__':
  # Run app
  app.run(host='127.0.0.1', port=4815, debug=True, threaded=True)