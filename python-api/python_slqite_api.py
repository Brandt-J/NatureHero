import base64
import logging
import mysql.connector
import sys

from configparser import ConfigParser
from flask import Flask

app = Flask(__name__)


HOST_IP: str = "5.189.191.115"
# HOST_IP: str = "127.0.0.1"
HOST_PORT: int = 8123
DEBUG: bool = True
disableRequestLogging: bool = True

cfg: ConfigParser = ConfigParser()
cfg.read("dbconfig.cfg")
cfg: dict = dict(cfg["DBLogin"])


@app.route('/')
def check_availability() -> str:
    return "OK"


@app.route("/get_plants")
def get_plants() -> list[str]:
    return fetch_from_db("SELECT Gattung FROM Gattungen WHERE FloraFauna='Flora';")


@app.route("/get_images_of/<string:name>/")
def get_images_of(name: str) -> list[str]:
    return fetch_from_db(f"SELECT Image FROM Images WHERE Art='{name}'")


def fetch_from_db(query: str) -> list:
    result = []
    try:
        cnx = mysql.connector.connect(**cfg)
        cursor = cnx.cursor()
        cursor.execute(query)

        for entry in cursor.fetchall():
            if len(entry) == 1:
                result.append(entry[0])
            else:
                result.append(entry)

            if type(result[-1]) == bytes:
                result[-1] =  base64.b64encode(result[-1]).decode('utf-8')

    finally:
        cnx.close()
    return result


if __name__ == '__main__':
    logger: logging.Logger = logging.getLogger("SQL-API")
    logger.addHandler(logging.StreamHandler(sys.stdout))
    logger.setLevel(logging.INFO)

    logging.basicConfig(format='%(asctime)s %(message)s')

    if disableRequestLogging:
        logging.getLogger("werkzeug").disabled = True

    logger.info("Starting SQL API")
    app.run(host=HOST_IP, port=HOST_PORT, debug=DEBUG)
