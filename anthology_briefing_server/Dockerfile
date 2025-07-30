FROM node:22.17

WORKDIR /app

RUN sudo npm install -g typescript

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 8080

CMD [ "npm", "start" ]
