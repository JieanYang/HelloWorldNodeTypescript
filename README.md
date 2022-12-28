# HelloWorldNodeJsAgent

## packages

### typescript:

- tsc --init
- tsc
- tsc --watch

### nodemon, ts-node

- tsc && node /build/app.js
- nodemon app.ts

### PM2

- npm install pm2 -g
- pm2 start ecosystem.config.json --watch
- pm2 start ecosystem.config.json --only HelloWorldNodeJsAgent --watch
- pm2 stop ecosystem.config.json
