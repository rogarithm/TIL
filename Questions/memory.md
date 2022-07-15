뭐가 나를 헷갈리게 했나?
참조 타입 변수에 할당되는 값이 무엇인지를 몰랐다. 이는 Java 언어가 pass-by-value 언어임을 이해하지 못해서였다. 은연중에 나는 참조 타입 변수에 할당되는 값이 객체인 줄로 생각했지만, 실제로는 객체에 접근할 수 있는 참조가 바로 그 값이었다.
참조 타입 변수에 할당되는 값이 객체인 줄 알았기 때문에 참조 타입 변수는 항상 heap에 저장되고, 기본 타입 변수는 항상 stack에 저장된다고 생각했다. 왜냐면 객체가 항상 heap에 저장되니까. 그러나 참조 타입 변수가 갖는 값은 참조이므로, 저장되는 위치를 미리 정할 수 없다.
그러나 기본 타입 변수에 대해서는 여전히 풀리지 않는 의문이 있다. 기본 타입 인스턴스 변수의 생명 주기는 객체의 생성부터 소멸까지인데, stack에 변수 값이 저장된다면 인스턴스 변수 생명 주기동안 변수 값이 유지될 수가 있나? 아니면 heap에 저장되지만 GC의 대상은 되지 않는건가?


Q1. 데이터는 메모리 중 어디에 저장되는가?

1. class variable, instance variable은 heap에 저장된다
> **All instance fields, static fields**, and array elements are stored in heap memory. (jls 17.4.1)

2. local variable, parameter는 stack에 저장된다?
공식 문서에서 찾지 못했다. local variable과 parameter가 유효한 범위가 메서드 안이라서 stack에 저장된다고 생각했다.

3. class instance는 heap에 저장된다
> The Java Virtual Machine has a heap that is shared among all Java Virtual Machine threads. **The heap** is the run-time data area from which memory for **all class instances** and arrays is allocated. (jvms 2.5.3)

4. class는 method area에 저장된다
> It stores **per-class structures** such as the run-time constant pool, **field and method data, and the code for methods and constructors**, including the special methods (§2.9) used in class and instance initialization and interface initialization.(jvms 2.5.4)

5. primitive type variable는 stack에 저장된다 (자바의 신 1권에서 봤다. 정확히는 primitive type이 stack에 저장된다고 언급되어 있다.)
 - 인스턴스 변수일 때를 고려했을 때 항상 stack에 저장되는지가 의심된다.

6. reference type variable는 heap에 저장된다
 - 출처가 모호하다. 의심할 여지가 있다.


Q1-1. Q1에서 질문한 건 모호하다. 첫째로 데이터의 종류가 class, class instance, variable이 맞는지 확실하지 않다. 둘째로 데이터를 저장한다는 말이, 각 데이터 종류 별로 어떤 것을 저장하는지 명확하지 않다.

내가 생각한 데이터의 종류는 class, class instance, variable, value였다.
내가 생각한 데이터 종류 별 저장되는 것은 다음과 같다.
class: 필드, 메서드, 생성자
class instance: 생성된 class instance에 대한 정보. 필드값이 초기화되었다면 어떤 건지, 메서드에 접근할 수 있는 권한, 
variable과 value는 어떤 데이터를 담는지 모른다. SO에서 variable vs object vs reference 질문을 읽어봤다.
Jon Skeet의 답변에 따르면,
variable은 value를 가지고 있을 수 있지만, variable이 value 자체가 아니다. 다른 value로 variable이 가지고 있는 value를 바꿀 수 있다.
reference는 주소와 같다. 객체는 아니지만, 객체에 어떻게 접근하는지 알려준다.
object는 집과 같다. 동일한 object를 향하는 reference는 여러 개 있을 수 있지만, 그 reference가 가리키는 object는 단 하나만 존재한다.

variable은 메모리 상 저장 공간의 위치를 나타낸다.
int x = 12; 에서와 같이 primitive type value를 가지고 있을 수도 있고,
Dog myDog = new Dog(); 에서와 같이 reference도 가지고 있을 수 있다. 이때 새로 만들어진 Dog class instance를 myDog variable에 할당하지 않는다. 이 class instance를 가리키는 주소를 할당한다.

