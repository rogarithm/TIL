# interface vs abstract - 상태 관점에서 차이점

java tutorial에서 [abstract class 문서](https://docs.oracle.com/javase/tutorial/java/IandI/abstract.html)와 [interface 문서](https://docs.oracle.com/javase/tutorial/java/IandI/createinterface.html)를 찾아봤다.


#### \* sub class vs super class?
- 문서에서 subclass와 superclass 관련 용어가 자주 나왔다. 정확한 의미를 몰라 내용 이해가 잘 안되는 것 같아 알아봤다.
- subclass는 superclass를 확장하는 클래스고, superclass는 subclass의 확장 기반이 되는 클래스다.
- X can be subclassed의 뜻은 aClass extends X와 같이 X 클래스를 쓸 수 있다는 것이다.
- aClass extends X에서 aClass를 subclass, X를 superclass라고 부른다.

### abstract class
- 객체를 만들 수는 없지만, concreteClass extends abstractClass와 같이 다른 클래스가 abstract class를 확장할 수 있다.
- abstract class 안에 구현부가 없는 메서드와 구현부가 있는 메서드를 선언할 수 있다. 여기서 구현부가 없는 메서드를 abstract method, 구현부가 있는 메서드를 non-abstract method라고 한다.
- abstract class를 상속하는 클래스는 보통 abstract class의 모든 abstract method를 구현한다. 만일 구현하지 않는 abstract method가 있다면, 그 클래스(abstract class를 상속하는)는 abstract class로 선언해야 한다.

#### \* 참고: interface 안 method signature는 구현부가 없는데 왜 abstract를 안붙이나?
- interface 안 구현부가 없는 메서드에 abstract를 붙이지 않는 점이 abstract class 안 abstract method에 abstract를 명시하는 것과 상충된다는 생각이 들 수 있다.
- interface 내부 메서드 중 default나 static으로 선언되지 않은 것은 암시적으로 abstract이기 때문에 interface methods에는 abstract modifier를 붙이지 않아도 abstract method로 인식된다.
- interface 안 abstract method에도 abstract modifier를 붙여도 상관없다

### interface와 abstract class의 비교

abstract class와 interface는 이런 점에서 비슷하다
- 구현부가 없는 메서드와 구현부를 갖는 메서드를 선언할 수 있다. abstract class는 abstract method와 non-abstract method, interface는 method signature와 default method를 선언할 수 있다.
- abstract class와 interface 둘 다 인스턴스를 만들 수 없다.

abstract class와 interface는 이런 점에서 다르다
- abstract class에서 non-static field나 non-final field를 선언할 수 있다. 반면 interface에서 모든 field는 자동적으로 public, static, final로 선언된다.
- abstract class에서 메서드를 선언할 때 public(뿐 아니라) protected, private [concrete method](https://docs.oracle.com/javase/specs/jls/se13/html/jls-8.html#jls-8.4.3.1)(abstract하지 않은 메서드)로 선언할 수 있다. 반면 interface의 모든 method(선언하거나 default method로 정의하는)는 public이다.
- 한 클래스에서 여러 개의 interface를 구현할 수 있다(ex. aClass implements interfaceA, interfaceB, ...). 반면 한 클래스에서 하나의 abstract class만 확장할 수 있다(ex. aClass extends abstractClassA)

### 언제 어떤 걸 사용하나?

문서에서는 abstract class와 interface 중 어떤 쪽을 고를 지에 대한 기준을 설명하고 있다.

abstract class를 사용하려고 할 경우
> \- You want to share code among several closely related classes<br>
> \- You expect that classes that extend your abstract class have many common methods or fields, or require access modifiers other than public (such as protected and private)<br>
> \- You want to declare non-static or non-final fields. This enables you to define methods that can access and modify the state of the object to which they belong<br>

- 서로 긴밀하게 연관된 클래스 사이에서 공유할 코드를 원할 경우<br>
- abstract class를 확장하는 클래스가 공통으로 갖는 메서드나 필드가 많거나, public 이외의 접근 제한자가 필요할 때<br>
- static하지 않거나 final하지 않은 필드 선언이 필요할 때. 해당 필드가 속한 객체의 상태에 접근하거나 상태를 변경할 수 있도록 해준다<br>

interface를 사용하려고 할 경우
> \- You expect that unrelated classes would implement your interface.<br>
> \- You want to specify the behavior of a particular data type, but not concerned about who implements its behavior.<br>
> \- You want to take advantage of multiple inheritance of type.<br>

- 관련 없는 클래스가 interface를 구현할 것이 예상되는 경우<br>
- 특정 데이터 타입의 행위를 특정하고 싶지만, 누가 그 행위를 구현할지는 상관 없는 경우<br>
- 다중 상속의 잇점을 취하고 싶은 경우<br>

### 상태 관점에서 생각해봤을 때, interface와 abstract class의 차이점은:
- abstract class는 static이 아니거나 final이 아닌 field를 선언할 수 있다. 반면 interface의 field는 항상 static하게 선언된다.<br>
- abstract class의 경우 어떤 상태는 누구나 접근할 수 있고 어떤 상태는 접근 가능한 클래스를 제한할 수 있다. 반면 interface의 상태는 언제나 모든 클래스에서 접근 가능하다.<br>
- 하지만 구체적으로 어떤 차이를 갖는지 명확하지 않다. 이러한 상황을 보여주는 예시를 찾을 수 있으면 좋을 것 같다.
