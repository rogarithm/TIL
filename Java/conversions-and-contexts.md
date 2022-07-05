### 5.6.2. binary numeric promotion
연산자가 피연산자 쌍에 binary numeric promotion를 적용하면, 각각은 numeric type으로 변환될 수 있는 값을 나타내야 한다. 다음 법칙이 적용된다:
1. 참조 타입인 피연산자에는 unboxing conversion(5.1.8)이 적용된다
2. 기본 타입을 widening하는 것은 피연산자 중 하나나 모두를 변환하기 위해 적용된다. 다음 규칙을 따른다:
 피연산자 중 하나가 double 타입이면 다른 피연산자는 double로 변환된다
 그렇지 않고 두 피연산자 중 하나가 float 타입이면 다른 피연산자는 float로 변환된다
 그렇지 않고 피연산자 중 하나가 long 타입이면 다른 피연산자는 long으로 변환된다
 그렇지 않으면 두 피연산자는 int 타입으로 변환된다
타입 변환 후, 각 피연산자에 value set conversion이 일어난다.
binary numeric promotion이 특정 연산자의 피연산자에 일어난다:

### 5.1.7 boxing conversion
기본타입 expression을 그에 맞는 참조타입 expression으로 변환한다.
boolean -> Boolean
byte -> Byte
short -> Short
...
null type -> null type <- 조건 연산자(x ? y : z)에서 피연산자에 boxing conversion을 적용해 그 결과를 이후 계산에 쓰기 때문에 null type에 대한 조건이 필요하다
실행 시간에서, boxing conversion은 다음과 같이 진행된다:
p가 boolean 타입의 값인 경우, boxing conversion은 p를 Boolean 클래스와 타입의 참조 r로 변환한다. r.booleanValue() == p가 될 수 있도록.

### 5.1.8 unboxing conversion
참조타입 expression을 그에 맞는 기본타입 expression으로 변환한다.
Boolean -> boolean
Byte -> byte
Short -> short
...
실행 시간에서, unboxing conversion은 다음과 같이 진행된다:
r이 Boolean 타입의 참조인 경우, unboxing conversion은 r을 r.booleanValue()로 변환한다
r이 Integer 타입의 참조인 경우, unboxing conversion은 r을 r.integerValue()로 변환한다

타입이 numeric type이거나 unboxing conversion에 의해 numeric type으로 변환될 수 있는 참조 타입일 경우, 해당 타입을 numeric type으로 변환할 수 있다고 한다(convertible to a numeric type).
타입이 integeral type이거나 unboxing conversion에 의해 integral type으로 변환될 수 있는 참조 타입일 경우, 해당 타입을 integral type으로 변환할 수 있다고 한다(convertible to a integral type).

### 5.1.3 narrowing primitive conversion
"기본 타입을 자신보다 작은 데이터 범위를 갖는 다른 기본 타입으로 변환하는 것"
기본 타입에 대한 22가지 변환을 narrowing primitive conversion이라고 한다
short to byte or char
char to byte or short
int to byte, short, or char
long to byte, short, char, or int
float to byte, short, char, int, or long
double to byte, short, char, int, long, or float
변환하면 원래 값으로부터 정보를 잃을 수 있다: overall magnitude of a numeric value, precision, range.

