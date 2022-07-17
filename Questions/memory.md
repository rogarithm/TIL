## Q1. 데이터는 메모리 중 어디에 저장되는가?

1. class variable, instance variable은 heap에 저장된다
> **All instance fields, static fields**, and array elements are stored in heap memory. (jls 17.4.1)

2. local variable, parameter는 stack에 저장된다<br>
- 공식 문서에서 찾지 못했다. local variable과 parameter가 유효한 범위가 메서드 안이라서 stack에 저장된다고 생각했다.

3. class instance(object)는 heap에 저장된다
> The Java Virtual Machine has a heap that is shared among all Java Virtual Machine threads. **The heap** is the run-time data area from which memory for **all class instances** and arrays is allocated. (jvms 2.5.3)

4. class는 method area에 저장된다
> It stores **per-class structures** such as the run-time constant pool, **field and method data, and the code for methods and constructors**, including the special methods (§2.9) used in class and instance initialization and interface initialization.(jvms 2.5.4)

5. 기본 타입 변수는 stack에 저장된다
6. 참조 타입 변수는 heap에 저장된다

### Q1 질문은 두 가지 면에서 모호하며, 각 의문에 대한 답이 필요하다.
- 첫째로, 데이터 종류가 class, class instance, variable 세 가지로 분류되는지, 각 데이터 종류 별로 어떤 것을 저장하는지 명확하지 않다.
- 둘째로, Q1 질문에 대한 답 중 기본 타입 변수과 참조 타입 변수가 저장되는 곳이 각각 stack과 heap이 맞는지 확실하지 않다.


## Q1-1. 데이터 종류에는 어떤 것이 있으며, 각 데이터 종류 별로 어떤 것을 저장하는가?
**예상한 것**
- 데이터의 종류는 class, class instance, variable, value일 것이다.
- 데이터 종류 별로 다음과 같은 것이 저장될 것이다:
- class: 필드, 메서드, 생성자
- class instance: 생성된 class instance에 대한 정보. 필드값이 초기화되었다면 어떤 건지, 메서드에 접근할 수 있는 권한, 
- variable과 value는 어떤 데이터를 담는지 모른다.

## Q1-1-1. SO에서 [variable vs object vs reference](https://stackoverflow.com/questions/32010172/what-is-the-difference-between-a-variable-object-and-reference) 질문을 읽어봤다. Jon Skeet에 의하면,
- variable은 value를 가지고 있을 수 있지만, variable이 value 자체가 아니다.
- 다른 value로 variable이 가지고 있는 value를 바꿀 수 있다.
- 참조는 주소와 같다. 객체는 아니지만, 객체에 어떻게 접근하는지 알려준다.
- object는 집과 같다. 동일한 object를 향하는 참조는 여러 개 있을 수 있지만, 그 참조가 가리키는 object는 단 하나만 존재한다.

- variable은 메모리 상 저장 공간의 위치를 나타낸다. `int x = 12;` 에서와 같이 기본 타입 value를 가지고 있을 수도 있고, `Dog myDog = new Dog();` 에서와 같이 참조를 가지고 있을 수도 있다. 이때 새로 만들어진 `Dog` class instance를 `myDog` variable에 할당하지 않는다. 이 class instance를 가리키는 주소(즉, 참조)를 할당한다.
- variable이나 expression의 값은 절대로 object가 아니다. object를 가리키는 참조다. 참조는 object에 접근하기 위해 사용되는 value다. 접근한다는 건 object의 메서드를 호출하거나 필드에 접근하는 것 등을 말한다.

이로부터 유추해보면, 메모리에 저장되는 데이터 종류는 class, class instance, variable인 것 같다. value는 어떤 것을 저장하는 것이라기보다는 variable에 저장되는 것이라고 하는 편이 맞는 것 같다. 또 variable type에 따라 기본 타입 value를 저장하거나  참조 타입 값을 저장할 수 있다.


## Q1-2. 기본 타입 변수는 stack에, 참조 타입 변수는 heap에 저장되는 것이 맞는가?
- Q1 질문에 대한 답 중 기본 타입 변수과 참조 타입 변수가 저장되는 곳이 각각 stack과 heap이 맞는지 확실하지 않다.
- 첫째로, 기본 타입 변수가 stack에 저장된다는 것의 출처는 자바의 신 1권이었다. 정확히는 기본 타입이 stack에 저장된다고 언급되어 있다. 그러나 기본 타입 변수가 인스턴스 변수일 때를 고려했을 때 항상 stack에 저장되는지가 의심된다.
- 둘째로, 참조 타입 변수가 heap에 저장된다는 것의 출처는 없다. 유추해서 내린 결론인데, 조사했을 때 참조 타입 변수가 stack에 저장되지 않는다는 언급을 찾지 못했다. 따라서 참조 타입 변수가 항상 heap에 저장되는지 의심의 여지가 있다.

