# field vs variable
### 변수와 필드는 어떤 차이가 있나?
공부하면서 자바 관련 책을 읽다보니 변수가 들어갈 것 같은 곳에서 필드라는 용어가 나와서 어떤 차이가 있는지 찾아봤다.<br>
[java tutorial-variables](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/variables.html)에서는 변수의 종류를 다음과 같이 나눈다.<br>

- instance variables(non-static fields)
- class variables(static fields)
- local variables
- parameters

변수 중 instance variables, class variables를 각각 non-static fields와 static fields로 부르며, 필드는 이 둘을 이야기한다.<br>
이렇게 하면, 말하고자 하는 변수의 범위를 조절해서 말할 수 있다:
- field에 해당하는 변수 종류에만 적용할 수 있는 경우 field라고 하고,
- 모든 변수 종류에 적용할 수 있는 경우 variable이라고 하며,
- 이외 한 가지 변수에 적용할 수 있는 경우는 그 변수 종류만 적어주면 된다
