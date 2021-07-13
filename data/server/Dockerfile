FROM node:10-alpine

WORKDIR /data-server/data/server/

COPY package* ./

RUN npm install

EXPOSE 5421

CMD npm start