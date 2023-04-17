// AWS SDK for JavaScript: https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/index.html

import { Request, Response, NextFunction } from "express";
import {
  EC2Client,
  RunInstancesCommand,
  RunInstancesCommandInput,
  _InstanceType,
  EC2ClientConfig,
} from "@aws-sdk/client-ec2";
import { AwsCredentialIdentity } from "@aws-sdk/types";

export const createVM = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const input: RunInstancesCommandInput = {
    ImageId: "ami-02b01316e6e3496d9",
    InstanceType: _InstanceType.t3_nano,
    // keyName: [myKeyPair],
    SecurityGroupIds: ["sg-0f3299071dcdce83e"],
    SubnetId: "subnet-0c8782d18d92c563d",
    MinCount: 1,
    MaxCount: 1,
  };

  const credentialConfig: AwsCredentialIdentity = {
    accessKeyId: process.env.ACCESS_KEY_ID as string,
    secretAccessKey: process.env.SECRET_ACCESS_KEY as string,
  };

  const ec2ClientConfig: EC2ClientConfig = {
    credentials: credentialConfig,
    region: "eu-west-3",
  };

  const client = new EC2Client(ec2ClientConfig);
  const command = new RunInstancesCommand(input);
  const response = await client.send(command);

  res.status(200).json(response);
};
