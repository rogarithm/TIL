# Reference

### 개념
java language specification에서는 reference를 다음과 같이 정의한다:
> The reference values (often just references) are pointers to objects, and a special null reference, which refers to no object([jls 4.3.1](https://docs.oracle.com/javase/specs/jls/se7/html/jls-4.html#jls-4.3.1)).<br>

reference(reference value)는 object를 향하는 포인터 또는 아무 object도 가리키지 않는 null reference다.

#### Q1. 자바의 신 108p에서 나온 변수에 대한 참조가 무슨 의미인가?
책에서는 ++ 단항 연산자의 두 경우(++var와 var++)를 비교하면서 계산하는 시기와 변수를 참조하는 시기가 차이난다고 설명한다.<br>

여기서 다음 의문이 들었다:<br>
- reference 정의에는 object만 이야기하고 있다. primitive type은 object가 아닌데 참조라는 단어를 쓸 수 있나?
- 아니면 참조의 대상은 변수이므로, object가 변수를 포함하는지 알아봐야 하나?
- 여기서 말하는 참조는 자바 명세에 나와있는 reference와는 다른 것을 말하나?

#### ++ 단항 연산자 관련 문서를 찾아봤다:
prefix([jls 15.15.1](https://docs.oracle.com/javase/specs/jls/se7/html/jls-15.html#jls-15.15.1))
> The value of the prefix increment expression is the value of the variable after the new value is stored.<br>
표현식의 값이 새로운 값이 저장된 후 변수가 가지고 있는 값이다.<br>

postfix([jls 15.14.2](https://docs.oracle.com/javase/specs/jls/se7/html/jls-15.html#jls-15.14.2))
> The value of the postfix increment expression is the value of the variable before the new value is stored.<br>
즉 표현식의 값이 새로운 값이 저장되기 전 변수가 가지고 있는 값이다.<br>

연산자를 사용한 결과가 다른 것에 대해서는 알 수 있었지만, 들었던 의문은 해결하지 못했다.<br>
모르는 개념은 넘어갔는데, 문서의 다른 부분을 좀 더 살펴봐야 할 것 같다.
