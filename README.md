# Sure!

This is a very small assertion tool for writing tests for Haxe.

## Sure, but why?

I don't like existing assertion frameworks because they are either simply annoying to write (e.g. `assertGreaterThan`)
or trying to pretend they are your dumb friend (e.g. `expect(v).to.be(1)` and stuff).

From my experience, in a unit test, I really just need to do some stuff and then check for results and I believe
that it's very natural for a programmer to write assertions like they would write an `if` expression.

And thanks to Haxe macros, we could analyze given expressions and print a nice assertion failure for it.

## An example?

I want it to be short and straight to the point, so I intend to use it like this:
```haxe
import Sure.sure;

class Main {
    static function main() {
        var a = 1, b = 2;
        sure(a == 1, b == 1); // throws "FAIL: values are not equal (expected: 1, actual: 2)"
    }
}
```

It also supports assertion blocks:
```haxe
var a = 1, b = 2;
sure({
    a == 1;
    b == 2;
});
```

And some sugar for checking for exception throw:
```haxe
sure(@throws sure(false));
```
The catched exception is available as `_` identifier and you can add additional checks as parameters for `@throws`:
```haxe
sure(@throws(_.indexOf("FAIL: ") == 0) sure(1 == 2));
```
