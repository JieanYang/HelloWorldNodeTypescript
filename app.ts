import { spawn } from "child_process";
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
    osRelease: os.release(),
    // osContants: os.constants,
    osUptime: os.uptime() / 60 / 60, // From second to hour
    osHostname: os.hostname(),
    osUserInfo: os.userInfo(),
    osVersion: os.version(),
    osHomedir: os.homedir(),
    osTmpdir: os.tmpdir(),
    osCpus,
    osNetworkInterfaces: os.networkInterfaces(),
    osLoadavg: os.loadavg(),
    osTotalmem: os.totalmem() * Math.pow(10, -9) + " GB", // Bytes to GB
    osFreemem: os.freemem() * Math.pow(10, -9) + " GB", // Bytes to GB
  };
  console.log("/os results", results);

  res.status(200).json({ results });
});

app.get("/spwan", (req: Request, res: Response, next: NextFunction) => {
  console.log("hit /spwan");
  // const ls = spawn("ls", ["-lh", "/usr"]);
  const ls = spawn("ls", ["-lh"]);

  ls.stdout.on("data", (data) => {
    console.log(`stdout: ${data}`);
  });

  ls.stderr.on("data", (data) => {
    console.error(`stderr: ${data}`);
  });

  ls.on("close", (code) => {
    console.log(`child process exited with code ${code}`);
  });

  res.status(200).json({ results: "OK" });
});

app.get("/run", (req: Request, res: Response, next: NextFunction) => {
  console.log("hit /run");
  const ls = spawn("./2022-12-22-first_script.sh", [], { cwd: "scripts" });

  ls.stdout.on("data", (data) => {
    console.log(`stdout: ${data}`);
  });

  ls.stderr.on("data", (data) => {
    console.error(`stderr: ${data}`);
  });

  ls.on("close", (code) => {
    console.log(`child process exited with code ${code}`);
  });

  res.status(200).json({ results: "OK" });
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});

schedule.scheduleJob("*/15 * * * * *", function () {
  console.log("running a task every 15 second");
});
