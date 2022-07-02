# 종류

## Serial GC
CPU 하나만 쓰고, GC 과정 중엔 애플리케이션 실행이 중단되는 방식(stop-the-world)

### young collection
- young collection이 일어나는 영역(young generation)은 eden 영역과 두 개의 survivor 영역으로 구성된다.
- 두 survivor 영역은 보통 하나는 비어있고, 다른 하나는 차있다. 비어있는 survivor 영역을 survivor E(empty), 비어있지 않은 다른 하나의 survivor 영역을 survivor NE(not-empty)라 하자.
- eden 영역에서 살아남은 객체를 survior E로 복사한다.
- 이때 너무 큰 객체는 곧바로 old 영역으로 복사한다. (기준은 survivor 영역에 맞지 않을 정도로 큰 경우)
- survivor NE 안 살아있는 객체 중 상대적으로 어린 객체를 survivor E로 복사하고, 상대적으로 나이 든 객체를 old 영역으로 복사한다.

**Note**
- survivor E가 꽉 차면, eden이나 survivor NE 안 살아남은 객체 중 복사하지 않은 객체를 old 영역으로 복사한다. 이때 객체가 얼마나 많은 young collection를 거쳤는지와 관계 없이 복사된다.
- 살아남은 객체가 다른 영역으로 복사되고 난 뒤 eden과 surviror NE에 남은 객체는 가비지로 판단한다. 그래서 (Garbage Collector가) 이런 객체를 자세하게 살펴보지 않는다.
- young collection 완료 후에는 eden과 survivor NE가 비워지고, 이전에 비어 있던 survivor E만 살아남은 객체를 가지고 있게 된다. 이렇게 young collection이 한 번 완료될 때마다 두 survivor 영역이 역할을 바꾼다.

### old generation
- old 영역과 permanent 영역은 mark-sweep-compact collection 알고리즘으로 가비지를 모은다.
- mark-sweep-compact collection 알고리즘은 (이름에서 알 수 있듯이) mark, sweep, compaction 세 단계로 나뉜다.
#### mark
- garbage collector가 아직 살아있는 객체를 식별한다.
#### sweep
- 영역 안 식별한 가비지를 쓸어담는다.
#### compaction
- 살아남은 객체를 old 영역과 permanent 영역의 앞쪽으로 밀고, 반대쪽 끝의 끊기지 않고 이어진 저장 공간에 빈 공간을 남겨둔다. 이를 sliding compaction이라고 한다.
- compaction을 함으로써 old 영역과 permanent 영역으로 할당 시에 (속도가 빠른) bump-the-pointer를 사용할 수 있다.


## Parallel GC
물리적 메모리와 CPU를 여럿 가진 기기에서 애플리케이션을 실행할 때 GC 작업에 이 자원(메모리, CPU)을 최대한 활용한다.

### young collection
- serial GC에서 young collection에 이용하는 알고리즘의 parallel version을 사용한다.
- serial GC의 알고리즘과 비교했을 때, parallel version 알고리즘은 stop-the-world 및 copying collector 방식은 동일하나, young collection 수행을 병렬로, 여러 대의 CPU를 가지고 하는 점이 다르다.
- parallel version 알고리즘이 갖는 차이점은 GC에 의한 overhead를 줄이고 애플리케이션 전체 실행 시간 중 GC 실행 시간이 차지하는 비율을 줄여준다.

### old collection
- serial collection에서와 마찬가지로 mark-sweep-compact collection algorithm을 사용한다.


## Parallel Old GC(Parallel Compacting GC)
- J2SE 5.0 update 6에 처음으로 나왔다.
- parallel 방식과의 차이점은 old collection에 새로운 알고리즘을 사용한다는 것이다.

### young collection
- parallel 방식의 young collection에 사용하는 알고리즘과 같은 알고리즘을 쓴다.

### old collection
- stop-the-world 방식으로 진행되고, 과정 대부분을 sliding compaction을 사용하는 parallel 방식을 이용한다.
- 세 단계로 나뉜다:

#### 첫번째 단계
- 각 영역을 고정 크기 영역이 되도록 논리적으로 나눈다.

#### marking 단계
- 애플리케이션 코드에서 바로 reachable한 살아있는 객체 집합을 GC 스레드별로 분배한다.
- 모든 살아있는 객체가 병렬 방식으로 mark된다(marked in parallel).
- 어떤 객체를 살아있는 것으로 판단하면 해당 객체가 있는 지역에 대한 정보가 업데이트된다. 이 정보는 그 객체의 크기와 위치에 대한 것이다.

#### summary 단계
- 객체가 아니라 (**첫번째 단계**에서 나눈) 영역별로 동작한다.
- 이전 collection 중 일어난 compaction 때문에 각 영역 왼쪽 부분에서 살아남은 객체 밀도가 높은 경우가 많다. 살아남은 객체 밀도가 높은 곳은 compact하더라도 다른 객체를 할당할 수 있는 공간을 많이 만들어낼 수 없을 가능성이 높다.
- 따라서 이 단계에서는 처음으로 (**첫 번째 단계**에서 나눈) 영역의 밀도를 왼쪽부터 살펴서, 어떤 지점부터 남은 공간을 compact해야 다른 객체를 할당할 수 있는 공간을 얻을 가능성이 높은지를 찾는다.
- 찾아낸 지점 왼쪽 지역을 dense prefix라고 하며, 이 지역으로는 아무 객체도 옮기지 않는다.
- 찾아낸 지점 오른쪽 지역에는 compaction을 실행하며, dead space 전부를 없앤다.
- summary 단계에서 compact가 일어난 지역 각각의 live data가 갖는 첫 byte 위치를 계산하고 저장한다.

