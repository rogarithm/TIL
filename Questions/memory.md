## 데이터는 메모리 중 어디에 저장되는가?
### 공식 문서를 조사해 변수, 클래스, 객체가 저장되는 메모리 위치를 알아봤다.
1. 클래스 변수, 인스턴스 변수는 heap에 저장된다
> **All instance fields, static fields**, and array elements are stored in heap memory. (jls 17.4.1)

2. 지역 변수, 매개변수는 stack에 저장된다<br>
- 공식 문서에서 찾지 못했다. 지역 변수와 매개변수의 유효한 범위가 메서드 안이기 때문에 stack에 저장된다고 생각했다.

3. 클래스 인스턴스(object)는 heap에 저장된다
> The Java Virtual Machine has a heap that is shared among all Java Virtual Machine threads. **The heap** is the run-time data area from which memory for **all class instances** and arrays is allocated. (jvms 2.5.3)

4. 클래스는 method area에 저장된다
> It stores **per-class structures** such as the run-time constant pool, **field and method data, and the code for methods and constructors**, including the special methods (§2.9) used in class and instance initialization and interface initialization.(jvms 2.5.4)

5. 기본 타입 변수는 stack에 저장된다
6. 참조 타입 변수는 heap에 저장된다

### 위 질문은 다음과 같은 점에서 모호하다.
1. 데이터 종류를 클래스, 클래스 인스턴스, 변수 세 가지로 분류한 것이 적절한지, 각 데이터 종류마다 데이터를 메모리에 저장한다는 것이 어떤 의미인지 명확하지 않다.
2. 기본 타입 변수과 참조 타입 변수가 저장되는 곳이 각각 stack과 heap이 맞는지 확실하지 않다.
#### -> Q1과 Q2에서 두 의문점에 대해 알아봤다.

## Q1. 데이터 종류에는 어떤 것이 있으며, 각 데이터 종류 별로 어떤 것을 저장하는가?
### 예상한 것
#### 1. 데이터의 종류는 클래스, 클래스 인스턴스, 변수, value일 것이다.
#### 2. 데이터 종류 별 데이터를 메모리에 저장한다는 건 다음을 저장한다는 의미일 것이다:
- 클래스: 필드, 메서드, 생성자를 메모리에 저장
- 클래스 인스턴스: 생성된 클래스 인스턴스에 대한 정보. 필드값이 초기화되었다면 어떤 건지, 메서드에 접근할 수 있는 권한 등을 메모리에 저장
- 변수: 어떤 데이터를 저장하는지 모른다.
- 값: 어떤 데이터를 저장하는지 모른다.

