## Q1. 자바의 신 108p에서 나온 변수에 대한 참조가 무슨 의미인가?
책에서는 `++` 단항 연산자의 두 경우(`++var`와 `var++`)를 비교하면서 계산하는 시기와 변수를 참조하는 시기가 차이난다고 설명한다.<br>

여기서 다음 의문이 들었다:<br>
- 공식 문서에서는 참조(reference)를 객체를 향하는 포인터로 정의한다. 책에서 `var`은 `int`값을 담고 있으므로 기본 타입 값이다. 기본 타입 값은 객체가 아닌데 참조라는 단어를 쓸 수 있나?
- 아니면 참조의 대상은 변수이므로, 객체의 범위에 변수도 포함되나?
- 여기서 말하는 참조는 자바 명세에 나와있는 reference와는 다른 것을 말하나?


### 자료 조사
prefix increment expression ([jls 15.15.1](https://docs.oracle.com/javase/specs/jls/se7/html/jls-15.html#jls-15.15.1))
> The value of the prefix increment expression is the value of the variable after the new value is stored.<br>

표현식의 값은 새로운 값이 저장된 후 변수가 가지고 있는 값이다.<br>

postfix increment expression ([jls 15.14.2](https://docs.oracle.com/javase/specs/jls/se7/html/jls-15.html#jls-15.14.2))
> The value of the postfix increment expression is the value of the variable before the new value is stored.<br>

표현식의 값은 새로운 값이 저장되기 전 변수가 가지고 있는 값이다.<br>

### 결론 내기 실패
- 두 연산자는 표현식의 값이 서로 다르다
- 여기까지 알아보고 답이 안나와서 다른 곳을 좀 더 찾아봤다.
postfix increment operator ++([jls 15.14.2](https://docs.oracle.com/javase/specs/jls/se7/html/jls-15.html#jls-15.14.2))

postfix expression의 결과는 numeric type으로 변환 가능한(convertible)* 타입의 변수여야만 한다. 그렇지 않을 경우 compile-time error가 발생한다.
 *타입이 numeric type이거나 unboxing conversion에 의해 numeric type으로 변환할 수 있는 참조타입인 경우를 말한다

postfix increment expression의 타입은 그 변수의 타입이다. postfix increment expression의 결과는 변수가 아니라 값이다.

실행 시간에, operand expression에 대한 평가가 예상치 못하게 완료되면 postfix increment expression도 같은 이유로 예상치 못하게 완료되고 증가는 발생하지 않는다. 그렇지 않다면 변수 값에 1이 더해지고 이 합이 변수로 다시 저장된다. 더해지기 전에, binary numeric promotion이 값 1과 변수값에 일어난다. 필요할 경우, 합은 narrowing primitive conversion이나 boxing conversion에 의해 저장되기 전 변수 타입으로 좁아진다.

- postfix increment operator의 설명을 읽고 binary numeric promotion, boxing conversion, unboxing conversion, narrowing primitive conversion에 대해 알아보고 정리했지만 관련이 없다고 결론지었다. (관련 내용은 모두 Java 디렉토리 및으로 옮겼다)

### 추가 자료 조사
대신 새로운 방향으로 알아보기로 했다. 내가 모르는 다른 것을 생각해봤다.
- 자바 언어는 pass-by-value 언어라고 한다.
- 표현식이나 표현식의 값이 무슨 의미를 갖는지 모른다
- 예제에서는 ++ 단항 연산자를 적용한 변수를 메서드의 매개변수로 사용하고 있다.

책에서 단항 연산자를 사용한 예제를 덧붙이면 다음과 같다.
public class OperatorIncrement {
	public static void main(String[] args) {
		OperatorIncrement operator = new OperatorIncrement();
		operator.increment();
	}

	public void increment() {
		int intValue=1;
		System.out.println(intValue++);
		System.out.println(intValue);
		System.out.println(++intValue);
	}
}

jls 15.1
표현식은 평가된다. 그 결과는 다음 세 가지 중 하나다.
변수, 값, void expression

표현식 평가의 결과로 side effect를 만들어낼 수도 있다.

jls 15.2
표현식이 변수를 나타내고, 추가 평가를 하기 위해 값이 필요한 경우, 그 변수의 값이 사용된다.
System.out.println(intValue++); 에서 intValue는 변수지만, System.out.println 메서드가 자신의 역할을 수행하려면 intValue의 값이 필요하다. 이때 (아직 정확히 모르므로) intValue가 표현식이라고 하면, System.out.println은 intValue의 값을 사용한다.
책에서는 이 맥락에서 '값을 참조한다' 라고 서술한 것 같다.

jls 15.5
>If the type of an expression is a primitive type, then the value of the expression is of that same primitive type.

intValue의 타입은 기본 타입인 int이므로 표현식의 값 또한 같은 기본 타입 int이다.
