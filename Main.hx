import Sure.sure;

class Main {
    static function main() {
        var a = 1, b = 2;
        sure({
            a == 1;
            b == 2;
            @throws cast(a, String);
        });
    }
}
