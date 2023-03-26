FROM node:18.15
WORKDIR .
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]

#FROM alpine
#EXPOSE 3000
#CMD ["npm", "start"]