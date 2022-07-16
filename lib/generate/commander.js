import { program } from "commander";

import chalk from "chalk";

function list() {
  console.log(chalk.red.bold("hello world"));
}

program.command("list").description("List all the TODO tasks").action(list);

program.parse();