#### compaction 단계
- GC 스레드는 summary data를 사용해서 채울 지역을 식별한다. 그러고 나면 여러 스레드가 독립적으로 그 지역에 data를 복사할 수 있다.\*
- \* 위 내용은 **이런 말인 것 같다**: summary 단계에서 얻은 지점 정보를 사용해서 객체로 채울 지역을 식별한다. 그러고 나면 여러 스레드가 독립적으로 그 지역에 객체를 복사(copy collection)할 수 있다.
- 이 과정을 거치면 heap의 한쪽 끝은 밀도 높게 쌓이고, 다른 끝은 넓고 비어있는 블록이 만들어진다.


## Concurrent Mark & Sweep GC(CMS)
- 다수의 애플리케이션에서는 빠른 반응 시간이 end-to-end throughput보다 중요하다.\*
- \* 위 내용은 GC로 인해 중단되는 시간이 얼마나 짧은가가 애플리케이션에서 중요하다는 **것 같다**.
- young collection 때문에 GC로 인한 중단 시간이 길어지는 경우는 흔치 않다. 그러나 old collection의 경우 자주는 아니지만 중단 시간이 길어지는 경우가 있다. 특히 heap 크기가 클 경우 그렇다.
- 이러한 문제 해결을 위해 concurrent mark-sweep collector(low-latency collector) 방식을 제공한다.

### young collection
- parallel 방식과 동일한 방식으로 동작한다.

### old collection
- old collection 과정 대부분이 애플리케이션 실행과 동시에 진행된다.


- initial mark로 시작한다. 이때 짧게 멈추게 된다. 이는 애플리케이션 코드로부터 바로 reachable한 살아있는 객체의 초기 집합을 식별하기 위한 것이다.
- 그 다음 concurrent marking 단계 동안 이 초기 집합으로부터 transitively reachable한 모든 살아있는 객체를 표시한다.
- marking 단계가 진행될 동안 애플리케이션 실행 및 참조 필드가 업데이트되고 있기 때문에, concurrent marking 단계 종료 시에 모든 살아있는 객체가 표시될 것이라고 확신할 수 없다.
- 이 점을 처리하기 위해, 애플리케이션이 두 번째로 멈추고(remark), 이때 concurrent  marking phase 동안 변경된 객체를 재점검해서 marking 과정을 마무리한다.
- 두 번째 멈춤(remark pause)이 첫 번째 멈춤(initial mark)보다 상당히 길기 때문에, 효율 증대를 위해 여러 스레드를 병렬로 돌린다.

- remark phase 끝에, heap 안 모든 살아남은 객체가 확실히 표시되고, 이후 단계인 concurrent sweep 단계에 그때까지 식별된 가비지 전부를 reclaim해서 빈 공간으로 만든다.

- remark phase 동안의 객체 재점검 등의 동작이 garbage collector가 해야 할 일을 늘리지만, 중단 시간을 줄이기 위한 트레이드 오프로 볼 수 있다.

- CMS 방식은 **compacting을 하지 않는 유일한 GC 방식**이다.
- 이렇게 함으로써 GC 실행 시간은 줄어들지만, 빈 공간이 서로 떨어져 있기 때문에 다음 객체가 할당될 빈 공간의 위치를 나타낼 때 포인터 결정이 복잡해진다. 할당해야 할 객체의 크기에 맞는 빈 공간을 찾는 것이 어려워진다는 얘기다.
- 결과적으로 old 영역으로의 할당은 bump-the-pointer 기법을 쓸 수 있었을 때보다 큰 비용을 필요로 한다.
- 이는 young collection에도 추가적인 overhead를 더하는데, old 영역으로의 할당 대부분이 young collection 중 객체 이동에 의한 것이기 때문이다.

- 또 다른 단점으로, CMS 방식은 큰 heap을 필요로 한다.
- marking phase 중에도 애플리케이션이 실행될 수 있기 때문에 old 영역이 계속해서 커질 가능성을 안고 있다.
- 또한 GC 과정 도중 가비지가 된 객체가 있을 수 있고, 이러한 객체가 차지하는 공간은 다음번 old collection 전까지는 비울 수 없다. 이러한 객체를 floating garbage라고 한다.

- compaction이 없기 때문에 파편화가 발생할 수 있다.


## G1(Garbage First) GC


## Z GC

# 버전별 default GC

## default GC를 확인하는 쉘 명령어
- 내 컴퓨터에서 사용하고 있는 [default GC 확인 명령어](https://stackoverflow.com/questions/5024959/find-which-type-of-garbage-collector-is-running)를 찾아봤다.
- 이 명령어로 내 OS의 default GC는 알 수 있었지만, 전 OS 공통인지 확인은 불가했다.

## Stack Overflow에서 참조한 답변
- 버전별 default GC를 물어본 [질문](https://stackoverflow.com/a/63954277)을 찾아봤다.
- jdk 8의 default GC는 **Parallel GC**이고, jdk 9부터는 default GC가 **G1 GC**라고 되어있다.

## Oracle의 java magazine 기사
- Stack Overflow의 답변엔 출처가 나와있지 않아서 조금 더 찾아봤다.
- [oracle의 java magazine 기사](https://blogs.oracle.com/javamagazine/post/java-garbage-collectors-evolution)에서 다음과 같이 나온다.
> **The Parallel GC is the default collector for JDK 8 and earlier.** It focuses on throughput by trying to get work done as quickly as possible with minimal regard to latency (pauses).
> **The G1 GC has been the default collector since JDK 9.**

따라서 jdk 8의 default GC는 **Parallel GC**이고, jdk 9부터는 default GC가 **G1 GC**인 것이 맞다.
