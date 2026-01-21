function cli(...args) {
  console.log({ args });
  const { spawn } = require("child_process");
  const path = require("path");

  const script = spawn("sh", [
    `${path.join(__dirname, "scripts", "main.sh")}`,
    ...args
  ]);

  script.stdout.pipe(process.stdout);
}

module.exports = {
  cli
};
