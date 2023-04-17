import { Router } from "express";

export const RAgent = Router();

RAgent.route("/receiveHearbeat").get((req, res) => {
  res.status(200).json("OK");
});

RAgent.route("/receivePSKKey").get((req, res) => {
  res.status(200).json("OK");
});

RAgent.route("/receiveCommandResult").get((req, res) => {
  res.status(200).json("OK");
});
