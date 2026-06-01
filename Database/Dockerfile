FROM mcr.microsoft.com/mssql/server:2022-latest

USER root

RUN mkdir -p /init
COPY init/ /init/
COPY init-db.sh /init-db.sh
RUN chmod +x /init-db.sh

USER mssql

CMD ["/bin/bash", "/init-db.sh"]
