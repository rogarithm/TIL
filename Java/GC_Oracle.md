# 종류

## Serial GC
CPU 하나만 쓰고, GC 과정 중엔 애플리케이션 실행이 중단되는 방식(stop-the-world)

### young collection
eden 영역에서 살아남은 객체 중 너무 크지 않은 것을 비어 있는 survior 영역으로 복사한다. survivor 영역에 맞지 않을 정도로 너무 큰 객체는 곧바로 old 영역으로 복사한다. 비어 있지 않은 survivor 영역 안 살아있는 객체 중 상대적으로 어린 건 (비어 있는) 다른 survivor 영역으로 복사하고, 상대적으로 나이 든 건 old 영역으로 복사한다.

**Note** 비어 있는 survivor 영역이 꽉 차면, eden이나 비어 있지 않은 survivor 영역 안 살아남은 객체 중 복사하지 않은 건 old 영역으로 복사한다. 이 과정은 이렇게 복사되는 객체가 겪은 young collection 횟수와 관계 없다. 살아남은 객체가 다른 영역으로 복사되고 난 뒤 남은 eden과 비어 있지 않은 surviror 영역의 객체는 가비지이고, 자세하게 살펴볼 필요가 없다.
young collection 완료 후에는 eden과 비어 있지 않던 survivor 영역이 비워지고, 이전에 비어 있던 survivor 영역만 살아남은 객체를 가지고 있게 된다. young collection이 한 번 완료될 때마다 survivor 영역이 역할을 바꾸는 것이다.

### old generation
serial GC에서 old 영역과 permanent 영역은 mark-sweep-compact collection 알고리즘으로 가비지를 모은다. mark 단계에서, garbage collector는 아직 살아있는 객체를 식별한다. sweep 단계에서는 영역 안 식별한 가비지를 쓸어담는다. 그 다음엔 sliding compaction을 수행하는데, 살아남은 객체를 old 영역과 permanent 영역의 앞쪽으로 밀고, 반대쪽 끝 끊기지 않고 이어진  저장 공간에 빈 공간을 남겨둔다. compaction을 함으로써 old 영역과 permanent 영역으로 할당 시에 (속도가 빠른) bump-the-pointer를 사용할 수 있다.


## Parallel GC
물리적 메모리와 CPU를 여럿 가진 기기에서 애플리케이션을 실행할 때 GC 작업에 이 자원을 최대한 활용할 수 있도록 한다

### young collection
serial collection에서 사용하는 young collection algorithm의 parallel version을 사용한다. stop-the-world 및 copying collector 방식인 건 같지만, young collection 수행을 병렬로, 여러 대의 CPU를 가지고 하기 때문에 GC에 의한 overhead를 줄이고 애플리케이션 전체 실행 시간 중 GC가 차지하는 비율을 줄여준다.

### old collection
serial collection에서와 마찬가지로 mark-sweep-compact collection algorithm을 사용한다.


## Parallel Old GC(Parallel Compacting GC)
J2SE 5.0 update 6에 처음으로 나왔다. parallel 방식과의 차이점은 old collection에 새로운 알고리즘을 사용한다는 것.

### young collection
parallel 방식에서 young collection에 사용하는 알고리즘과 동일한 것을 쓴다.

### old collection
old 영역과 permanent 영역은 stop-the-world 방식을 사용하고, 대부분은 병렬 방식과 sliding compaction

세 단계로 나뉜다.

첫번째 단계에서, 각 영역을 고정 크기 영역이 되도록 논리적으로 나눈다.

marking 단계에서, 애플리케이션 코드에서 바로 reachable한 살아있는 객체 집합을 GC 스레드별로 분배한다. 그리고 모든 살아있는 객체가 병렬 방식으로 mark된다(marked in parallel). 어떤 객체를 살아있는 것으로 판단하면 해당 객체가 있는 지역에 대한 정보가 업데이트된다. 이 정보는 그 객체의 크기와 위치에 대한 것이다.

