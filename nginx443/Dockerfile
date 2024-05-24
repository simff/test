FROM nginx
RUN apt update
RUN apt remove nginx -y
RUN apt install nginx -y
RUN rm /var/www/html/*
COPY ./index.html /var/www/html/
COPY ./ssl-cert-snakeoil.pem /etc/ssl/certs/
COPY ./ssl-cert-snakeoil.key /etc/ssl/private/
COPY ./default /etc/nginx/sites-available/
EXPOSE 80
EXPOSE 443
