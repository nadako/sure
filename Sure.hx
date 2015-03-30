#if macro
import haxe.macro.Expr;
using haxe.macro.Tools;
#end

@:dce
class Sure {
    public static macro function sure(expr:Expr, exprs:Array<Expr>):Expr {
        return process([expr].concat(exprs));
    }

    #if macro
    static function process(exprs:Array<Expr>) {
        var asserts:Array<Expr> = [];
        for (e in exprs) {
            switch (e.expr) {
                case EBlock(el):
                    for (e in el)
                        asserts.push(makeAssert(e));
                default:
                    asserts.push(makeAssert(e));
            }
        }
        return macro $b{asserts};
    }

    static function makeAssert(e:Expr):Expr {
        return switch (e.expr) {
            case EBinop(OpEq, e1, e2):
                macro @:pos(e.pos) {
                    var actual = $e1, expected = $e2;
                    if (actual != expected) throw "FAIL: values are not equal (expected: " + expected + ", actual: "  + actual + ")";
                };
            case EMeta({name: "throws", params: asserts}, body):
                macro @:pos(e.pos) {
                    var thrown = false;
                    try {
                        $body;
                    } catch (_:Dynamic) {
                        thrown = true;
                        ${process(asserts)};
                    }
                    if (!thrown)
                        throw "Exception not thrown";
                }
            default:
                macro @:pos(e.pos) if (!($e : Void)) throw $v{"FAIL: " + e.toString()}
        }
    }
    #end
}
