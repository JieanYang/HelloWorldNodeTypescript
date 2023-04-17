import { Router } from "express";
import { home } from "../controllers/Cindex";

export const RIndex = Router();

RIndex.route("/").get(home);
