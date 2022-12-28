import express, { Request, Response, NextFunction } from "express";
import schedule from "node-schedule";
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
  const osCpus: os.CpuInfo[] = os.cpus().map((cpuItem) => {
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
    osArch: os.arch(),
    osPlatform: os.platform(),
    // osContants: os.constants,
    osCpus,
    osTotalmem: os.totalmem() * Math.pow(10, -9) + " GB", // bytes to GB
    osFreemem: os.freemem() * Math.pow(10, -9) + " GB", // bytes to GB
  };
  console.log("/os results", results);

  res.status(200).json({ results });
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});

schedule.scheduleJob("*/15 * * * * *", function () {
  console.log("running a task every 15 second");
});
