import { Router } from "express";

export const RAgent = Router();

/**
 * @openapi
 * tags:
 *   name: Agent
 *   description: Agent routes
 */

RAgent.route("/receiveHearbeat").get((req, res) => {
  res.status(200).json("OK");
});

/**
 * @openapi
 * /agent/receivePSKKey:
 *  get:
 *     description: agent reveive PSK key
 *     tags:
 *         - Agent
 *     responses:
 *         '200':
 *             description: Success
 *         '400':
 *             description: Missing parameters
 *         '500':
 *             description: Error
 */
RAgent.route("/receivePSKKey").get((req, res) => {
  res.status(200).json("OK");
});

RAgent.route("/receiveCommandResult").get((req, res) => {
  res.status(200).json("OK");
});
