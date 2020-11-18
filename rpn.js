#!/usr/bin/env node

const chalk = require('chalk');
const boxen = require('boxen');

const greeting = chalk.white.bold('Welcome to RPN\nThe Reverse Polish Notation Calculator!');

const boxenOptions = {
  padding: 1,
  margin: 1,
  borderStyle: 'round',
  borderColor: 'green',
  align: 'center',
};
const msgBox = boxen(greeting, boxenOptions);

function getInputs() {
  console.log(msgBox);
}
