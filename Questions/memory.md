Q1. 데이터는 메모리 중 어디에 저장되는가?

class variable, instance variable은 heap에 저장된다
> **All instance fields, static fields**, and array elements are stored in heap memory. (jls 17.4.1)

instance는 heap에 저장된다
> The Java Virtual Machine has a heap that is shared among all Java Virtual Machine threads. **The heap** is the run-time data area from which memory for **all class instances** and arrays is allocated. (jvms 2.5.3)

class는 method area에 저장된다
> It stores **per-class structures** such as the run-time constant pool, **field and method data, and the code for methods and constructors**, including the special methods (§2.9) used in class and instance initialization and interface initialization.(jvms 2.5.4)

Q2. GC가 처리하는 데이터는 무엇인가?
