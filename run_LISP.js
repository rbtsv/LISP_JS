// run_lisp.js
const fs = require('fs');
const parser = require('./parser.js');

const args = process.argv.slice(2);
let filename = null;
let silent = false;

for (const arg of args) {
    if (arg === '--silent') {
        silent = true;
    } else if (!filename) {
        filename = arg;
    } else {
        console.error(`Unknown argument: ${arg}`);
        process.exit(1);
    }
}

if (!filename) {
    console.error('Usage: node run_lisp.js <file.scm> [--silent]');
    process.exit(1);
}

const source = fs.readFileSync(filename, 'utf8');

try {
    const result = parser.parse(source);

    if (!silent) {
        console.log('=== Program Result ===');
        console.log(result);
    }

} catch (e) {
    console.error('❌ Error during parsing or execution:');
    console.error(e.message);
    process.exit(1);
}
