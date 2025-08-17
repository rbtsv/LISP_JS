# LISP_JS

A minimal LISP-like (Scheme-style) **parser-interpreter** built in JavaScript using [Peggy](https://github.com/peggyjs/peggy).

This project is intended **for educational purposes** — to demonstrate how Parsing Expression Grammars (PEG) work, and how to build a simple interpreter or language runtime from scratch.  
It’s a great starting point for students learning about parsing, interpretation, or language design.

It supports variables, function definitions, arithmetic, scoping, and basic built-ins — enough to compute things like Newton's method or run recursive functions.

---

## 🚀 Usage

```bash
node run_LISP.js <program.lsp> [--silent]
```

- `<program.lsp>` — path to your Lisp file.
- `--silent` — optional flag to suppress output.

Or use the [online Peggy editor](https://peggyjs.org/online.html):  
Paste the [one-file PEG grammar](./LISP_full.pegjs) in the left form, and your code in the right.

---

## 🧪 Example

```lisp
(define (square x) (* x x))
(display (square 5)) ; 25

(define (fact n)
  (if (= n 0)
      1
      (* n (fact (- n 1)))))
(display (fact 5)) ; 120
```

See more examples in the [examples](./examples) folder.

---

## 📦 Installation

```bash
git clone https://github.com/rbtsv/LISP_JS.git
cd LISP_JS
npm install
```

Build the parser (optional):

The parser (parser.js) is already prebuilt, but you can regenerate it if you modify the grammar.

```bash
node build_parser.js
```

Run test program:

```bash
node run_LISP.js examples/Newton.scm
```

---

## ✅ Features

- `define` for variables and functions
- `if` expressions
- Arithmetic: `+ - * / div mod remainder quotient`
- Built-ins: `abs`, `display`
- Proper scoping with stack-based environment
- First-class user-defined functions
- PEG grammar (Peggy)
- Support for comments (`; this is a comment`)

---

## 📁 Project Structure

```
LISP_JS/
│
├── interpreter.js       # Interpreter logic (scope, evaluation, functions)
├── LISP.pegjs           # PEG grammar (modular)
├── LISP_full.pegjs      # One-file grammar for online interpreter
├── parser.js            # Auto-generated parser (do not edit manually)
├── build_parser.js      # Script to regenerate parser.js
├── run_LISP.js          # Entry point to run Lisp programs
├── examples/            # Sample .lsp programs
└── package.json
```

---

## 📚 References

- [Structure and Interpretation of Computer Programs (SICP)](https://web.mit.edu/6.001/6.037/sicp.pdf)  
 The `Newton.scm` example in this repo is adapted from SICP.  
 Highly recommended if you're learning LISP or want to understand the foundations of (functional) programming .

- [Theory and Realization of Programming Languages (lectures in Russian)](https://github.com/rbtsv/TRPL25)  
  Авторский курс по теории языков программирования и интерпретации. Содержит материалы, примеры и ссылки для изучения.


---

## 📜 License

Licensed under the [MIT License](https://opensource.org/licenses/MIT).
Use it, fork it, break it, improve it.  
Built for tinkerers and students exploring the internals of programming languages.