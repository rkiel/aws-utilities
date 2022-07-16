import { program } from "commander";

import { cognito } from "./subcommands/cognito.js";

import chalk from "chalk";

function list() {
  console.log(chalk.red.bold("hello world"));
}

program.command("cognito").description("Generate AWS Cognito").action(cognito);

program.parse();
