// AWS SDK for JavaScript: https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/index.html

import { Request, Response, NextFunction } from "express";
import {
  EC2Client,
  RunInstancesCommand,
  RunInstancesCommandInput,
  _InstanceType,
} from "@aws-sdk/client-ec2";
import { AwsCredentialIdentity } from "@aws-sdk/types";

const createVM = async (req: Request, res: Response, next: NextFunction) => {
  const input: RunInstancesCommandInput = {
    ImageId: "ami-02b01316e6e3496d9",
    InstanceType: _InstanceType.t3_nano,
    // keyName: [myKeyPair],
    SecurityGroupIds: ["sg-903004f8"],
    SubnetId: "subnet-6e7f829e",
    MinCount: 1,
    MaxCount: 1,
  };

  const config: AwsCredentialIdentity = {
    accessKeyId: "",
    secretAccessKey: "",
  };

  const client = new EC2Client(config);
  const command = new RunInstancesCommand(input);
  const response = await client.send(command);

  console.log("createVM response", response);

  res.status(200).json("Create VM");
};
