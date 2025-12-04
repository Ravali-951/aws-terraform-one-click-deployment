from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
    return "Hello!"

@app.route("/health")
def health():
    return "ok"

app.run(host="0.0.0.0", port=8080)
