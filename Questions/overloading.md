## Q1. 언제 Overloading이라고 하나?

**자바의 신에서는 메서드명이 같고 매개 변수가 다를 때 overloading이라고 한다. 리턴 타입이나 접근 제한자에 대한 조건은 없는지 의문이 들었다.**

### 자료 조사

[oracle java tutorial](https://docs.oracle.com/javase/tutorial/java/javaOO/methods.html)에서 overloading에 대해 설명하는 문서를 찾아봤다.

관련된 주요 내용은 다음과 같다.

> ... This means that methods within a class can have the same name if they have different parameter lists...

> Overloaded methods are differentiated by the number and the type of the arguments passed into the method.

> You cannot declare more than one method with the same name and the same number and type of arguments, because the compiler cannot tell them apart.

> The compiler does not consider return type when differentiating methods, so you cannot declare two methods with the same signature even if they have a different return type.

각 내용을 살펴보면:
1. 같은 클래스 안에서 서로 다른 매개변수 목록을 갖는 메서드 여러 개는 메서드 이름이 서로 같아도 된다.
2. overload 메서드를 구분하는 기준은 메서드로 넘기는 매개변수의 갯수와 타입이다.
3. 이름, 매개변수 갯수, 타입이 같은 메서드는 하나만 선언할 수 있다. 컴파일러가 그런 메서드를 구분할 수 없기 때문이다.
4. 컴파일러는 메서드를 구분할 때 리턴 타입은 생각하지 않는다. 그래서 두 메서드의 리턴 타입이 다르더라도 **method signature**(하단 설명 참조)가 같다면 선언할 수 없다.

정리하면:
- 메서드 이름이 같고 매개변수 갯수와 타입이 달라야 메서드를 overload할 수 있다.
- 하지만 이 조건이 성립되고 리턴 타입이 다른 메서드를 overload 메서드라고 할 수 있을지는 확실히 알 수 없었다.
- 생각해볼 수 있는 조건에 따라 테스트를 해보기로 했다.

#### method signature

메서드의 구성 요소 중 메서드 이름과 매개변수 타입

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

### 테스트

기존에 알고 있는 overload 메서드 조건은 유지하고 리턴 타입을 다르게 해봤다.
- 리턴 타입은 같고 매개변수 리스트는 다를 때 (기존의 overload 조건)
- 매개변수 리스트가 다르고 리턴 타입도 다를 때 (리턴 타입을 변경)

#### 1. 리턴 타입은 같고 매개변수 리스트는 다를 때

```java
package questions;

public class Test {
	public static void main(String[] args) {
		Test test = new Test();
	}

	public void printWords(String str) {
	}

	public void printWords(double d, int i) {
	}
}
```

컴파일 결과: 에러 없음


#### 2. 매개변수 리스트가 다르고 리턴 타입도 다를 때
```java
package questions;

public class Test {
	public static void main(String[] args) {
		Test test = new Test();
	}

	public void printWords(String str) {
	}

	public String printWords(String str, int i) {
		return new String();
	}
}
```

컴파일 결과: 에러 없음

### 결론
- 테스트해보니 컴파일러가 리턴 타입을 생각하지 않는다는 말은 메서드 이름, 매개변수 타입이 같으면 리턴 타입이 달라도 같은 메서드로 본다는 의미였던 것 같다.
- 따라서 메서드 이름, 매개변수 타입이 동일하고 리턴 타입이 다른 여러 메서드는 사용할 수 없다.
- 반면 메서드 이름이 동일하고 매개변수 타입과 리턴 타입이 여러 메서드는 사용할 수 있다. 다시 말해 기존 overload 기준에 리턴 타입을 다르게 사용해도 괜찮다.
- 여전히, 기존 overload 조건에 더해 리턴 타입이 다를 경우도 overload로 생각할 수 있는지는 모르겠다.
- 또한 리턴 타입이 다르게 overload를 사용하는 실사용 예가 있는지 살펴봐야 할 것 같다.

### 더 보기
- 자바 명세에서 [overloading을 설명하는 문서](https://docs.oracle.com/javase/specs/jls/se8/html/jls-8.html#jls-8.4.9) 읽어보기
- Overloading 실사용 예 살펴보고 리턴 타입이 다른 경우가 있는지 조사하기
