// Grammar for a part of LISP
// ==========================
//
//
{
    const {BuiltinCallable, DefineFunction, DefineVar, $getCurrentScope} = require('./interpreter.js');
}


S =(_ evaluated:(expr:Expression{return expr.call()}
    / def:Definition {def.define(); return def}) _ {return evaluated}) *

_ "whitespace or comment"
  = (Whitespace / Comment)*

__  = (Whitespace / Comment)+

Whitespace = [ \t\n\r]+
Comment = ";" [^\n\r]* ("\n" / "\r" / !.)

Alph = [a-z,A-Z]

Keyword = "define" / "if" / "else" / "cond"
BuiltinFunctionStr = ("car" / "cdr" / "cons" / "list" / "append" / "eq" / "equal" / "length"
                       / "map" / "apply" / "display" / "abs"
                       / "+" / "-" / "*" / "/" / ">" / "<" / ">=" / "<=" / "=")
BuiltinStr = Keyword / BuiltinFunctionStr / Constant

True = "#t" {return true;}
False = "#f" {return false;}
Boolean = True / False
Null = "'()" / "null"
Constant = Boolean / Null

Identifier = !(BuiltinStr ((!.)/__))[_]*Alph(Alph/[_,-]/[0-9]/"?")* {return text()}

Integer "integer"
  = _ [0-9]+ { return parseInt(text(), 10); }
SignedInteger
  = _ sign:("+" / "-") _ int:Integer { return sign === "-" ? -int : int; }
Int = Integer / SignedInteger

Float = Int"." [0-9]+ {return parseFloat(text(), 10);}
Numeric = Float / Int
String = "\"" symbols:[^"]* "\"" {return symbols.reduce((res, char) => res+char, "")}

ArithmeticFunction
    = "("_ operation:("+" / "-" / "*" / "/" / "div" / "quotient" / "mod" / "remainder" / "modulo")
         _ init:Expression _ rest:MayBeExpressions  _ ")"{
       const opMap = {
                 "+": (a, b) => a + b,
                 "-": (a, b) => a - b,
                 "*": (a, b) => a * b,
                 "/": (a, b) => a / b,
                 "div": (a, b) => Math.trunc(a / b),
                 "quotient":(a, b) => Math.trunc(a / b),
                 "mod":     (a, b) => a % b,
                 "remainder": (a, b) => a % b,
                 "modulo":  (a, b) => ((a % b) + b) % b,
               };
           return new BuiltinCallable(() => rest.map((expr) => expr.call()).reduce(opMap[operation], init.call()));
    }

ArithmeticComparison
= "("_ operator:( ">=" / "<=" / ">" / "<" / "=" / "/=")  _ init_expr:Expression
     _ rest:Expressions _ ")" {
         return new BuiltinCallable( function (){
                const init = init_expr.call();
                return rest.map((expr) => expr.call())
                            .reduce( (acc, x) =>
                                {switch (operator){
                                    case "<" : return acc && (init < x);
                                    case ">" : return acc && (init > x);
                                    case "=" : return acc && (init == x);
                                    case "<=" : return acc && (init <= x);
                                    case ">=" : return acc && (x <= init);
                                    case "/=" : return acc && (init != x);
                          }}, true);
             });

    }
Expressions = (_ expr:Expression _ {return expr;})+
MayBeExpressions = (_ expr:Expression _ {return expr;})*

ABS
= "(" _ "abs"   _ expr:Expression _ ")" {
         return new BuiltinCallable(() => Math.abs(expr.call()));
    }


If = "("_ "if" _ cond_expr:Expression _ then_expr:Expression _ else_expr:Expression _ ")" {
    return new BuiltinCallable(() => cond_expr.call() ? then_expr.call() : else_expr.call());
}

Display = "(" _ "display" _ expr:Expression _ ")" {
    return new BuiltinCallable(() => {
        const value = expr.call();
        console.log(value);
        return value; // по канону display возвращает свой аргумент
    });
}


BuiltinFunctionCall = ArithmeticFunction / ArithmeticComparison / ABS / If / Display
ConstExpr = value:(Float / Int /  String / Boolean / Null) { return {call: () => value} }
Expression = ConstExpr / idx:Identifier {return { call: () => $getCurrentScope()[idx].call() };}
            / BuiltinFunctionCall  / FunctionCall

MayBeDefinitions = (_ def:Definition _ {return def;})*
Definition
    = "("_ "define" _ defined:(DefineVar / DefineFunction)  _ ")" {return defined}

DefineVar = name:Identifier _ expr:Expression _{
    return new DefineVar(name, expr);
}

Args = (_ arg:Identifier _ {return arg})*

DefineFunction = "(" _ name:Identifier _ args:Args _ ")"
                _ definitions:MayBeDefinitions
                _ exprs:Expressions _ {
                    return new DefineFunction(name, args, definitions, exprs);
                    }

FunctionCall = "("_ name:Identifier _ args:MayBeExpressions _ ")" {
    return {call: () => {
        let func = $getCurrentScope()[name];
        let inputs = args.map((x) => x.call());
        return func.call(inputs);
        }}
}
