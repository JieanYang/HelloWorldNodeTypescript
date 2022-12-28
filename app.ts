// import http from "http";
import express, { Request, Response, NextFunction } from "express";

// const hostname = "127.0.0.1";
const app = express();
const port = 3000;

// * Use http package
// const server = http.createServer((req: any, res: any) => {
//   res.statusCode = 200;
//   res.setHeader("Content-Type", "text/plain");
//   res.end("Hello World");
// });
// server.listen(port, hostname, () => {
//   console.log(`Server running at http://${hostname}:${port}/`);
// });

app.get("/", (req: Request, res: Response, next: NextFunction) => {
  res.status(200).json("Hello Wordl !");
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
