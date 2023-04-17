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
