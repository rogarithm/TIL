Q1. 데이터는 메모리 중 어디에 저장되는가?

class variable, instance variable은 heap에 저장된다
> **All instance fields, static fields**, and array elements are stored in heap memory. (jls 17.4.1)

instance는 heap에 저장된다
> The Java Virtual Machine has a heap that is shared among all Java Virtual Machine threads. **The heap** is the run-time data area from which memory for **all class instances** and arrays is allocated. (jvms 2.5.3)

class는 method area에 저장된다
> It stores **per-class structures** such as the run-time constant pool, **field and method data, and the code for methods and constructors**, including the special methods (§2.9) used in class and instance initialization and interface initialization.(jvms 2.5.4)

primitive type variable는 stack에 저장된다

reference type variable는 heap에 저장된다

class instance는 heap에 저장된다

class는 method area에 저장된다

Q2. GC가 처리하는 데이터는 무엇인가?

Q3. 변수의 종류와 타입에 따라서 메모리 어디에 저장되나?

변수는 네 가지로 나뉜다: class variable, instance variable, parameter, local variable (이하 CV, IV, P, LV)
변수의 타입은 두 가지로 나뉜다: primitive type, reference type (이하 PT, RT)

어떤 종류의 변수든 두 가지 타입을 가질 수 있다. 문제는 어떤 종류의 변수가 저장되는 메모리 위치와 변수 타입이 저장되는 메모리 위치가 다를 때 변수가 어디에 저장된다고 말해야 하는지가 확실치 않다는 데 있다.
예를 들어 CV는 heap에 저장되지만, PT 변수는 stack에 저장된다. 그렇다면 PT CV는 어디에 저장된다고 봐야 하나?

이 물음에 답하고자 할 때, 내가 모르는 것은 무엇인지 고민해봤다.
변수는 어떤 값을 담는가?
int PT_IV = 6; 일 때는 6이라는 값을 PT_IV 변수에 담는다.
Cup RT_IV = new Cup(); 일 때는 RT_IV에 뭐가 들어가나? 여기에 답할 수 없었다. -> 새로 만들어진 Cup 클래스 인스턴스의 주소가 들어간다.

variable vs object vs reference의 차이점
자바 언어는 왜 pass-by-value 언어인가?

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
