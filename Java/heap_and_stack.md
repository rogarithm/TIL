# Heap, Stack

[출처](https://community.oracle.com/tech/developers/discussion/1542882/heap-and-stack) - 공식 문서는 아니지만 정리해서 기준으로 삼으려고 한다

### 관련 용어
- stack: 각 thread는 private stack을 가지며, 이곳에 frames를 저장한다<br>
- heap: JVM은 모든 thread가 공유하는 heap을 갖는다. heap은 runtime data area이며 이곳으로부터 모든 클래스 인스턴스와 배열에 대한 메모리가 할당된다. heap은 instance variables와 method area를 갖는다.<br>
- method area: 모든 thread가 공유한다. runtime constant pool, field, method code와 같은 클래스마다 있는 structures를 저장한다. 논리적으로 heap의 부분이다. class variables와 클래스 안에서 선언된 methods 역시 이곳에 저장된다.<br>
- runtime constant pool(constant pool): 클래스나 인터페이스마다 있는 constant_pool table의 runtime representation이다. JVM은 type별 constant pool을 유지하고, 여기는 literal(string, integer, floating point constant)를 포함한다. 각각의 runtime constant pool은 JVM method area로부터 할당된다<br>
- frame(stack frame): frame은 local variables(parameters 포함), operand stack, partial results를 가지며, method invocation과 return에서 부분적 역할을 맡는다. method를 부를 때마다 새로운 frame이 생성되고, method가 완료되면 frame이 파괴된다. 각 frame은 현재 method의 class가 갖는 runtime constant pool에 대한 참조다.<br>
- thread: heap에 존재하는 특별한 object다.<br>

### heap에 저장되는 부분과 stack에 저장되는 부분
- stack: 활성화된 method invocations의 모든 local variables<br>
- heap: objects, class variables, instance variables<br>
* type variables의 값은 object에 대한 참조지 object 자체가 아니다<br>
