자바 명세 중 의미가 잘 이해 안되는 부분 https://d2.naver.com/helloworld/1230 보고 다듬기

# run-time data area
**\* JVM 명세 중 [2.5 Run-Time Data Areas](https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-2.html#jvms-2.5)를 참조했다**

### Overview
- JVM에서 여러 run-time data area를 정의한다
- run-time data area 중 일부는 JVM 시작 시 생성되어 JVM이 끝날 때 없어진다
- 또 다른 run-time data area는 per-thread data area(스레드별 데이터 영역)로 임의의 스레드가 생겼을 때 생성되고, 스레드가 끝날 때 없어진다
- per-thread data area는 각 스레드마다 생길 수 있다
- heap과 method area는 모든 스레드가 공유하며, run-time constant pool은 method area로부터 할당된다
- stack, pc register, native method stack은 스레드별로 할당된다

### heap
- 모든 JVM threads에서 공유한다
- 객체(class instances)와 배열이 이곳에 할당된다
- heap에 저장된 객체가 차지하는 공간은 garbage collection에 의해 자동으로 관리된다

### method area
- 모든 JVM threads에서 공유한다
- compiled code 저장 공간과 동일하다
- run-time constant pool, field(instance variable and class variable), method data 같은 per-class structures를 저장한다
- 메서드와 생성자 코드를 저장한다<br>
**Q1. 위의 설명으로 method area에 class가 저장된다고 전혀 예상하지 못했다. class를 저장한다는 말이 a).class 파일(즉 위에서 compiled code)을 저장한다는 의미인 건가, 아니면 b)class를 구성하는 요소(위에서 field, method data)를 저장한다는 의미인 건가, 이것도 아니면 c)둘 다?**

#### run-time constant pool
- 각 run-time constant pool은 JVM method area로부터 할당된다
- JVM이 클래스나 인터페이스를 생성할 때 그 클래스나 인터페이스에 대한 run-time constant pool이 만들어진다.
- class 파일 안 constant_pool 표를 실행 시간에 클래스별로 또는 인터페이스별로 나타낸 것
- 상수값을 가지고 있다.
  + a) numeric literals known at compile-time
  + b) method and **field references** that must be resolved at run-time

### JVM stack
- 각각의 JVM 스레드마다 JVM stack을 가질 수 있으며, 해당 스레드가 생성됨과 동시에 JVM stack이 만들어진다
- local variables, partial results를 가지고 있다
- method invocation과 return 과정 중 일부를 담당한다
- JVM stack을 직접적으로 조작하는 건 push/pop frames이 유일하기 때문에 frame은 heap에 할당될 수도 있다\*<br>
**Q2. stack이 스레드에 존재하지 않을 경우 frame이 heap에 할당된다는 것을 의미하나?**

### native method stacks
- 각각의 스레드가 생성되었을 때 스레드마다 native method stack이 할당된다.
- JVM instruction(C 같은 Java 이외 언어로 쓰인) 해석기에서 사용할 수 있다

### pc register
- program counter register의 준말
- JVM은 동시에 여러 스레드를 실행시킬 수 있다.
- 스레드마다 pc register를 가질 수 있다.
- 어느 시점에서든 JVM 스레드는 한 개의 메서드 안 코드를 실행하는데, 이 메서드를 그 스레드의 현재 메서드(current method)라고 한다.
- 현재 메서드가 non-native이면 pc register는 현재 실행되고 있는 JVM instruction 주소를 가지고 있다.
- 만약 메서드가 native이면, pc register의 값은 undefined이다.
