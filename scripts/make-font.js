#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const readline = require("readline");

let sizeOf;
try {
  sizeOf = require("image-size");
} catch (error) {
  console.error('run "npm install image-size" before');
  process.exit(-1);
}

if (process.argv.length <= 2) {
  const execName = path.basename(process.argv[1]);
  console.log(`Usage: ${execName} folder-containing-images`);
  process.exit(-2);
}

const folder = process.argv[2];
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

askPrefix(rl, folder, prefix => {
  const files = fs.readdirSync(folder).map(file => path.join(folder, file));
  buildFont(rl, prefix, files, font => {
    rl.close();
    const target = `${folder}.json`;
    console.log(`Writing font to ${target}`);
    fs.writeFileSync(target, JSON.stringify(font, undefined, 2));
  });
});

function askPrefix(rl, folder, cb) {
  const defaultPrefix = `https://s3.amazonaws.com/tboeassets/fonts/${path.basename(
    folder
  )}`;
  rl.question(
    `Prefix used in url images (default: ${defaultPrefix})?`,
    prefix => {
      prefix.trim();
      if (prefix.length <= 0) {
        prefix = defaultPrefix;
      }
      if (prefix.substring(prefix.length - 1, prefix.length) == "/") {
        prefix = prefix.slice(0, -1);
      }
      cb(prefix);
    }
  );
}

function buildFont(rl, prefix, fileList, cb, font) {
  font = font || {};
  if (!fileList || fileList.length <= 0) {
    cb(font);
    return;
  }
  const file = fileList.shift();
  sizeOf(file, (err, size) => {
    if (err) {
      buildFont(rl, prefix, fileList, cb, font);
      return;
    }
    rl.question(`Character for ${file}?`, char => {
      font[char] = {
        src: `${prefix}/${path.basename(file)}`,
        width: size.width,
        height: size.height
      };
      buildFont(rl, prefix, fileList, cb, font);
    });
  });
}
