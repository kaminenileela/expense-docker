# FROM node:20
FROM node:20.15.0-alpine3.20
# for alpine container use docker exec -it backend sh for logging into container
EXPOSE 8080
ENV DB_HOST=mysql
#container name (i.e --name given to mysql)
# RUN useradd expense
RUN addgroup -S expense && adduser -S expense -G expense \
    && mkdir /opt/server \
    && chown expense:expense -R /opt/server
WORKDIR /opt/server
COPY package.json .
COPY *.js /opt/server/
RUN npm install 
USER expense
CMD [ "node","index.js"]