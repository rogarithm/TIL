# interface vs abstract - 상태 관점에서 차이점

java tutorial에서 [abstract class 문서](https://docs.oracle.com/javase/tutorial/java/IandI/abstract.html)와 [interface 문서](https://docs.oracle.com/javase/tutorial/java/IandI/createinterface.html)를 찾아봤다.

## abstract class

- 객체를 만들 수는 없지만, concreteClass extends abstractClass와 같이 쓸 수 있다.
- X can be subclassed라고 하면 aClass extends X와 같이 X 클래스를 쓸 수 있다는 말과 같다. 이때 aClass를 subclass라고 하고, X를 superclass라고 한다.
- 구현부가 없는 메서드와 구현부가 있는 메서드 모두 선언할 수 있다. 이때 구현부가 없는 메서드를 abstract method라고 하고, 구현부가 있는 메서드를 non-abstract method라고 한다.
(interface 내부 메서드 중 default나 static으로 선언되지 않은 것은 암시적으로 abstract이다. 그래서 그러한 interface methods에는 abstract modifier를 붙이지 않는다.)
- abstract class를 상속하는 클래스는 보통 abstract class의 모든 abstract method를 구현한다. 만일 아니라면 그 클래스는 abstract로 선언해야 한다.

abstract class와 interface는 비슷한 점을 갖는다:
- abstract class는 abstract method와 non-abstract method 둘 다 선언할 수 있다.
- interface는 구현부가 없는 method와 (구현부를 갖는) default method를 선언할 수 있다.
- abstract class와 interface 둘 다 객체를 만들 수 없다.

하지만 field 선언에서는 abstract class와 interface 사이에 차이가 있다:
- abstract class에서 non-static field나 non-final field를 선언할 수 있고, public(뿐 아니라) protected, private한 [concrete method](https://docs.oracle.com/javase/specs/jls/se13/html/jls-8.html#jls-8.4.3.1)(abstract하지 않은 메서드)를 선언할 수 있다.
- 반면 interface에서 모든 field는 자동적으로 public, static, final이고, 모든 method (선언하거나 default method로 정의하는) 는  public이다.
- interface의 경우 aClass implements interfaceA, interfaceB, ...와 같이 한 클래스에서 여러 개의 interface를 구현할 수 있는 반면, abstract class의 경우 aClass extends abstractClassA와 같이 한 클래스에서 하나의 abstract class만 확장할 수 있다.

문서에서는 abstract class와 interface 둘 중 abstract class는 다음과 같은 경우 사용할 수 있다고 한다:
- You want to share code among several closely related classes
: 서로 긴밀하게 연관된 클래스 사이에서 공유할 코드를 원할 경우
- You expect that classes that extend your abstract class have many common methods or fields, or require access modifiers other than public (such as protected and private)
: abstract class를 확장하는 클래스가 공통으로 갖는 메서드나 필드가 많거나, public 이외의 접근 제한자가 필요할 때
- You want to declare non-static or non-final fields. This enables you to define methods that can access and modify the state of the object to which they belong
: static하지 않거나 final하지 않은 필드 선언이 필요할 때. 해당 필드가 속한 객체의 상태에 접근하거나 상태를 변경할 수 있도록 해준다

'상태 관점'에서 상태는 field를 의미하므로 이것과 연관지어 생각해봤을 때, interface와 abstract class의 상태 관점에서 차이점은:
- abstract class는 static이 아니거나 final이 아닌 field(instance variable or class variable)를 선언할 수 있다. 반면 interface의 field는 항상 static하다. 상태로의 접근을 조절할 수 있어야 한다면 abstract class를 상속하는 것이, interface를 구현하는 모든 클래스에서 접근 가능해도 상관 없다면 interface를 사용하는 것이 좋을 것 같다.