summary 단계는 객체가 아니라 (첫번째 단계에서 나눈) 영역별로 동작한다. 이전 collection 중 일어난 compaction으로 인해 각 영역 왼쪽 부분이 살아남은 객체로 높은 밀도를 보일 때가 많다. 이 부분을 compact하더라도 다른 객체를 할당할 수 있는 공간은 그다지 많이 얻을 수 없을 가능성이 높다. 따라서 이 단계에서 처음으로 하는 것은 (첫 번째 단계에서 나눈) 영역의 밀도를 왼쪽부터 살펴서 어떤 시점부터 시작해 오른쪽으로 남은 공간을 compact했을 때 다른 객체를 할당할 수 있는 공간을 얻을 가능성이 높은 지점을 찾는 작업이다. 찾아낸 지점 왼쪽 지역을 dense prefix라고 하며, 이 지역으로는 아무 객체도 옮기지 않는다. 찾아낸 지점 오른쪽 지역에는 compaction을 실행하며, dead space 전부를 없앤다. summary 단계에서 compact가 일어난 지역 각각의 live data가 갖는 첫 byte 위치를 계산하고 저장한다.

compaction 단계에서 GC 스레드는 summary data를 사용해서 채워져야 할 지역을 식별하고, 그러고 나면 여러 스레드가 독립적으로 그 지역에 data를 복사한다. 이 과정은 heap의 한쪽 끝이 밀도 높게 쌓이고 다른 끝은 크게 빈 하나의 블록을 만든다.


## Concurrent Mark & Sweep GC(CMS)
다수의 애플리케이션에서는 빠른 반응 시간이 end-to-end throughput보다 중요하다. young collection 때문에 GC로 인한 중단 시간이 길어지는 경우는 흔치 않다. 그러나 old collection의 경우 자주는 아니지만 중단 시간이 길어지는 경우가 있다. 특히 heap 크기가 클 경우 그렇다. 이러한 문제 해결을 위해 concurrent mark-sweep collector(low-latency collector) 방식을 제공한다.

### young collection
parallel 방식과 동일한 방식으로 동작한다

### old collection
old collection 과정 대부분이 애플리케이션 실행과 동시에 진행된다.

CMS 과정은 initial mark라고 하는 짧은 멈춤으로 시작한다. 이는 애플리케이션 코드로부터 바로 reachable한 살아있는 객체의 초기 집합을 식별하기 위한 것이다. 그 다음 concurrent marking 단계 동안 이 집합으로부터 transitively reachable한 모든 살아있는 객체를 표시한다. marking 단계가 진행될 동안 애플리케이션 실행 및 참조 필드가 업데이트되고 있기 때문에, concurrent marking 단계 종료 시에 모든 살아있는 객체가 표시될 것이라고 확신할 수 없다. 이 점을 처리하기 위해, 애플리케이션이 두 번째로 멈추고(remark), 이때 concurrent  marking phase 동안 변경된 객체를 재점검해서 marking 과정을 마무리한다. 두 번째 멈춤(remark pause)이 첫 번째 멈춤(initial mark)보다 상당히 길기 때문에, 효율 증대를 위해 여러 스레드를 병렬로 돌린다.

remark phase 끝에, heap 안 모든 살아남은 객체가 확실히 표시되고, 이후 단계인 concurrent sweep 단계에 그때까지 식별된 가비지 전부를 reclaim해서 빈 공간으로 만든다.

remark phase 동안의 객체 재점검 등의 동작이 garbage collector가 해야 할 일을 늘리지만, 중단 시간을 줄이기 위한 트레이드 오프로 볼 수 있다.

CMS 방식은 compacting을 하지 않는 유일한 GC 방식이다. 이렇게 함으로써 GC 실행 시간은 줄어들지만, 빈 공간이 서로 떨어져 있기 때문에 다음 객체가 할당될 빈 공간의 위치를 나타낼 때 포인터 결정이 복잡해진다. 할당해야 할 객체의 크기에 맞는 빈 공간을 찾는 것이 어려워진다는 얘기다. 결과적으로 old 영역으로의 할당은 bump-the-pointer 기법을 쓸 수 있었을 때보다 큰 비용을 필요로 한다. 이는 young collection에도 추가적인 overhead를 더하는데, old 영역으로의 할당 대부분이 young collection 중 객체 이동에 의한 것이기 때문이다.

또 다른 단점으로, CMS 방식은 큰 heap을 필요로 한다. marking phase 중에도 애플리케이션이 실행될 수 있기 때문에 old 영역이 계속해서 커질 가능성을 안고 있다. 또한 GC 과정 도중 가비지가 된 객체가 있을 수 있고, 이러한 객체가 차지하는 공간은 다음번 old collection 전까지는 비울 수 없다. 이러한 객체를 floating garbage라고 한다.

compaction이 없기 때문에 파편화가 발생할 수 있다.


## G1(Garbage First) GC


## Z GC
