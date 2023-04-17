import { Router } from "express";
import { home } from "../controllers/Cindex";

const router = Router();

router.route("/").get(home);

export default router;
