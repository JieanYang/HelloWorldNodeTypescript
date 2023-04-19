import { Router } from "express";
import { createVM, getNewCommand } from "../controllers/CAWS";

export const RAWS = Router();

/**
 * @openapi
 * tags:
 *   name: AWS
 *   description: AWS routes
 */
/**
 * @openapi
 * /aws/createVM:
 *  post:
 *     description: Post to create a new VM win/linux
 *     tags:
 *         - AWS
 *     requestBody:
 *       content:
 *          application/json:
 *              schema:
 *                  type: object
 *                  properties:
 *                      os:
 *                          type: string
 *                          default: Windows
 *     responses:
 *         '200':
 *             description: Success
 *         '400':
 *             description: Missing parameters
 *         '500':
 *             description: Error
 */
RAWS.route("/createVM").post(createVM);

/**
 * @openapi
 * /aws/getNewCommand:
 *  get:
 *      description: Get new command from backend
 *      tags:
 *          - AWS
 *      responses:
 *          '200':
 *              description: Success
 *          '400':
 *              description: Missing parameters
 *          '500':
 *              description: Error
 */
RAWS.route("/getNewCommand").get(getNewCommand);
