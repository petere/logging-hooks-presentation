#!/usr/bin/env python

import psycopg2
import sys, SocketServer

class JSONLogServer(SocketServer.BaseRequestHandler):
    """
    Sample UDP server for receiving JSON messages.
    """

    def handle_json(self, data):
        try:
            import json
            msg = json.loads(data)
            cursor = self.server.dbconn.cursor()
            cursor.execute("INSERT INTO logging (database, elevel, message) VALUES (%s, %s, %s)", (msg['database'], msg['elevel'], msg['message']))
            self.server.dbconn.commit()
        except Exception, e:
            print("json parsing error: %s" % e)

    def handle(self):
        data = self.request[0].strip()

        #print("raw message: %s" % data)
        if not data:
            return

        self.handle_json(data)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        PORT = 23456
    else:
        PORT = int(sys.argv[1])
    HOST = ""

    dbconn = psycopg2.connect(dbname='logging', port=5433)

    print("Listening on %s:%s" % (HOST, PORT))
    server = SocketServer.UDPServer((HOST, PORT), JSONLogServer)
    server.dbconn = dbconn
    server.serve_forever()

    dbconn.close()
