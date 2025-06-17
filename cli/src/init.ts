import { Command } from "commander";
import fs from "node:fs";
import path from "node:path";
import { logger } from './utils/helpers';

// @ts-expect-error: Command is imported as a type but used as a value
export const initCommand = new Command().name("init")
  .description("Initialize a new zopio project")
  .action(() => {
    const cwd = process.cwd();
    const pkg = path.join(cwd, "package.json");
    if (fs.existsSync(pkg)) {
      logger.warning("A project already exists here.");
      return;
    }
    fs.writeFileSync(pkg, JSON.stringify({ name: "zopio-app", version: "0.1.0" }, null, 2));
    logger.success("Initialized zopio project.");
  });
