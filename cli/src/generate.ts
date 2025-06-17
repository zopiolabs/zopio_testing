import { Command } from "commander";
import fs from 'node:fs';
import path from 'node:path';
import { logger } from './utils/helpers';

// @ts-expect-error: Command is imported as a type but used as a value
export const generateCommand = new Command().name("generate")
  .description("Generate a new zopio module")
  .argument("type", "core | addon | data")
  .argument("name", "module name")
  .action((type, name) => {
    const base = `packages/${type}/${name}`;
    if (fs.existsSync(base)) {
      logger.warning("Module already exists.");
      return;
    }
    fs.mkdirSync(base, { recursive: true });
    fs.writeFileSync(
      path.join(base, "index.ts"),
      `// ${name} module for ${type}\nexport const ${name} = () => { logger.info("${name} module"); };\n`
    );
    logger.success(`Created ${type}/${name}`);
  });
