import logging
import os
import sys
import urlparse
import webbrowser
from BaseHTTPServer import HTTPServer, BaseHTTPRequestHandler
import requests

import csv

logging.basicConfig(level=logging.DEBUG)

# Store your client ID and secret in your OS's environment using these keys, or
# redefine these values here.
CLIENT_ID = os.environ.get('MMF_CLIENT_ID')
CLIENT_SECRET = os.environ.get('MMF_CLIENT_SECRET')

if CLIENT_ID is None or CLIENT_SECRET is None:
    print 'Please ensure $MMF_CLIENT_ID and $MMF_CLIENT_SECRET environment ' \
          'variables are set.'
    sys.exit(1)

CLIENT_AUTH_TOKEN = os.environ.get('MMF_CLIENT_TOKEN')

#TODO: find a way to store the client token to avoid always asking for it
if CLIENT_AUTH_TOKEN is None:

    # As a convenience, localhost.mapmyapi.com redirects to localhost.
    redirect_uri = 'http://localhost.mapmyapi.com:12345/callback'
    authorize_url = 'https://www.mapmyfitness.com/v7.0/oauth2/authorize/?' \
                    'client_id={0}&response_type=code&redirect_uri={1}'.format(CLIENT_ID, redirect_uri)


    # Set up a basic handler for the redirect issued by the MapMyFitness 
    # authorize page. For any GET request, it simply returns a 200.
    # When run interactively, the request's URL will be printed out.
    class AuthorizationHandler(BaseHTTPRequestHandler):
        def do_GET(self):
            self.send_response(200, 'OK')
            self.send_header('Content-Type', 'text/html')
            self.end_headers()
            self.server.path = self.path


    parsed_redirect_uri = urlparse.urlparse(redirect_uri)
    server_address = parsed_redirect_uri.hostname, parsed_redirect_uri.port

    print 'server_address:', server_address

    # NOTE: Don't go to the web browser just yet...
    webbrowser.open(authorize_url)

    # Start our web server. handle_request() will block until a request comes in.
    httpd = HTTPServer(server_address, AuthorizationHandler)
    print 'Now waiting for the user to authorize the application...'
    httpd.handle_request()

    # At this point a request has been handled. Let's parse its URL.
    httpd.server_close()
    callback_url = urlparse.urlparse(httpd.path)
    authorize_code = urlparse.parse_qs(callback_url.query)['code'][0]

    print 'Got an authorize code:', authorize_code

    access_token_url = 'https://api.ua.com/v7.1/oauth2/uacf/access_token/'
    access_token_data = {'grant_type': 'authorization_code',
                         'client_id': CLIENT_ID,
                         'client_secret': CLIENT_SECRET,
                         'code': authorize_code}

    response = requests.post(url=access_token_url,
                             data=access_token_data,
                             headers={'Api-Key': CLIENT_ID})

    print 'Request details:'
    print 'Content-Type:', response.request.headers['Content-Type']
    print 'Request body:', response.request.body

    # retrieve the access_token from the response
    try:
        access_token = response.json()
        CLIENT_AUTH_TOKEN = access_token['access_token']
        os.environ['MMF_CLIENT_TOKEN'] = CLIENT_AUTH_TOKEN

        print 'Got an access token:', access_token
    except:
        print 'Did not get JSON. Here is the response and content:'
        print response
        print response.content


singapore_coordinates = "1.3000,103.8000"
routes_url = 'https://api.ua.com/v7.1/route/?close_to_location=%s&maximum_distance=%s' % (singapore_coordinates, '20000')
response = requests.get(url=routes_url, verify=False,
                        headers={'api-key': CLIENT_ID, 'authorization': 'Bearer %s' % CLIENT_AUTH_TOKEN })

page_routes = response.json()
total_count = page_routes['total_count']

route_id=0
for route_item in page_routes['_embedded']['routes']:

    # route_item = page_routes['_embedded']['routes'][19]

    route_item_append = route_item["_links"]["self"][0]["href"]

    route_item_url = 'https://api.ua.com/%s?field_set=detailed' % (route_item_append)
    response = requests.get(url=route_item_url, verify=False,
                            headers={'api-key': CLIENT_ID, 'authorization': 'Bearer %s' % CLIENT_AUTH_TOKEN })

    route_item = response.json()
    data_points = route_item["points"]
    filename="sg_route_%d.csv" % route_id

    with open(filename, 'w') as fp:
        a = csv.writer(fp, delimiter=',')
        a.writerow(["latitude", "longitude"])
        for point in data_points:
            a.writerow([point['lat'], point['lng']])

    route_id = route_id + 1

#working

'''
# Use the access token to request a resource on behalf of the user
activity_type_url = 'https://oauth2-api.mapmyapi.com/v7.0/activity_type/'
response = requests.get(url=activity_type_url, verify=False,
                        headers={'api-key': CLIENT_ID, 'authorization': 'Bearer %s' % access_token['access_token']})

# Refresh a client's credentials to prevent expiration
refresh_token_url = 'https://oauth2-api.mapmyapi.com/v7.0/oauth2/access_token/'
refresh_token_data = {'grant_type': 'refresh_token',
                      'client_id': CLIENT_ID,
                      'client_secret': CLIENT_SECRET,
                      'refresh_token': access_token['refresh_token']}

response = requests.post(url=refresh_token_url, data=refresh_token_data,
                         headers={'api-key': CLIENT_ID, 'authorization': 'Bearer %s' % access_token['access_token']})

print 'Request details:'
print 'Content-Type:', response.request.headers['Content-Type']
print 'Request body:', response.request.body

try:
    access_token = response.json()
    print 'Got an access token:', access_token
except:
    print 'Did not get JSON. Here is the response and content:'
    print response
    print response.content

# Attempt another request on the user's behalf using the token
refresh_token = response.json()
response = requests.get(url=activity_type_url, verify=False,
                        headers={'api-key': CLIENT_ID, 'authorization': 'Bearer %s' % access_token['access_token']})
'''
