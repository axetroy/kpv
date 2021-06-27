import http.server
import socketserver
from http import HTTPStatus
from os import getpid
import atexit

class Handler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(HTTPStatus.OK)
        self.send_header("x-pid", getpid())
        self.end_headers()
        self.wfile.write(b'Hello world')

print("listen on port 9999")

def exit_handler():
    print('http server exit!')

atexit.register(exit_handler)

httpd = socketserver.TCPServer(('', 9999), Handler)
httpd.serve_forever()