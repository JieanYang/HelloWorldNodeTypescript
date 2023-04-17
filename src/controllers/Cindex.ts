import { Request, Response, NextFunction } from "express";

export const home = (req: Request, res: Response, next: NextFunction) => {
  console.log("Hit home page !");
  res.status(200).json("Hello World ! in router");
};
