import http.server
import socketserver
from http import HTTPStatus
from os import getpid

class Handler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(HTTPStatus.OK)
        self.send_header("x-pid", getpid())
        self.end_headers()
        self.wfile.write(b'Hello world')

print("listen on port 9999")

httpd = socketserver.TCPServer(('', 9999), Handler)
httpd.serve_forever()