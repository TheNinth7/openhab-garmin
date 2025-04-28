/*
import Toybox.Lang;

class A {
    public static function doSomething() as Void {
        throw new AbstractMethodException( "A.doSomething" );
    } 
    public static function doMore() as Void {
        doSomething();
    }
}

class B extends A {
    public static function doSomething() as Void {
        // this is what should get done
    } 
}

class C {
    public function doItAll() as Void {
        B.doMore();
    }
}
*/