# Immutable Objects(불변 객체)

### 개념
- 생성 후 상태를 바꿀 수 없는 객체

### 왜 사용하나?
* 가능한 불변 객체를 많이 사용하는 건 다수가 동의하는 단순하고 믿을만한 코드를 짜기 위한 전략이다.
* 객체가 불변 객체일 경우, 상태를 바꿀 수 없기 때문에 동시성 어플리케이션에서 특히 유용하다:
  + thread interference에 의해 여러 객체가 충돌할 위험이 없다.
  + 일관적이지 않은 상태가 관찰될 염려가 없다.
* (불변 객체)를 새로 만드는 데 드는 비용이 객체를 업데이트하는 것보다 크다고 생각해서 불변 객체를 쓰길 주저하는 경우가 있다. 그러나 객체 생성의 영향(비용)은 과대 평가되는 경우가 많고, 그런 영향도 불변 객체를 사용해서 얻는 효과로 상쇄될 수 있다. 이러한 예로 다음 두 가지를 들 수 있다:
  + decreased overhead due to garbage collection (**Q1**에서 설명)
  + 가변 객체가 충돌하지 않도록 방지하는 코드를 더이상 작성하지 않아도 된다. (the elimination of code needed to protect mutable objects from corruption)
* **가변 객체**(mutable object) 생성 후 객체 상태를 불러오는 때를 생각했을 때, 상태를 불러오기 전 (예를 들어 다른 쓰레드가) 객체를 변경하게 되면 의도하지 않은 상태값을 받게 될 위험이 있다. 불변 객체 사용으로 이런 위험을 피할 수 있다.

#### \* Q1. decreased overhead due to garbage collection이 무슨 의미인가?<br>

immutable object 관련 [oracle java article](https://blogs.oracle.com/javamagazine/post/java-immutable-objects-strings-date-time-records)을 찾아봤다:
> The notion of re-creating an object may seem frightening (or at least frighteningly inefficient) to those raised on JavaBeans—but remember that almost every release of the JDK improves performance. The engineers who advance the JDK work particularly hard on fast object creation and garbage collection. The result is that **creation and re-creation**, especially **of short-lived data objects** such as those that live only inside a method call, **are very fast** nowadays.<br>

불변 객체를 사용하면 가변 객체를 사용할 때보다 객체를 더 많이 만들게 된다. 그래서 이렇게 만들어진 객체를 생성하고 지우는 GC에 들어가는 비용(overhead)가 높지만, GC 과정이 점점 더 빨라지고 있고, 따라서 GC에 들어가는 overhead가 줄어들기 때문에 불변 객체 사용으로 더 많은 객체를 만들더라도 비용이 그렇게 커지지 않을 거라는 의미인 것 같다.<br>

### java에선 불변 객체를 어떻게 정의하나?
1. 클래스를 만들 때 (필드를 변경하거나 필드에 의해 참조되는 객체를 변경하는) setter 메서드를 만들지 않는다.
2. 모든 필드를 final private 필드로 만든다.
3. subclass(불변 객체 클래스를 상속하는 클래스)가 (불변 객체 클래스의) 메서드를 override하지 않도록 한다. 가장 간단한 방법은 클래스를 final로 선언(해서 다른 클래스가 상속할 수 없도록) 하는 것이다.
  + 3-1. 아니면 생성자의 접근 권한을 private로 하고 클래스 인스턴스는 **factory 메서드**에서 생성하도록 할 수도 있다.
4. 인스턴스 필드가 가변 객체에 대한 참조를 포함한다면, 다음과 같은 방법으로 그 객체가 바뀌지 않도록 한다:
  + 4-1. 가변 객체를 변경하는 메서드를 제공하지 않는다.
  + 4-2. 가변 객체에 대한 참조를 공유하지 않는다. 생성자에 전달되는 **external, mutable objects**에 대한 참조를 저장하지 않는다; 가변 객체를 참조해야 한다면 객체 복사본을 만들고, 이 복사본에 대한 참조를 저장한다. 비슷하게, 필요한 때 **internal mutable objects**에 대한 복사본을 만들어서 내 메서드에서 원본을 반환하는 것을 피한다.

#### \* Q2. factory 메서드는 무엇인가? 이 메서드가 클래스 인스턴스를 만드는 역할을 갖는다면, 생성자와 어떤 차이를 갖는가?<br>
#### \* Q3. external, mutable object와 internal mutable object가 무슨 의미인가?<br>

#### 참고한 문서
https://docs.oracle.com/javase/tutorial/essential/concurrency/immutable.html
https://docs.oracle.com/javase/tutorial/essential/concurrency/syncrgb.html
https://docs.oracle.com/javase/tutorial/essential/concurrency/imstrat.html
