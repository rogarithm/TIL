## 참조 타입의 형변환

### 기본 타입의 형변환 - 형 변환이 가능한지 책에서 설명하는 판단 기준을 직관적으로 이해할 수 있었다
* 좁은 범위 -> 넓은 범위: int에서 long으로 변환할 때, long이 더 넓은 범위를 갖는 타입이므로, 데이터 유실 위험이 없다. 따라서 암시적인 형 변환이 가능하다.
* 넓은 범위 -> 좁은 범위: long에서 int으로 변환할 때, int가 더 좁은 범위를 갖는 타입이므로, long에서 int로 형 변환을 하면 데이터 유실 위험이 있다. 따라서 명시적으로 형 변환을 해줘야 한다.

### 참조 타입의 형변환 - 책에서 설명하는 형 변환의 기준이 잘 이해되지 않았다

* **공통 전제** - Child가 sub class, Parent가 super class일 때
```java
public class Child extends Parent {
	public Child() {
	}

	public Child(String name) {
	}

	public void printName() {
		System.out.println("printName() - Child");
	}

	public void printAge() {
		System.out.println("printAge() - I'm 18 month");
	}
}
```
```java
public class Parent {
	public Parent() {
	}

	public Parent(String name) {
	}

	public void printName() {
		System.out.println("printName() - Parent");
	}
}
```
1. sub class type에서 super class type으로 형 변환
`Parent parent = new Child();`: 가능하다

2. super class type에서 sub class type으로 형 변환<br>
* 다음과 같이 하면 컴파일부터 불가능하다.<br>
```java
Parent parent = new Parent();
Child child = parent;
```
* 다음과 같이 하면 컴파일 에러는 뜨지 않지만, 실행 에러가 뜬다. 따라서 불가능하다.<br>
```java
Parent parent = new Parent();
Chile child = (child) parent;
```
* 다음과 같이 하면 가능하다. 즉, parent2는 사실 child 타입이어야 한다는 것이다.<br>
```
Child child = new Child();
Parent parent = child;
Child child2 = (Child) parent;
```

### 왜 참조 타입의 형변환 동작 방식이 이해가 안되는가?
* 내가 생각하기에 참조 타입 sub class와 super class의 차이는 어떤 동작(메서드)을 가지는가, 가지지 않는가 이다.<br>
* sub class는 super class와 비교해서 동작을 overriding하거나 새로운 메서드를 정의해 더 많이 갖고있지 않나. 그러면 범위가 넓다고 봐야 하지 않나.<br>
* 기본 타입에서는 범위가 좁은 타입을 범위가 상대적으로 넓은 타입으로 변경하는 것이 형변환 없이 가능했으니 super class를 sub class로 형변환하는 것이 가능해야 맞지 않나.<br>
* 이러한 생각을 가졌고, 자바 명세에서는 어떻게 설명하고 있는지 궁금해졌다.<br>


## 형변환 관련 자바 명세
java language specification 5. conversions and promotions에서 참조 타입에 적용할 수 있는 conversion은 다음과 같다.<br>
* widening reference conversions(jls 5.1.5): 
* narrowing reference conversions
* casting conversion
* assignment context

### widening reference conversions (jls 5.1.5)
> A widening reference conversion exists from any reference type S to any reference type T, provided S is a subtype (jls 4.10) of T.<br>

참조 타입 S를 참조 타입 T로 '넓히는 변환'은 S가 T의 subtype(또는 T가 S의 supertype)이어야 가능하다. 즉 T = S -> super = sub.<br>

### narrowing reference conversions (jls 5.1.6)
> From any reference type S to any reference type T, provided that S is a proper supertype of T (jls 4.10).<br>

* 참조 타입 S를 참조 타입 T로 '줄이는 변환'은 S가 T의 supertype(또는 T가 S의 subtype)이어야 가능하다. 즉 T = S -> sub = super<br>
* 클래스 이외에 인터페이스나 배열 타입에도 적용할 수 있는 규칙이 있다.<br>

> Such conversions require a test at run time to find out whether the actual reference value is a legitimate value of the new type. If not, then a ClassCastException is thrown.<br>

* 좁은 변환은 실제 참조값이 변환된 타입 기준 유효한 값인지 실행 시간 테스트를 필요로 한다. 아니면 ClassCastException를 내뱉는다.

### casting conversion (jls 5.5)
다음 두 conversion이 참조 타입과 연관되어 있다:<br>

> a widening reference conversion (§5.1.5) optionally followed by either an unboxing conversion (§5.1.8) or an unchecked conversion (§5.1.9)<br>
> a narrowing reference conversion (§5.1.6) optionally followed by either an unboxing conversion (§5.1.8) or an unchecked conversion (§5.1.9)<br>

* widening reference conversion은 별다른 casting 없이도 가능하지만 명시적으로 casting할 수도 있는 것 같다.<br>
* unboxing conversion과 unchecked conversion이 연관될 수도 있으나 필수는 아닌 것 같다.<br>

### reference type casting (jls 5.5.1)
* 두 참조 타입 T와 S에 casting conversion을 적용하려고 할 때 (compile-time error를 내지 않게 하려면) 지켜야 할 규칙을 설명한다.
* 기호를 이해할 수 없다.
* 어디 나오는지 찾아봐야 한다.

### assignment context (jls 5.2)
* 참조 타입 변환이 포함된 예시가 잘 나와있다.
* 자바의 신에서 나온 상황 중 이해가 안되는 상황에 대한 설명도 있는데 설명이 잘 이해가 안갔다.
* 다음에 좀 더 읽어보기.

### Example 5.2-2. (Edited)

```java
class Point { int x, y; }
class Point3D extends Point { int z; }
interface Colorable { void setColor(int color); }

class ColoredPoint extends Point implements Colorable {
    int color;
    public void setColor(int color) { this.color = color; }
}

class Test {
    public static void main(String[] args) {
        // Assignments to variables of class type:
        Point p = new Point();
        p = new Point3D();
          // OK because Point3D is a subclass of Point
        Point3D p3d = p;
          // Error: will require a cast because a Point
          // might not be a Point3D (even though it is,
          // dynamically, in this example.)

        Point3D[] p3da = new Point3D[3];
        Point[] pa = p3da;
          // OK: since we can assign a Point3D to a Point
        p3da = pa;
          // Error: (cast needed) since a Point
          // can't be assigned to a Point3D
    }
}
```

```java
class Point { int x, y; }
interface Colorable { void setColor(int color); }
class ColoredPoint extends Point implements Colorable {
    int color;
    public void setColor(int color) { this.color = color; }
}

class Test {
    public static void main(String[] args) {
        Point p = new Point();
        ColoredPoint cp = new ColoredPoint();
        // Okay because ColoredPoint is a subclass of Point:
        p = cp;
        // Okay because ColoredPoint implements Colorable:
        Colorable c = cp;
        // The following cause compile-time errors because
        // we cannot be sure they will succeed, depending on
        // the run-time type of p; a run-time check will be
        // necessary for the needed narrowing conversion and
        // must be indicated by including a cast:
        cp = p;    // p might be neither a ColoredPoint
                   // nor a subclass of ColoredPoint
        c = p;     // p might not implement Colorable
    }
}
```
