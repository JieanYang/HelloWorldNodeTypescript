import { Router } from 'express';
import { getMockOperationCommand, receiveOperationCommandResult } from '../controllers/CAWS';

export const RBackend = Router();

/**
 * @openapi
 * tags:
 *   name: Backend
 *   description: Backend routes
 */

/**
 * @openapi
 * /v2/agent/getOperationCommand:
 *  get:
 *      description: Get new command from backend
 *      tags:
 *          - Backend
 *      responses:
 *          '200':
 *              description: Success
 *          '400':
 *              description: Missing parameters
 *          '500':
 *              description: Error
 */
RBackend.route('/v2/agent/getOperationCommand').get(getMockOperationCommand);

/**
 * @openapi
 * /v2/agent/receiveOperationCommandResult:
 *  post:
 *     description: Receive operation command result from backend
 *     tags:
 *         - Backend
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
RBackend.route('/v2/agent/receiveOperationCommandResult').post(receiveOperationCommandResult);
