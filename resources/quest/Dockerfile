FROM node
WORKDIR ./
COPY package.json .

RUN npm install
COPY . .

ENV SECRET_WORD="TwelveFactor"

EXPOSE 3000
ENTRYPOINT ["node", "src/000.js"]