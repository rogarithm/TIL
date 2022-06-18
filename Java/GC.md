[Understanding Memory Management](https://docs.oracle.com/cd/E13150_01/jrockit_jvm/jrockit/geninfo/diagnos/garbage_collect.html)
memory management. 새로운 objects를 할당하고 사용하지 않는 objects를 지워서 새로운 object 할당을 위한 공간을 마련하는 과정. (여기서 object는 뭘 의미하나?)

the heap and the nursery
java object는 heap이란 공간에 있다. heap은 JVM이 시작할 때 생기며 애플리케이션 실행 중에 크기가 늘어나거나 줄어들 수 있다. heap이 꽉 차면, garbage collection을 실행한다. garbage collection 중엔 더이상 사용되지 않는 object를 청소해서 새로운 object용 공간을 만들어낸다.

heap은 두 공간(area, generation)로 나뉘는데, 각각을 nursery(young space), old space로 부른다. nursery는 새로운 object 할당에 이용하는 heap의 일부다. nursery가 꽉 차면, young collection을 실행함으로써 garbage is collected. 이 과정에서 충분히 많은 시간을 살아남은 object는 old space로 이동(moved, promoted)해서 nursery가 object 할당을 더 할 수 있도록 자리를 만든다. old space가 꽉 차면 그곳에서 garbage is collected, 이 과정을 old collection이라고 한다.

nursery가 작동하는 논리는 대부분의 object가 일시적이고 그리 오랫동안 살아있지 않다는 것이다. young collection은 새롭게 할당된 object 중 아직 살아있는 것들을 재빨리 찾아서 nursery로부터 다른 곳으로 옮기도록 설계되었다. 전형적으로 young collection은 특정 용량의 메모리를 old collection이나 single-generational heap(nursery가 없는 heap)의 garbage collection보다 훨씬 빨리 비운다.

R27.2.0 및 이후의 릴리즈에서, nursery 중 일부는 keep area로 예약되어 있다. keep area는 가장 최근에 nursery에 할당된 object를 가지고 있으며 다음번 young collection 전까지는 garbage collect되지 않는다. 이는 young collection 시작 바로 전에 할당된 object가 promote되는 것(old space로 이동하는 것)을 막는다

object allocation
object 할당 동안에 JRockit JVM은 작은 object와 큰 object를 구분한다. 얼마나 큰 object부터 큰 object라고 하는지는 여러 요인에 의해 결정된다.

작은 object는 thread local areas (TLAs)에 할당된다. TLA는 heap 안 공간 중 예약된 free chunks이며 단독 사용을 목적으로 Java thread에 주어진다. (TLA는 heap과 Java thread 중 어디에 속하는 거지?) 그러고 나면 그 thread는 다른 thread와 동기화하지 않고도 자신의 TLA에 object를 할당할 수 있다. TLA가 꽉 차면, 그 thread는 새로운 TLA를 요청한다. nursery가 존재할 경우 TLA는 TLA로부터 예약되며, 그렇지 않을 경우는 heap의 어딘가로부터 예약된다.

TLA에 크기가 맞지 않는 큰 object는 heap에 바로 할당된다. nursery를 쓰는 경우, 큰 object는 old space에 바로 할당된다. JRockit JVM이 캐시 시스템을 써서 동기화할 필요성을 줄이고 할당 속도를 높이기는 하지만, 큰 object 할당은 여러 Java thread 간 동기화를 필요로 한다.

garbage collection
garbage collection은 새로운 object를 할당하기 위해 heap이나 nursery로부터 공간을 비우는 과정이다.

- the mark and sweep model
JRockit JVM은 heap 전체의 GC 실행에 mark and sweep GC model을 이용한다. mark and sweep GC은 mark 단계와 sweep 단계로 나뉜다.

mark 단계 동안 Java threads, native handles, 이외 다른 root sources로부터 닿을 수 있는 모든 object, 그리고 이 object로부터 닿을 수 있는 object를 살아있다고 표시(mark)한다. 이 과정으로 아직 사용되고 있는 object를 식별하고, 나머지는 garbage로 인식한다.

sweep 단계 동안 heap을 흝으면서 살아있는 object 사이 간격(?)을 찾는다. 이러한 간격은 free list에 기록되며 새로운 object 할당에 쓸 수 있도록 만든다.

JRockit JVM은 이러한 mark and sweep model의 두 가지 개선판을 사용한다. 하나는 mostly concurrent mark and sweep이며 다른 하나는 parallel mark and sweep이다. mostly concurrent mark and parallel sweep처럼 두 가지를 섞어 쓸 수도 있다.

- mostly concurrent mark and sweep
보통은 간단하게 concurrent garbage collection으로 불린다. GC 도중에도 Java threads 작동을 허용한다. 그러나 threads는 동기화를 위해 몇 분간 멈춰야 한다.

the mostly concurrent mark phase는 네 부분으로 나뉜다:

the mostly concurrent sweep phase는 네 부분으로 구성된다:

- parallel mark and sweep

parallel garbage collector로도 부른다. 가능한 빨리 GC를 실행하기 위해 시스템 내 사용할 수 있는 모든 CPU를 사용한다. 모든 Java threads는 parallel GC 과정 처음부터 끝까지 멈춘다.

generational garbage collection
nursery가 존재하는 경우, nursery는 young collection이라는 특별한 GC를 써서 garbage collect한다. nursery를 쓰는 GC 전략을 a generational garbage collection strategy 또는 generational garbage collection이라고 부른다.

JRockit JVM에서 쓰는 young collector는 nursery 안 살아있는 object 중 keep area 바깥에 있는 object를 식별하고 old space로 옮긴다. 이 작업은 모든 가용한 CPU를 사용해 parallel하게 실행된다. Java threads는 young collection 처음부터 끝까지 멈춘다.

- dynamic and static garbage collection modes

JRockit JVM은 기본적으로 dynamic garbage collection mode를 사용한다. 어떤 GC 전략을 사용할지 자동으로 결정하는 것이다. 결정 기준은 application throughput을 최적화하는 방향이다. 선택할 수 있는 mode는 두 개가 더 있으며 garbage collection 전략을 직접 결정할 수도 있다. 다음 dynamic modes를 쓸 수 있다:

compaction

나란히 할당된 object 둘은 동시에 garbage collect될 필요는 없다. 즉 heap이 garbage collection 후에 파편화되어 heap 안 가용 공간은 많지만 각각이 작아서 큰 object 할당이 힘들거나 불가능해질 수도 있다. 최소 TLA 크기보다 작은 빈 공간은 아예 사용할 수 없고, garbage collector는 그러한 공간을 dark matter로 취급해 나중 garbage collection이 그 옆 공간을 비워서 TLA 크기만큼 충분한 공간이 확보될 때까지 버려 버린다.

이러한 파편화를 줄이기 위해, JRockit JVM은 매 garbage collection(old collection)마다 heap의 부분을 압축(compact)한다. Compaction은 objects를 가까이 모으고, heap의 더 아랫쪽으로 모아서 heap 윗쪽으로 큰 빈 공간을 만들어낸다. compaction area의 크기와 위치, compaction 기법은 사용된 garbage collection mode에 따른 advanced heuristics에 의해 결정된다.

compaction은 sweep 단계의 시작 또는 중간, Java threads가 멈춘 사이에 실행된다.

- external and internal compaction

- sliding window schemes

- compaction area sizing

