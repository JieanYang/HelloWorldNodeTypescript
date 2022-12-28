import express, { Request, Response, NextFunction } from "express";
import os from "os";

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
  res.status(200).json("Hello World !");
});
app.get("/os", (req: Request, res: Response, next: NextFunction) => {
  let osCpus: os.CpuInfo[] = os.cpus();
  const osTotalmem = os.totalmem();
  const osFreemem = os.freemem();

  osCpus = osCpus.map((cpuItem) => {
    return {
      ...cpuItem,
      times: {
        ...cpuItem.times,
        user: cpuItem.times.user / 1000, // From milliseconds to seconds
        sys: cpuItem.times.sys / 1000, // From milliseconds to seconds
        idle: cpuItem.times.idle / 1000, // From milliseconds to seconds
      },
    };
  });

  const results = {
    osCpus,
    osTotalmem: osTotalmem * Math.pow(10, -9) + " GB", // bytes to GB
    osFreemem: osFreemem * Math.pow(10, -9) + " GB", // bytes to GB
  };
  console.log("/os results", results);

  res.status(200).json({ results });
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
