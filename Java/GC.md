# Garbage Collection
[Understanding Memory Management](https://docs.oracle.com/cd/E13150_01/jrockit_jvm/jrockit/geninfo/diagnos/garbage_collect.html)

**memory management란 새로운 객체를 할당하고 사용하지 않는 객체를 지워서 새로운 객체 할당을 위한 공간을 마련하는 과정이다.**

**\* Q1.** 여기서 객체(object)는 뭘 뜻하나? [java language specification 4.3.1](https://docs.oracle.com/javase/specs/jls/se7/html/jls-4.html#jls-4.3.1)에서 object의 개념을 설명한다:<br>
> an object is a class instance or an array.<br>

따라서 bject는 클래스 인스턴스나 배열을 말한다.<br>

**\* Q2.** 객체를 할당한다(allocating)는 건 뭘 뜻하나?<br>

## the heap and the nursery
java 객체는 heap이라고 부르는 공간에 있다. heap은 Java Virtual Machine(이하 JVM)이 시작할 때 생기며 애플리케이션 실행 중에 크기가 늘어나거나 줄어들 수 있다. heap이 꽉 차면, 쓰지 않는 객체를 모은다(garbage collection을 실행한다). GC 중엔 더이상 사용되지 않는 객체를 없애서 새로운 객체가 쓸 공간을 만들어낸다.

heap은 다시 두 공간(공간을 area, generation이라고도 한다)으로 나뉘는데, 각 공간을 nursery(young space), old space로 부른다. nursery는 heap의 일부로써, 새로운 객체를 할당하기 위한 목적을 갖는다. nursery가 꽉 차면, young collection을 실행해서 쓰지 않는 객체를 모은다. young collection 과정 동안 nursery에서 충분히 오래 있었던 객체는 old space로 이동(moved, promoted)하고, 더 많은 객체를 할당할 수 있도록 nursery 안에 빈 자리를 만든다. (heap의 다른 부분인) old space가 꽉 차면 그곳에서 쓰지 않는 객체를 모은다. 이 과정을 old collection이라고 한다.

nursery는 대부분의 객체가 일시적이고 얼마 지나지 않아 없어진다는 논리 하에 동작한다. young collection은 새롭게 할당된 객체 중 아직 살아있는 것들을 재빨리 찾아서 nursery로부터 다른 곳으로 옮기도록 설계되었다. 보통의 young collection가 메모리를 비우는 속도는 old collection이나 single-generational heap의 garbage collection보다 훨씬 빠르다. (single-generational heap: nursery가 없는 heap을 말한다.)

R27.2.0 및 이후의 배포본에서, nursery 일부는 keep area로 예약되어 있다. keep area는 가장 최근에 nursery에 할당된 객체를 갖고 있으며, 다음번 young collection 전까지는 garbage collect되지 않는다. 이는 young collection 시작 바로 전에 할당된 객체가 promote되는 것(old space로 이동하는 것)을 막는다.<br>

**\* Q3.** 최근에 nursery에 할당된 객체의 경우, '충분히 오래 있었다'고 볼 수 없을 가능성이 있다고 생각한다. 그러면 keep area가 없을 경우, young collection에서 이런 객체들이 promote될 가능성뿐 아니라 쓰지 않는 객체로 인식되어 없어질 위험도 있다는 의미인가?

## object allocation
객체를 할당하는 동안 JRockit JVM은 작은 객체와 큰 객체를 구분한다. 큰 객체 여부를 판단하는 요인은 여러 가지다.

작은 객체는 thread local areas(TLAs)에 할당된다. TLA는 heap 안 공간 중 예약된 free chunks이며 한 개의 Java thread가 독점해서 쓴다. 임의의 thread가 heap으로부터 TLA를 지급받으면 thread는 다른 thread와 동기화하지 않고도 자신의 TLA에 객체를 할당할 수 있다. TLA가 꽉 차면, thread는 새로운 TLA를 요청한다. nursery가 있을 경우 TLA(를 위한 free chunks는) nursery로부터 예약되며, 그렇지 않을 경우는 (TLA를 위한 free chunks가) heap의 어딘가로부터 예약된다.

**\* Q4.** TLA는 heap과 Java thread 중 어디에 속하나?
[Java Virtual Machine Specification 2.5.3](https://docs.oracle.com/javase/specs/jvms/se7/html/jvms-2.html#jvms-2.5.3)에서 heap은 모든 JVM threads가 공유한다고 되어 있다: The Java Virtual Machine has a heap that is shared among all Java Virtual Machine threads. Thread가 heap보다 더 좁은 범위이므로 thread에 속한다고 보는 것이 맞을 것 같다.

TLA에 크기가 맞지 않는 큰 객체는 heap에 바로 할당된다. nursery를 쓰는 경우, 큰 객체는 old space에 바로 할당된다. JRockit JVM이 캐시 시스템을 써서 동기화할 필요성을 줄이고 할당 속도를 높이기는 하지만, 큰 객체 할당은 여러 Java thread 간 동기화를 필요로 한다.

## garbage collection
garbage collection(이하 GC)은 새로운 객체를 할당하기 위해 heap이나 nursery로부터 공간을 비우는 과정이다.

### the mark and sweep model
JRockit JVM은 heap 전체의 GC 실행에 mark and sweep GC model을 이용한다. mark and sweep GC는 mark 단계와 sweep 단계로 나뉜다.

mark 단계가 진행될 동안 Java threads, native handles, 이외 다른 root sources로부터 닿을 수 있는 모든 객체, 그리고 이 객체로부터 닿을 수 있는 객체를 살아있다고 표시(mark)한다. 이 과정을 통해 아직 사용하고 있는 객체를 식별하고, 나머지는 garbage(쓰지 않는 객체)로 인식한다.

sweep 단계가 진행될 동안 heap을 흝으면서 살아있는 객체 사이 간격(gaps between the live objects)을 찾는다. 이러한 간격은 free list에 기록되며 새로운 객체 할당에 쓸 수 있다.

JRockit JVM은 mark and sweep model의 두 가지 개선판을 쓴다. 하나는 mostly concurrent mark and sweep이며 다른 하나는 parallel mark and sweep이다. mostly concurrent mark and parallel sweep처럼 두 가지 전략(mostly concurrent, parallel)을 섞어 쓸 수도 있다.

#### **mostly concurrent mark and sweep**
보통은 간단하게 concurrent garbage collection으로 불린다. GC 도중에도 Java threads 작동을 허용한다. 그러나 동기화를 위해 threads를 몇 분간 멈춰야 한다.

the mostly concurrent mark phase는 네 부분으로 나뉜다:

the mostly concurrent sweep phase는 네 부분으로 구성된다:

#### **parallel mark and sweep**
parallel garbage collector로도 부른다. 가능한 빨리 GC를 실행하기 위해 시스템 내 사용할 수 있는 모든 CPU를 사용한다. parallel GC 과정 처음부터 끝까지 모든 Java threads가 멈춘다.

### generational garbage collection
nursery가 있는 경우 young collection으로 nursery를 GC한다. nursery를 쓰는 GC 전략을 generational garbage collection strategy 또는 generational garbage collection이라고 부른다.

JRockit JVM에서 쓰는 young collector는 nursery 안 살아있는 객체 중 keep area 바깥에 있는 객체를 식별하고 old space로 옮긴다. 이 작업은 모든 가용한 CPU를 사용해 parallel하게 실행된다. Young collection 처음부터 끝까지 Java threads가 멈춘다.

### dynamic and static garbage collection modes
JRockit JVM은 기본적으로 dynamic garbage collection mode를 사용한다. 어떤 GC 전략을 사용할지 자동으로 결정하는 것이다. 결정 기준은 application throughput을 최적화하는 방향이다. 선택할 수 있는 mode는 두 개가 더 있으며 garbage collection 전략을 직접 결정할 수도 있다. 다음 dynamic modes를 쓸 수 있다:

## compaction
나란히 할당된 객체 둘은 동시에 GC되지 않을 가능성이 높다. 즉, GC 후에 heap 안 새로운 객체를 할당할 수 있는 공간이 파편화되어 가용 공간은 많지만 각 공간은 작아서 큰 객체 할당이 힘들거나 불가능해질 수도 있다. 최소 TLA 크기보다 작은 빈 공간은 아예 사용할 수 없고, garbage collector는 그러한 공간을 dark matter로 분류해서 나중 GC가 그 옆 공간을 비워서 TLA 크기만큼 충분한 공간이 확보될 때까지 내버려 둔다.

이러한 파편화를 줄이기 위해, JRockit JVM은 매 GC(old collection)마다 heap 일부를 압축(compact)한다. Compaction은 객체를 가까이 모으고, heap의 더 아랫쪽으로 모아서 heap 윗쪽으로 커다란 빈 공간을 만들어낸다. compaction area의 크기와 위치, compaction 실행 기법은 사용된 garbage collection mode에 따른 advanced heuristics에 의해 결정된다.

compaction은 sweep 단계가 시작될 때나 단계 도중에, 그리고 Java threads가 멈춘 사이에 실행된다.

### external and internal compaction
JRokit JVM에서는 external compaction과 internal compaction 두 가지의 compaction 방법을 사용한다. External compaction은 compaction area 안 객체를 compaction area 바깥의 가능한 heap의 아랫쪽에 있는 free position으로 밀어낸다. internal compaction은 compaction area 안 객체를 compaction area의 가능한 한 아랫쪽으로 밀어넣어서 객체가 서로 더 가까워지도록 한다.

JVM에서는 compaction 방법을 정할 때 현재 GC mode와 compaction area 위치를 기준으로 삼는다. 보통 external compaction은 heap의 맨 위 근처에서 쓰고, 반면 internal compaction은 객체 밀도가 더 높은 heap의 아랫쪽에서 쓴다.

### sliding window schemes
compaction area의 위치는 GC마다 달라지고, 다음 위치를 정할 때 한두 개의 sliding windows를 이용한다. 매 GC마다 각 sliding window는 heap 안에서 notch를 위아래로 움직인다. heap의 반대편 끝에 닿거나 반대로 움직이는 sliding window를 만날 때까지 계속 notch를 움직이고, 조건을 만족하면 다시 처음부터 시작한다. 이 과정을 통해 heap 전체를 흝으며 compaction이 계속해서 일어난다.

### compaction area sizing
compaction area의 크기는 사용하는 GC mode와 연관된다. Throughput mode에서 compaction area 크기는 static한 반면, static mode를 포함한 다른 mode에서는 compaction area 크기를 compaction area position에 따라 조정해서 compaction에 드는 시간을 실행 동안 일정하게 유지하려고 한다. Compaction에 드는 시간은 옮겨야 하는 객체의 수와 이 객체로의 참조 갯수에 연관된다. 따라서 객체 밀도가 높거나 영역 내 객체로의 참조 갯수가 많은 heap 영역에서는 compaction area가 작을 것이다. 보통 객체 밀도는 최근 할당된 객체가 있는 heap의 꼭대기를 제외하곤 heap 바닥 근처가 heap 꼭대기 근처보다 높다. 따라서 compaction area는 보통 heap의 윗쪽 반보다 아랫쪽이 작다.
