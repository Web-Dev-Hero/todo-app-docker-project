
#--using multi-staging-------

# -----------stage-1 start----------
FROM python:3.10 AS build

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install   -r requirements.txt
RUN pip install flask flask-mysqldb

# ---stage-2 start---------

FROM python:3.10-slim

WORKDIR /app

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/local/lib/python3.10/site-packages/ /usr/local/lib/python3.10/site-packages/

COPY --from=build /app /app

COPY . .

CMD ["python","app.py"]
