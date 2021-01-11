
import argparse
import falcon  # pip install falcon
import json
import logging
import waitress  # pip install waitress

################################################################################
# Middleware
################################################################################
def json_serializer(obj): ####
    if isinstance(obj, datetime.datetime):
        return str(obj)
    elif isinstance(ob, decimal.Decimal):
        return str(obj)
    raise TypeError('Cannot serialize {!r} (type {})'.format(obj, type(obj)))######

class JSONTranslator:
    def process_request(self, req, resp):
        """
        req.stream corresponds to the WSGI wsgi.input environment variable; it
        allows to read bytes from the request body.
        See also: PEP 3333
        """
        if req.content_length in (None, 0): ######## set
            return  # Nothing to do
        body = req.stream.read()
        if not body: #??????????????
            raise falcon.HTTPBadRequest
            (
                'Empty request body. A valid JSON document is required.'
            )
        try:
            req.context['request'] = json.loads(body.decode('utf-8'))
        except (ValueError, UnicodeDecodeError):
            description = 'Could not decode the request body. The JSON was incorrect or not encoded as UTF-8.'
            raise falcon.HTTPError
            (
                'Malformed JSON',
                description
            )

    def process_response(self, req, resp, resource, req_succeeded):#######
        if 'response' not in resp.context:
            return
        # It converts the dictionary to JSON. It uses the method
        # json_serializer, which converts datetime and decimal to strings so if
        # the API returns those data types middleware (json.dumps()) will
        # convert them to strings since datetime and decimal are not JSON
        # serializable.
        resp.body = json.dumps(resp.context['response'], default=json_serializer)######

class RequireJSON:
    def process_request(self, req, resp):
        if not req.client_accepts_json:
            raise falcon.HTTPNotAcceptable
            (
                #falcon.HTTP_406,
                'This API only supports responses encoded as JSON.',
                ##href='http://docs.examples.com/api/json'
            )
        if req.method in ('POST', 'PUT'):
            if 'application/json' not in req.content_type:
                raise falcon.HTTPUnsupportedMediaType
                (
                    #falcon.HTTP_415,
                    'This API only supports responses encoded as JSON.',
                    ##href='http://docs.examples.com/api/json'
                )

################################################################################
# Responders
################################################################################
# A resource is an instance of a class that defines various "responder" methods,
# one for each HTTP method the resource allows. Responder names start with on_
# and are named according to which HTTP method they handle, as in on_get,
# on_post, on_put, etc.
#
# If the resource does not support a particular HTTP method, simply omit the
# corresponding responder and Falcon will reply with "405 Method not allowed"
# if that method is ever requested.
#
# Responders must always define at least two arguments to receive request and
# response objects, respectively.
class Delete:
    """ TBD """
    def __init__(self):
        """ Ctor """
        pass

    def __str__(self):
        """ Return a string representation of the object. """
        pass

    def __del__(self):
        """ Dtor """
        print('dtor')

    def on_delete(self, req, resp):
        """ Handle DELETE requests. """
        body = """{
                    "query":
                    {
                      "match_all": {}
                    }
                  }"""
        to_json = json.dumps(body)
        resp.context['response'] = { "Query": "Delete all",
                                     "text": body,
                                     "json": to_json
                                   }
        resp.status = falcon.HTTP_200

    def on_delete_ByDocumentId(self, req, resp, key, value):
        if key not in ('title'):
            title = 'Invalid key.'
            description = 'Valid keys: title'
            raise falcon.HTTPBadRequest
            (
                title,
                description
            )
        body = """{{
                    "query":
                    {{
                      "match": {{"{k}": "{v}"}}
                    }}
                  }}""".format(k=key, v=value)
        to_json = json.dumps(body)
        resp.context['response'] = { "Query": "Delete by document id",
                                     "key": key,
                                     "text": body,
                                     "json": to_json
                                   }
        resp.status = falcon.HTTP_200

class Insert:
    """ TBD """
    def __init__(self):
        """ Ctor """
        pass

    def __str__(self):
        """ Return a string representation of the object. """
        pass

    def __del__(self):
        """ Dtor """
        print('dtor')

    def on_put(self, req, resp):
        """ Handle POST requests. """
        body = '{"message": "Insert!"}'
        resp.body = json.dumps(body, ensure_ascii = False)
        resp.status = falcon.HTTP_201  # 201 Created

    def on_post(self, req, resp):
        pass

def main(argv):
    logger = logging.getLogger('waitress')
    logger.setLevel(logging.INFO)
    # argparse will automatically work with the command line.
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", default=18080, type=int)
    # parser.add_argument("--host", default='::', type=str)  # IPv6
    parser.add_argument("--host", default='0.0.0.0', type=str)
    args = parser.parse_args()
    # The Web Server Gateway Interface (WSGI) is a standard interface between
    # web servers and Python web application frameworks. Since Falcon does not
    # have a built-in server, a WSGI server is required to serve Falcon apps.
    # Falcon is a bare-metal Python web API framework used for building fast
    # app backends and microservices.
    api = falcon.API(media_type='application/json',
                     middleware=[
                                    JSONTranslator(),
                                    RequireJSON()
                                ])
    # Resources are represented by long-lived class instances.
    delete = Delete()
    # Falcon routes incoming requests to resources based on a set of URI
    # templates. If the path requested by the client matches the template for a
    # given route, the request is then passed on to the associated resource for
    # processing.
    #
    # If no route matches the request, control then passes to a default
    # responder that simply raises an instance of :class:'~.HTTPNotFound'.
    # Normally this will result in sending a 404 response back to the client.
    #
    # Falcon expects a class for each route.
    # Falcon's FAQs state that it does not support asyncio at this time.
    # (https://falcon.readthedocs.io/en/stable/user/faq.html#does-falcon-support-asyncio)
    # curl -i -X DELETE "http://movies.dev.local/api/v1/Delete/All"
    api.add_route('/api/v1/Delete/All', delete)
    # curl -i -X DELETE "http://JuanCarlos-PC:19200/api/v1/Delete/ByDocumentId/title/Valkyrie"
    api.add_route('/api/v1/Delete/ByDocumentId/{key}/{value}', delete,
                  suffix='ByDocumentId')
    api.add_route('/Insert', Insert())
    # By default, Waitress binds to any IPv4 address on port 8080.
    # Number of threads used to process application logic, default is 4.
    waitress.serve(api, host=args.host, port=args.port, threads=10)
    #server = simple_server(api, host=args.host, port=args.port, threads=10)
