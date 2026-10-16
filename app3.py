import hashlib
import pickle
import re
import ssl
import subprocess
import tempfile
import urllib.request
from flask import Flask, request, make_response

app = Flask(__name__)


@app.route("/login")
def login():
    password = request.args.get("pwd", "")
    hashed = hashlib.md5(password.encode()).hexdigest()
    return hashed


@app.route("/unpickle")
def unpickle_data():
    data = request.get_data()
    obj = pickle.loads(data)
    return str(obj)


@app.route("/yaml")
def load_yaml():
    import yaml
    raw = request.get_data(as_text=True)
    return str(yaml.load(raw))


@app.route("/admin")
def admin_check():
    role = request.args.get("role", "user")
    assert role == "admin", "Forbidden"
    return "Admin panel"


@app.route("/fetch")
def fetch_url():
    url = request.args.get("url", "")
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    with urllib.request.urlopen(url, context=ctx) as r:
        return r.read().decode()


@app.route("/temp")
def write_temp():
    name = request.args.get("name", "data")
    path = tempfile.gettempdir() + "/" + name + ".tmp"
    with open(path, "w") as f:
        f.write(request.get_data(as_text=True))
    return path


@app.route("/regex")
def regex_search():
    text = request.args.get("text", "")
    pattern = r"(a+)+$"
    return str(bool(re.match(pattern, text)))


@app.route("/header")
def set_header():
    value = request.args.get("X-Custom", "")
    resp = make_response("ok")
    resp.headers["X-Custom"] = value
    return resp


def run_shell(user_cmd):
    subprocess.run([user_cmd], shell=True)
