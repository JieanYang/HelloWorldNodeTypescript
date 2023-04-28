import * as dotenv from "dotenv";
dotenv.config();

import { spawn } from "child_process";
import express, { Request, Response, NextFunction } from "express";
import schedule from "node-schedule";
import os from "os";
import { RIndex } from "./src/routes/RIndex";
import { RAWS } from "./src/routes/RAWS";

import swaggerJsDoc from "swagger-jsdoc";
import swaggerUi from "swagger-ui-express";
import { RAgent } from "./src/routes/RAgent";

// const hostname = "127.0.0.1";
const app = express();
const port = 8080;
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

const prefix = "/node";

const swaggerOptions = {
  definition: {
    openapi: "3.0.0",
    info: {
      title: "APIs HelloWorldNodeTypescript",
      description: "API HelloWorldNodeTypescript informations",
      version: "1.0.0",
    },
    servers: [{ url: prefix }],
  },
  apis: ["./src/routes/**/*.ts"],
};
const swaggerDocs = swaggerJsDoc(swaggerOptions);
app.use(`${prefix}/api-docs`, swaggerUi.serve);
app.use(`${prefix}/api-docs`, swaggerUi.setup(swaggerDocs));

// ================== Use http package - start ==================
// const server = http.createServer((req: any, res: any) => {
//   res.statusCode = 200;
//   res.setHeader("Content-Type", "text/plain");
//   res.end("Hello World");
// });
// server.listen(port, hostname, () => {
//   console.log(`Server running at http://${hostname}:${port}/`);
// });
// ================== Use http package - end ==================

app.use(prefix, RIndex);
app.use(`${prefix}/aws`, RAWS);
app.use(`${prefix}/agent`, RAgent);

// ================== Get info about the OS - start ==================
app.get(`${prefix}/os`, (req: Request, res: Response, next: NextFunction) => {
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
// ================== Get info about the OS - end ==================

// ================== Run scripts - start ==================
app.get(
  `${prefix}/spwan`,
  (req: Request, res: Response, next: NextFunction) => {
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
  }
);

app.get(`${prefix}/run`, (req: Request, res: Response, next: NextFunction) => {
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
// ================== Run scripts - end ==================

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});

schedule.scheduleJob("*/15 * * * * *", function () {
  console.log("running a task every 15 second");
});
