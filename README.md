# HelloWorldNodeTypescript

## packages

### typescript:

`tsc` builds `*.ts` to `*.js`

- tsc --init
- tsc
- tsc --watch

### nodemon, ts-node

`nodemon.json` for `nodemon` and `ts-node`

- tsc && node /build/server.js
- nodemon server.ts

### PM2

`ecosystem.config.json` for `PM2`

- npm install pm2 -g
- pm2 start ecosystem.config.json --watch
- pm2 start ecosystem.config.json --only HelloWorldNodeTypescript --watch
- pm2 stop ecosystem.config.json

### node-schedule

`node-schedule` for Scheduling tasks

### aws-sdk-version-2

aws-sdk-version-2: https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/
