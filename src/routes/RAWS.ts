import { Router } from "express";
import { home } from "../controllers/Cindex";
import { createVM } from "../controllers/CAWS";

export const RAWS = Router();

RAWS.route("/createVM").get(createVM);
// RAWS.route("/getNewCommand").get(createVM);
