import { Router } from 'express';
import { createVM, getMockOperationCommand, getS3BucketList, receiveOperationCommandResult } from '../controllers/CAWS';

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
RAWS.route('/createVM').post(createVM);

/**
 * @openapi
 * /aws/getMockOperationCommand:
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
RAWS.route('/getMockOperationCommand').get(getMockOperationCommand);

/**
 * @openapi
 * /aws/receiveOperationCommandResult:
 *  post:
 *     description: Receive operation command result from agent
 *     tags:
 *         - AWS
 *     requestBody:
 *       content:
 *          application/json:
 *              schema:
 *                  type: object
 *                  properties:
 *                      id:
 *                          type: string
 *                          default: abcdefg12345687-guid
 *                      vmId:
 *                          type: Integer
 *                          default: 10
 *                      operationCommand:
 *                          type: string
 *                          default: LIST_USERS
 *                      status:
 *                          type: string
 *                          default: OPERATIONS_WAITING
 *                      operationResult:
 *                          type: object
 *                          properties:
 *                             returnCode:
 *                                 type: Integer
 *                                 default: 200
 *                             stdOut:
 *                                type: string
 *                                default: "Hello world"
 *                             stdErr:
 *                                type: string
 *                                default: ""
 *     responses:
 *         '200':
 *             description: Success
 *         '400':
 *             description: Missing parameters
 *         '500':
 *             description: Error
 */
RAWS.route('/receiveOperationCommandResult').post(receiveOperationCommandResult);

/**
 * @openapi
 * /aws/getS3BucketList:
 *  post:
 *     description: getS3BucketList
 *     tags:
 *         - AWS
 *     requestBody:
 *       content:
 *          application/json:
 *              schema:
 *                  type: object
 *                  properties:
 *                      fileName:
 *                          type: string
 *                          default: first_script.sh
 *     responses:
 *         '200':
 *             description: Success
 *         '400':
 *             description: Missing parameters
 *         '500':
 *             description: Error
 */

RAWS.route('/getS3BucketList').post(getS3BucketList);
