## Node
- 일종의 자료구조 부품
- 자료구조를 구성하는 개별 정보를 표현한다.
- 값(과 다른 노드로의 링크)으로 구성되며 노드와 노드를 잇는 연결부를 edge라고 한다.

## Binary seasrch tree (BST, ordered binary tree, sorted binary tree)
- internal node(자식 노드가 하나 이상인 노드)의 key 값이 왼편 subtree의 모든 key 값보다 크고, 오른편 subtree의 모든 key 값보다 작은, root node가 있는 tree
- 동작의 시간 복잡도는 tree height에 비례한다.
- 이진 검색으로 item을 빠르게 검색, 추가, 삭제할 수 있다.
- BST를 구성하는 노드는 "왼편 subtree의 모든 키 값 < internal node 키 값 < 오른편 subtree의 모든 키 값"의 일정한 논리로 배열되기 때문에 원하는 노드를 찾는 계산 과정마다 계산할 노드 갯수가 남은 노드의 절반으로 줄어들어 검색 성능이 2를 밑으로 하는 로그에 비례한다.
- 최악의 경우 (한 방향으로만 tree가 그려진 경우) tree 연산의 시간 복잡도는 O(n)이 된다. 이런 최악의 경우에 해당하는 BST도 정렬되지 않은 배열보다 성능이 좋다.
- 최악의 경우를 완화하기 위해 스스로 균형을 맞추는(self-balancing) BST도 있다.

## Self-balancing binary search tree
- tree height (root 노드로부터 가장 하위 노드까지의 level; depth)가 최대한 작도록 자동으로 유지한다
- height-balanced binary tree는 tree height를 log n에 비례하도록 한다(이때 n은 item 갯수). n으로부터 tree에 들어갈 수 있는 node 갯수의 최대값을 h와 연관지어 나타내고, 이를 다시 h에 관한 식으로 풀면 노드 갯수가 n일 때 최소 height 값은 (밑이 2인) log n이다.

## Red-black tree
- self-balancing binary search tree의 일종
- 삽입, 삭제 연산 도중 balanced 상태를 유지하는지 확인하려고 노드마다 추가 비트를 써서 색깔(빨강, 검정) 정보를 저장한다.
- 트리가 수정되면, "새로운 트리"가 재배치 및 다시 색칠되어 최악의 경우 트리가 얼마나 불균형할지를 알아낸다.
