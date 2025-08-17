const peggy = require("peggy");
const fs = require("fs");

const grammar = fs.readFileSync("LISP.pegjs", "utf8"); // <-- заменили имя файла

try {
    const parser = peggy.generate(grammar, {
        output: "source",
        format: "commonjs"
    });

    fs.writeFileSync("parser.js", parser);
    console.log("✅ Parser generated as parser.js");
} catch (e) {
    console.error("❌ Error generating parser:");
    console.error(e.message);
    process.exit(1);
}
