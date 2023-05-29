// AWS SDK for JavaScript: https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/index.html

import { Request, Response, NextFunction } from 'express';
import {
  EC2Client,
  RunInstancesCommand,
  RunInstancesCommandInput,
  _InstanceType,
  EC2ClientConfig,
} from '@aws-sdk/client-ec2';
import {
  S3Client,
  S3ClientConfig,
  ListBucketsCommand,
  GetObjectCommand,
  GetObjectCommandInput,
} from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { AwsCredentialIdentity } from '@aws-sdk/types';

import fs from 'fs';
import path from 'path';
import btoa from 'btoa';
import { randomBytes } from 'crypto';

interface IOperationCommandResult {
  id: string;
  vmId: number;
  operationCommand: string;
  status: string;
  operationScript: string;
  operationResult: {
    returnCode: number | null;
    stdOut: string | null;
    stdErr: string | null;
  };
  tryTimes: number;
}

export const createVM = async (req: Request, res: Response, next: NextFunction) => {
  const { os } = req.body;

  let scriptSetuporiginMetadataContent: string, scriptSetupAgentContent: string;
  let awsInput: RunInstancesCommandInput | null = null;

  const newPSKKeyBuffer = randomBytes(32); // generate 32 bytes of random data
  const newPSKKeyString = newPSKKeyBuffer.toString('hex'); // convert to hex format

  if (os === 'Linux') {
    scriptSetuporiginMetadataContent = fs.readFileSync(
      path.join(__dirname, '../../scripts/2023-05-11-setup_linux_key.sh'),
      'utf8'
    );
    scriptSetupAgentContent = fs.readFileSync(
      // path.join(__dirname, "../../scripts/setup_linux.sh"),
      path.join(__dirname, '../../scripts/2023-05-15-HelloWorldGoOsService_setup_linux.sh'),
      'utf8'
    );
    awsInput = {
      ImageId: 'ami-02b01316e6e3496d9',
      InstanceType: _InstanceType.t3_nano,
      SecurityGroupIds: ['sg-0f3299071dcdce83e'],
      SubnetId: 'subnet-0c8782d18d92c563d',
      MinCount: 1,
      MaxCount: 1,
      KeyName: 'awsResearch',
      UserData: btoa(`
      ${scriptSetuporiginMetadataContent.replace('${PSK_KEY_GENERATED_BY_BACKEND}', newPSKKeyString)}
  
      ${scriptSetupAgentContent.replace('#!/bin/bash', '')}
      `), // convert string to base64
    } as RunInstancesCommandInput;
  } else if (os === 'Windows') {
    scriptSetuporiginMetadataContent = fs.readFileSync(
      path.join(__dirname, '../../scripts/2023-05-11-setup_windows_key.ps1'),
      'utf8'
    );
    scriptSetupAgentContent = fs.readFileSync(
      // path.join(__dirname, "../../scripts/setup_windows.ps1"),
      path.join(__dirname, '../../scripts/2023-05-10-HelloWorldGoOsService_setup_windows.ps1'),
      'utf8'
    );
    awsInput = {
      ImageId: 'ami-09650503efc8d2335',
      InstanceType: _InstanceType.t2_micro,
      SecurityGroupIds: ['sg-0f3299071dcdce83e'],
      SubnetId: 'subnet-0c8782d18d92c563d',
      MinCount: 1,
      MaxCount: 1,
      KeyName: 'awsResearch',
      UserData: btoa(`
          ${scriptSetuporiginMetadataContent.replace('${PSK_KEY_GENERATED_BY_BACKEND}', newPSKKeyString)}
      
          ${scriptSetupAgentContent.replace('#!/bin/bash', '')}
          `), // convert string to base64
    } as RunInstancesCommandInput;
  }

  const credentialConfig: AwsCredentialIdentity = {
    accessKeyId: process.env.ACCESS_KEY_ID as string,
    secretAccessKey: process.env.SECRET_ACCESS_KEY as string,
  };

  const ec2ClientConfig: EC2ClientConfig = {
    credentials: credentialConfig,
    region: 'eu-west-3',
  };

  const client = new EC2Client(ec2ClientConfig);
  const command = new RunInstancesCommand(awsInput as RunInstancesCommandInput);
  const response = await client.send(command);

  res.status(200).json(response);
};

export const getMockOperationCommand = async (req: Request, res: Response, next: NextFunction) => {
  // This line will be the codes to get the script form locale, remote like S3 bucket or payload service in the future
  const scriptContent = fs.readFileSync(
    // OS - Linux scripts
    path.join(__dirname, '../../scripts/2023-04-27-hello-world.sh'), // Run success scripts
    // path.join(__dirname, "../../scripts/2023-05-02-hello-world-with-error.sh"), // with error scripts
    // OS - Windows scripts
    // path.join(__dirname, "../../scripts/2023-04-28-hello-world.ps1"), // Run success scripts
    // path.join(__dirname, "../../scripts/2023-05-02-hello-world-with-error.ps1"), // with error scripts
    'utf8'
  );

  res.status(200).json({
    result: {
      id: 'abcdefg12345687-guid',
      operationCommand: 'LIST_USERS',
      status: 'OPERATION_WAITING', // "OPERATION_IN_PROGRESS" | "OPERATION_COMPLETE" | "OPERATION_FAILED"
      operationScript: scriptContent,
      operationResult: {
        returnCode: null,
        stdOut: null,
        stdErr: null,
      },
      tryTimes: 0, // max: 3
    } as IOperationCommandResult,
  });
};

export const receiveOperationCommandResult = async (req: Request, res: Response, next: NextFunction) => {
  const {} = req.body as { result: IOperationCommandResult };
  console.log('req.body', req.body);

  res.status(200).send('OK');
};

export const getS3BucketList = async (req: Request, res: Response, next: NextFunction) => {
  const credentialConfig: AwsCredentialIdentity = {
    accessKeyId: process.env.ACCESS_KEY_ID as string,
    secretAccessKey: process.env.SECRET_ACCESS_KEY as string,
  };

  const s3ClientConfig: S3ClientConfig = {
    credentials: credentialConfig,
  };

  const s3Client = new S3Client(s3ClientConfig);

  const command = new ListBucketsCommand({});

  const response = await s3Client.send(command);

  console.log('response', response);

  res.status(200).send({ Results: response });
};

export const getS3BucketObjectSignedUrl = async (req: Request, res: Response, next: NextFunction) => {
  const credentialConfig: AwsCredentialIdentity = {
    accessKeyId: process.env.ACCESS_KEY_ID as string,
    secretAccessKey: process.env.SECRET_ACCESS_KEY as string,
  };

  const s3ClientConfig: S3ClientConfig = {
    credentials: credentialConfig,
  };

  const s3Client = new S3Client(s3ClientConfig);

  const input: GetObjectCommandInput = {
    Bucket: 'ansys-gateway-development-private',
    Key: 'first_script.sh',
  };
  const command = new GetObjectCommand(input);
  const url = await getSignedUrl(s3Client, command, { expiresIn: 3600 });

  res.status(200).send({ Results: url });
};
