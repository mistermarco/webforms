FROM ubuntu:14.04
MAINTAINER Marco Wise <marco.wise@stanford.edu>

RUN apt-get update && apt-get install -y \
  apache2 \
  build-essential \
  cpanminus \
  libapache2-mod-perl2 \
  mysql-server \
  perl \
  supervisor \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*


RUN ["cpanm", "Class::DBI", "Data::Dumper", "Data::FormValidator", "DateTime", "MIME::Lite", "Spreadsheet::WriteExcel", "Template",	"Text::CSV" ]


RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/mysqld /var/log/supervisor /var/cgi-bin

# enable cgi
RUN ln -s /etc/apache2/mods-available/cgid.load /etc/apache2/mods-enabled/
RUN ln -s /etc/apache2/mods-available/cgid.conf /etc/apache2/mods-enabled/

COPY docker/000-default.conf /etc/apache2/sites-available/000-default.conf

COPY . /var/www/html/

RUN cp /var/www/html/includes/config_sample.txt /var/www/html/includes/config.txt
RUN cp /var/www/html/.htaccess_sample /var/www/html/.htaccess

RUN chmod +x /var/www/html/includes/data/db_init.sh
RUN /var/www/html/includes/data/db_init.sh

COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80 3306

CMD ["/usr/bin/supervisord"]
