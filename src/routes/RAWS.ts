import { Router } from "express";
import { home } from "../controllers/Cindex";
import { createVM } from "../controllers/CAWS";

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
 *  get:
 *      description: Get one page by id
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

RAWS.route("/createVM").get(createVM);
// RAWS.route("/getNewCommand").get(createVM);
