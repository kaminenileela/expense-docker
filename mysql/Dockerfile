FROM mysql:8.0
RUN adduser -r expense 
COPY scripts/*.sql /docker-entrypoint-initdb.d/
# -r is creating "system user" which is not like human, only for system.
# ENV MYSQL_ROOT_PASSWORD=ExpenseApp@1 \
#     MYSQL_USER=expense \
#     MYSQL_PASSWORD=ExpenseApp@1 \
#     MYSQL_DATABASE=transactions
RUN chown -R expense:expense /var/lib/mysql /var/run/mysqld /usr/sbin/mysqld
    # mysql directory is /var/lib/mysql where database is stored.so this access should be given to system user (which is normal user and not root)

USER expense
# atleast last instruction should be given to normal user.
