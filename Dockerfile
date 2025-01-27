FROM python:3.7.3-stretch

RUN apt-get update && \
    apt-get install -y \
        build-essential=12.3 \
        default-libmysqlclient-dev=1.0.2\
        nginx-light=1.10.3-1+deb9u2 \
        python3-dev=3.5.3-1 \
        supervisor=3.3.1-1+deb9u1 \
        && \
        apt-get clean && \
            rm -rf /var/lib/apt/lists/* \
                   /tmp/* \
                   /var/tmp/*

WORKDIR /srv

COPY requirements.txt /srv/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY project /srv/project
COPY system /srv/system
COPY manage.py /srv/manage.py
COPY .git /srv/.git

ENV PYTHONPATH /srv

RUN mkdir /srv/media
RUN python manage.py collectstatic --noinput --link

CMD ./system/run.sh

EXPOSE 80