### 의문점에 대해 자료 조사
SO에서 [variable vs object vs reference](https://stackoverflow.com/questions/32010172/what-is-the-difference-between-a-variable-object-and-reference) 질문을 읽어봤다. Jon Skeet에 의하면,

변수, 객체, 참조는 비유적으로 다음 특징이 있다.
- 변수는 값을 가지고 있을 수 있지만, 변수가 값 자체는 아니다.
- 다른 값으로 변수가 가지고 있는 값을 바꿀 수 있다.
- 참조는 주소와 같다. 객체는 아니지만, 객체에 어떻게 접근하는지 알려준다.
- object는 집과 같다. 동일한 object를 향하는 참조는 여러 개 있을 수 있지만, 그 참조가 가리키는 object는 단 하나만 존재한다.

프로그램 용어로 변수, 객체, 참조를 설명하면,
- 변수는 메모리 상 저장 공간의 위치를 나타낸다. `int x = 12;` 에서와 같이 기본 타입 값을 가지고 있을 수도 있고, `Dog myDog = new Dog();`와 같이 참조를 가지고 있을 수도 있다. 이때 새로 만들어진 `Dog` 클래스 인스턴스를 `myDog` 변수에 할당하지 않는다. 이 클래스 **인스턴스를 가리키는 주소(즉, 참조)를 할당**한다.
- 변수나 표현식의 값은 절대로 object가 아니다. object를 가리키는 참조다. 참조는 object에 접근하기 위해 사용되는 값이다. 이때 "접근한다"는 object의 메서드를 호출하거나 필드에 접근하는 것 등을 말한다.

이로부터 유추해보면,
- 메모리에 저장되는 데이터 종류는 클래스, 클래스 인스턴스, 변수인 것 같다. 값은 어떤 것을 저장하는 것이라기보다는 변수에 저장되는 것이라고 하는 편이 맞는 것 같다.
- 또 변수 타입에 따라 기본 타입 값을 저장하거나  참조 타입 값을 저장할 수 있다.


## Q2. 기본 타입 변수는 stack에, 참조 타입 변수는 heap에 저장되는 것이 맞는가?
### 왜 이런 의심을 하게 되었나?
- Q1 질문에 대한 답 중 기본 타입 변수과 참조 타입 변수가 저장되는 곳이 각각 stack과 heap이 맞는지 확실하지 않다.
- 첫째로, 기본 타입 변수가 stack에 저장된다는 것의 출처는 자바의 신 1권이었다. 정확히는 기본 타입이 stack에 저장된다고 언급되어 있다. 그러나 기본 타입 변수가 인스턴스 변수일 때를 고려했을 때 항상 stack에 저장되는지가 의심된다.
- 둘째로, 참조 타입 변수가 heap에 저장된다는 것의 출처는 없다. 유추해서 내린 결론인데, 조사했을 때 참조 타입 변수가 stack에 저장되지 않는다는 언급을 찾지 못했다. 따라서 참조 타입 변수가 항상 heap에 저장되는지 의심의 여지가 있다.

### 기본 타입 변수는 stack에 저장되고, 참조 타입 변수는 heap에 저장된다는 생각에 대한 반례
1. 기본 타입 변수가 인스턴스 변수일 때
인스턴스 변수는 객체가 소멸될 때까지 유지된다. 그렇다면 기본 타입 변수이더라도 인스턴스 변수로 선언되었다면 stack의 주기보다 더 오래 생명이 지속되야 한다고 생각한다. 따라서 stack이 아니라 heap에 저장되야 한다고 생각한다. 이는 기본 타입 변수가 항상 stack에 저장된다는 처음의 생각과 상충된다.
2. 참조 타입 변수가 지역 변수일 때
참조 타입 변수에는 객체에 대한 참조가 담긴다. 참조 타입 변수가 지역 변수라면 참조 타입 변수가 가지는 참조값(reference)을 다른 참조로 변경할 경우, 그 변경 사항은 메서드 안에서만 유효하다. 메서드 안에서 참조 타입 변수의 값을 변경하면 그 값은 메서드가 종료되면 사라진다. 이 경우 변수가 참조 타입이더라도 그 값이 heap에 저장된다고 볼 수 없는 것 같다. 이는 참조 타입 변수가 항상 heap에 저장된다는 처음의 생각과 상충된다.

###
위 반례를 생각하면, 변수의 타입으로 그 변수가 저장되는 메모리 위치를 확정할 수 없다. 그러므로 원래 생각했던 **Q2(변수의 종류와 타입에 따라서 메모리 어디에 저장되나?) 질문**은 유효하지 않은 질문이라고 결론지었다. 의문 해결에 유효할 것이라고 생각되는 질문은, 변수가 기본 타입 값이나 참조 타입 값을 가지고 있을 때, 이 값이 어떤 것인가였다. Q1에서 variable, object, reference를 비교하면서 알아본 것에 더해, Java 언어가 pass-by-value 언어라는 것에서 그 답을 찾을 수 있었다.

###
[SO 답변](https://stackoverflow.com/a/40523)에서 변수의 타입에 따라 변수가 어떤 값을 갖는지 찾아볼 수 있었다. 참조타입 변수가 가지고 있는 값은 **객체 자체**가 아니라 **객체를 가리키는 참조**다. 참조는 객체에 접근할 수 있는 주소와 같은 개념이며, 여기서 접근한다는 말은 객체의 필드값을 가져오거나, 객체의 메서드를 호출하는 등의 행위를 의미한다.

###
동일한 답변에서 두 코드를 예시로 들고 있다.

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

###
위 코드에서, `Dog aDog = new Dog("Max");`는 `aDog`에 새로 생성한 `Dog` 객체를 할당하는 듯 보이지만(**나는 줄곧 이렇게 생각하고 있었다**), 실제로는 이 **객체의 참조**를 `aDog` 변수에 할당한다. `foo` 메서드 안 지역 변수로 선언된 참조 타입 변수 `d`에 객체 참조를 할당하면, `d`의 유효 범위가 메서드 안이기에 메서드 안에서 `d`에 할당된 참조 값은 메서드 밖에서 볼 수 없다. 다시 말해, `main` 함수의 `foo(aDog)` 이후 줄에서 `aDog`는 (`new Dog("Fifi");`를 가리키는 참조값이 아니라) `new Dog("Max");`를 가리키는 참조값이다.

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

###
바로 전 코드와 비슷해보이는 위 코드에서, `foo` 메서드 안 `setName` 메서드 호출(`d.setName("Fifi");`)은 `d`가 가지고 있는 참조값을 바꾸는 것이 아니라 `d`의 참조값을 통해 접근할 수 있는 **객체의 `Name` 필드를 변경**한다. 결국 Java 언어에서는 모든 값이 pass-by-value 방식으로 전달된다.

## Q3. stack, heap에 저장된 값의 적용 가능한 범위와 생명 주기 – *이 질문이 필요한지 다시 생각해보기*
### 예상한 것
stack에 저장될 경우, 메서드 시작부터 끝으로 범위가 제한되고, heap에 저장될 경우, 범위는 객체 소멸 시까지일 것이다.

- 인스턴스 변수: 변수의 값은 객체가 사라지기까지 유지되어야 한다.
- 클래스 변수: 애플리케이션 실행동안 값이 유지되어야 한다.
- 지역 변수: 메서드 시작에 시작해서 끝날 때 없어진다
- 매개변수: 메서드 시작에 시작해서 끝날 때 없어진다

## Q5. 기본 타입 변수가 인스턴스 변수일 때 heap에 저장된다면, 이때 변수 안 기본 타입 값은 GC의 대상이 아닌가?

## Q6. 참조 타입 변수가 지역 변수일 때 stack에 저장된다면, 이때 변수 안 참조 타입 값은 GC의 대상이 아닌가?

## Q4. GC가 처리하는 데이터는 무엇인가?