기본 타입 변수 - stack, 참조 타입 변수 - heap이라는 주장에 대한 반례
1. 기본 타입 변수가 instance variable일 때
instance variable은 객체가 소멸될 때까지 유지된다. 그렇다면 기본 타입이더라도 stack의 주기보다 더 오래 생명이 지속되야 한다고 생각했다. 따라서 stack이 아니라 heap에 저장되야 한다. 이 결론은 기본 타입 변수가 항상 stack에 저장된다는 처음의 생각과 상충된다.
2. 참조 타입 변수가 local variable일 때
참조 타입 변수에는 객체에 대한 참조가 담긴다. local variable이기 때문에 참조 타입 변수가 가지는 참조값(reference)을 다른 참조로 변경하면, 그 변경 사항은 메서드 안에서만 적용된다. 메서드 안에서 참조 타입 변수의 값을 변경하면 그 값은 메서드가 종료되면 사라진다. 그러면 이 경우는 참조 타입 변수더라도 그 value가 heap에 저장된다고 볼 수 없는 것 같다.

따라서 variable의 type에 따라 그 값이 저장되는 메모리 위치가 어디인지를 확정할 수 없다. 그러므로 원래 생각했던 **Q2(변수의 종류와 타입에 따라서 메모리 어디에 저장되나?) 질문**은 유효하지 않은 질문이었다고 결론지었다.

오히려 알아야 할 것은 변수가 기본 타입 값이나 참조 타입 값을 가지고 있을 때, 이 값이 무엇인지였다. Q1-1-1에서 variable, object, reference를 비교하면서 알아본 것에 더해, Java 언어가 pass-by-value 언어라는 것에서 그 답을 찾을 수 있었다.
[SO 답변](https://stackoverflow.com/a/40523)에서 관련 내용을 찾을 수 있었는데,
참조타입 변수에 할당되는 값은 객체 자체가 아니라 객체를 가리키는 참조다. 참조는 객체에 접근할 수 있는 주소와 같은 개념이며, 여기서 접근한다는 말은 객체의 필드값을 가져오거나, 객체의 메서드를 호출하는 등의 행위를 의미한다.

```java
public static void main(String[] args) {
    Dog aDog = new Dog("Max");
    Dog oldDog = aDog;

    // we pass the object to foo
    foo(aDog);
    // aDog variable is still pointing to the "Max" dog when foo(...) returns
    aDog.getName().equals("Max"); // true
    aDog.getName().equals("Fifi"); // false
    aDog == oldDog; // true
}

public static void foo(Dog d) {
    d.getName().equals("Max"); // true
    // change d inside of foo() to point to a new Dog instance "Fifi"
    d = new Dog("Fifi");
    d.getName().equals("Fifi"); // true
}
```

위 코드에서, `Dog aDog = new Dog("Max");`는 `aDog`에 새로 생성한 `Dog` 객체를 할당하는 듯 보이지만(**나는 줄곧 이렇게 생각하고 있었다**), 실제로는 이 객체의 참조값을 `aDog` 변수에 할당한다.
`foo` 메서드 안 지역 변수로 선언된 참조 타입 변수 `d`에 객체 참조를 할당하면, `d`의 유효 범위가 메서드 안이기에 메서드 안에서 `d`에 할당된 참조값은 메서드 밖에서 볼 수 없다. 다시 말해 `main` 함수의 `foo(aDog)` 이후 줄에서 `aDog`는 `new Dog("Max");`를 가리키는 참조값이다.

```java
public static void main(String[] args) {
    Dog aDog = new Dog("Max");
    Dog oldDog = aDog;

    foo(aDog);
    // when foo(...) returns, the name of the dog has been changed to "Fifi"
    aDog.getName().equals("Fifi"); // true
    // but it is still the same dog:
    aDog == oldDog; // true
}

public static void foo(Dog d) {
    d.getName().equals("Max"); // true
    // this changes the name of d to be "Fifi"
    d.setName("Fifi");
}
```

바로 전 코드와 비슷해보이는 위 코드에서, `foo` 메서드 안 `setName` 메서드 호출(`d.setName("Fifi");`)은 `d`가 가지고 있는 참조값을 바꾸는 것이 아니라 `d`의 참조값을 통해 접근할 수 있는 객체의 `Name` 필드를 변경한다.

결국 Java 언어에서는 모든 값이 pass-by-value 방식으로 전달된다.

## Q1-3. stack, heap에 저장된 value의 1) 적용 가능한 범위, 2) 생명 주기(언제 생성되고, 언제 소멸되나?)
**이 질문이 필요한지 다시 생각해보기**
예상한 것
stack에 저장될 경우, method 시작부터 끝으로 범위가 제한된다
heap에 저장될 경우, 객체 소멸 시까지

- instance variable: 변수의 값은 객체가 사라지기까지 유지되어야 한다.

- class variable: 애플리케이션 실행동안 값이 유지되어야 한다.

- local variable: 메서드 시작에 시작해서 끝날 때 없어진다

- parameter: 메서드 시작에 시작해서 끝날 때 없어진다

## Q3. GC가 처리하는 데이터는 무엇인가?

## Q4. 기본 타입 변수가 instance variable일 때 heap에 저장된다면, 이때 variable 안 기본 타입 value는 GC의 대상이 아닌가?

## Q5. 참조 타입 변수가 local variable일 때 stack에 저장된다면, 이때 variable 안 reference type value는 GC의 대상이 아닌가?
