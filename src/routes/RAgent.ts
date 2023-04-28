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
 *  post:
 *     description: agent reveive PSK key
 *     tags:
 *         - Agent
 *     requestBody:
 *       content:
 *          application/json:
 *              schema:
 *                  type: object
 *                  properties:
 *                      key:
 *                          type: string
 *     responses:
 *         '200':
 *             description: Success
 *         '400':
 *             description: Missing parameters
 *         '500':
 *             description: Error
 */
RAgent.route("/receivePSKKey").post((req, res) => {
  const { key } = req.body;
  res.status(200).json({ results: key });
});

RAgent.route("/receiveCommandResult").get((req, res) => {
  res.status(200).json("OK");
});
