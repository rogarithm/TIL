## Q1. 언제 Overloading이라고 하나?

**자바의 신에서는 설명하는 overloading의 조건으로 메서드명이 같고 매개 변수가 다른 것을 들고 있다. 하지만 생각해볼 수 있는 다른 조건들은 어떻게 해야하는지 의문점이 들었다.**

###

관련 공식 문서 중 [oracle java tutorial](https://docs.oracle.com/javase/tutorial/java/javaOO/methods.html)에서 overloading을 설명하는 문서를 찾아봤다.

> ... This means that methods within a class can have the same name if they have different parameter lists...

클래스 안 여러 개의 메서드가 갖는 매개변수 리스트가 서로 다를 경우, 이러한 메서드는 서로 같은 이름을 가질 수 있다.

> Overloaded methods are differentiated by the number and the type of the arguments passed into the method. 

여러 개의 overload 메서드는 메서드로 넘기는 매개변수의 갯수와 타입으로 구분된다.

> You cannot declare more than one method with the same name and the same number and type of arguments, because the compiler cannot tell them apart.

이름이 같고 매개변수 갯수와 타입이 같은 메서드는 하나 이상 선언할 수 없다. 컴파일러가 그런 메서드를 구분할 수 없기 때문이다.

> The compiler does not consider return type when differentiating methods, so you cannot declare two methods with the same signature even if they have a different return type.

컴파일러가 메서드를 구분할 때 리턴 타입은 생각하지 않기 때문에 서로 다른 리턴 타입을 가지고 같은 method signature를  가지는 메서드 두 개를 선언할 수 없다.

### method signature

메서드의 구성 요소 중 메서드 이름과 매개변수 타입을 합친 것을 말한다.

```java
public double calculateAnswer(double wingSpan, int numberOfEngines,
                              double length, double grossTons) {
    //do the calculation here
}
```

위 메서드의 method signature은 다음과 같다.

```java
calculateAnswer(double, int, double, double)
```

- 정리하면 메서드 이름이 같고 매개변수 갯수와 타입이 달라야 메서드를 overload할 수 있다.
- 하지만 이 조건이 성립되고 리턴 타입이 다른 메서드를 overload 메서드라고 할 수 있을지를 이 문서에서 알 수는 없었다.

### 테스트

public class Test {
	public static void main(String[] args) {
		UseStringMethods useStringMethods = new UseStringMethods();
	}

	public void printWords(String str) {
	}

	public String printWords(String str) {
		return new String();
	}
}

error: method printWords(String) is already defined in class Test
	public String printWords(String str) {
	              ^
1 error

컴파일러가 리턴 타입을 생각하지 않는다:
메서드 이름, 매개변수 타입이 같으면 리턴 타입이 달라도 같은 메서드로 본다.
따라서 메서드 이름, 매개변수 타입을 동일하게 하고 리턴 타입을 다르게 하면 사용할 수 없다.
하지만 메서드 이름을 같게 하고 매개변수 타입과 리턴 타입을 다르게 하면 사용할 수 있다.
그러나 이것의 의미가 무엇인가?

#### 더 보기
자바 명세에서 [overloading을 설명하는 문서](https://docs.oracle.com/javase/specs/jls/se8/html/jls-8.html#jls-8.4.9) 읽어보기
