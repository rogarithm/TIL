# run-time data area

jvm starts
... heap is created
... method area is created
jvm ends

per-thread

thread created
... for each thread, stack created
thread destroyed

### stack
- for each thread, stack created
- local variables, partial results, push/pop frames

### heap
- shared by all JVM threads
- class instances, arrays are allocated from the heap

### method area
- shared by all JVM threads
- storage area for compiled code
- stores
  + a) per-class structures such as the run-time constant pool, field(instance variable and class variable), and method data
  + b) code for methods and constructors

### run-time constant pool
- contains constants
  + a) numeric literals known at compile-time
  + b) method and **field references** that must be resolved at run-time
- **field references**: "" 형태의 String 타입 참조. symbol table과 비슷한 함수 제공

### native method stacks
- allocated per thread when each thread is created
- JVM instruction(C 같은 Java 이외 언어로 쓰인) 해석기에서 사용할 수 있다

### pc register
- each thread has it
- contains the address of method that is on execution if the method is not native
- if the method is native, its address is undefined