variable이나 expression의 값은 절대로 object가 아니다. object를 가리키는 참조다.
reference는 object에 접근하기 위해 사용되는 value다. 접근한다는 건 object의 메서드를 호출하거나 필드에 접근하는 것 등을 말한다.

이로부터 유추해보면,
variable은 value를 가지고 있을 수 있다. value는 primitive type value이거나 reference 또는 null type reference다.
variable이 가지고 있는 value는 다른 value로 대체될 수 있다.

primitive type variable은 primitive type value를 가질 수 있는 variable을 말한다.
reference type variable은 reference(reference type value)를 가질 수 있는 variable을 말한다.


Q1-3. primitive type variable는 stack에, reference type variable는 heap에 저장되는 것이 맞는지 의심된다.

출처가 명확하지 않다. 의심되는 이유는, 반례라고 생각되는 예가 있기 때문.
1. primitive type variable이 instance variable일 때
instance variable은 객체가 소멸될 때까지 유지된다. 그렇다면 primitive type이더라도 stack의 주기보다 더 오래 생명이 지속되야 하는 것 아닌가?
2. reference type variable이 local variable일 때 (이건 좀 더 확인해봐야 한다. 내가 생각한 게 맞는지 확실하지 않다)
메서드 안에서 선언된 reference로 객체를 변경하면, 그 변경사항은 메서드 안에서만 적용된다.
value가 reference일 경우, 객체는 없어지지 않지만, 이 객체로의 참조가 없어진다.


Q1-2. stack, heap에 저장된 value의 1) 적용 가능한 범위, 2) 생명 주기(언제 생성되고, 언제 소멸되나?)를 확실히 모른다.

나의 예상
stack에 저장될 경우, method로 범위가 제한된다
heap에 저장될 경우, 객체 소멸 시까지


Q3. 변수의 종류와 타입에 따라서 메모리 어디에 저장되나?

변수는 네 가지로 나뉜다: class variable, instance variable, parameter, local variable (이하 CV, IV, P, LV)
변수의 타입은 두 가지로 나뉜다: primitive type, reference type (이하 PT, RT)

어떤 종류의 변수든 두 가지 타입을 가질 수 있다. 내가 의문을 가진 것은 어떤 종류의 변수가 저장되는 메모리 위치와 변수 타입이 저장되는 메모리 위치가 다를 때 변수가 어디에 저장된다고 말해야 하는가였다.
예를 들어 CV는 heap에 저장되지만, PT 변수는 stack에 저장된다. 그렇다면 PT CV는 어디에 저장된다고 봐야 하나?

이 물음에 답하고자 할 때, 내가 모르는 것은 무엇인지 고민해봤다.

첫번째. 변수는 어떤 값을 담는가? Q1-1에서 확인했다.
int PT_IV = 6; 일 때는 6이라는 값을 PT_IV 변수에 담는다.
Cup RT_IV = new Cup(); 일 때는 RT_IV에 뭐가 들어가나? 새로 만들어진 Cup 클래스 인스턴스의 주소가 들어간다.


두번째. 자바 언어는 왜 pass-by-value 언어인가?

instance variable
클래스 인스턴스마다 IV를 가진다.
IV는 객체마다 독립적인 상태일 수 있다.
PT-IV (stack-heap) : 변수의 값은 객체가 사라지기까지 유지되어야 한다. 따라서 heap에 저장되어야 할 것 같다.
RT-IV (heap-heap) : 둘 다 heap이므로 heap에 저장된다.

class variable
CV는 모든 객체에서 상태가 동일하다.
PT-CV (stack-heap) : 애플리케이션 실행동안 값이 유지되어야 한다. 따라서 heap에 저장되어야 할 것 같다. 하지만 primitive type이 GC되지는 않지 않나?
RT-CV (heap-heap) : 둘 다 heap이므로 heap에 저장된다.

local variable
PT-LV (stack-stack) : 메서드 안에서 선언된 PT-LV는 메서드가 끝날 때 없어진다
RT-LV (heap-stack) : 메서드 안에서 선언된 RT-LV는 heap에 저장되나 메서드가 끝날 때 없어지나? 없어지진 않지만 heap에 의해 GC되나?

parameter
PT-P (stack-stack) : 메서드가 끝날 때 없어진다
RT-P (heap-stack) : 메서드가 끝날 때 없어지나? heap에 의해 GC되나?


Q2. GC가 처리하는 데이터는 무엇인가?
