import http.server
import socketserver
from http import HTTPStatus
from os import getpid, environ
import atexit
import sys

print(sys.argv)

args = sys.argv[1:]

port = int(args[0])

class Handler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(HTTPStatus.OK)
        self.send_header("x-pid", getpid())
        self.end_headers()
        self.wfile.write(b'Hello world')

print("listen on port " + str(port))

def exit_handler():
    print('http server exit!')

atexit.register(exit_handler)

httpd = socketserver.TCPServer(('0.0.0.0', port), Handler)
httpd.serve_forever()

def receive_signal(signum, stack):
    os.exit(0)

signal.signal(signal.SIGINT, receive_signal)

while True:
    print('Waiting...')
    time.sleep(3)