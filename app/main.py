from flask import Flask, jsonify
import os
import socket

app = Flask(__name__)

@app.get("/")
def index():
    return jsonify(
        service="platform-app",
        environment=os.getenv("APP_ENV", "development"),
        hostname=socket.gethostname(),
        status="running",
    )

@app.get("/health/live")
def liveness():
    return jsonify(status="alive"), 200

@app.get("/health/ready")
def readiness():
    return jsonify(status="ready"), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
