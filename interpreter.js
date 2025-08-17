const $scope = {} //global  scope
const $$scope = [] // local scope stack
$$scope.push($scope);
const $getCurrentScope = () => $$scope[$$scope.length-1]

class LispCallable {
    call(args) { throw "Not implemented" }
}

class BuiltinCallable extends LispCallable {
    constructor(fn) {
        super();
        this.fn = fn; // fn: function(inputs[]) → result
    }

    call(inputs = []) {
        return this.fn(inputs);
    }
}

class Definition {
    constructor(name) {
        this.name = name;
    }

    define() {
        const scope = $getCurrentScope();
        this.defineInScope(scope);
    }

    defineInScope(scope) {
        throw new Error('Not implemented');
    }
}

class DefineVar extends Definition {
    constructor(name, expr) {
        super(name);
        this.expr = expr;
    }

    defineInScope(scope) {
        if (this.name in scope) {
            throw new Error(`Variable already defined: ${this.name}`);
        }
        scope[this.name] = this.expr;
    }
}

class DefineFunction extends Definition {
    constructor(name, args, definitions, expressions) {
        super(name);
        this.args = args;
        this.definitions = definitions;
        this.expressions = expressions;
    }

    defineInScope(scope) {
        scope[this.name] = new UserFunction(this.name, this.args, this.definitions, this.expressions);
    }

}

class UserFunction extends LispCallable {
    constructor(name, args, definitions, expressions){
        super();
        this.name = name;
        this.args = args;
        this.definitions = definitions;
        this.expressions = expressions;
        this.scope = Object.create($getCurrentScope());
        $$scope.push(this.scope);
        this.definitions.forEach(definition => definition.define());
        this.args.forEach(arg => {
            this.scope[arg] = { call: () => { throw new Error(`Unbound argument: ${arg}`); } };
        });
        $$scope.pop();
    }
    call(inputs){
        let scope = Object.create($getCurrentScope());
        this.definitions.forEach(definition => {
            definition.defineInScope(scope);
        });

        this.args.forEach((arg, i) => {
            scope[arg] = {call: () => inputs[i]};
        });
        $$scope.push(scope);
        let result = this.expressions.reduce((acc, x) => x.call(), null);
        $$scope.pop();
        return result;
    }
}

module.exports = {
    BuiltinCallable,
    DefineVar,
    DefineFunction,
    $getCurrentScope
};