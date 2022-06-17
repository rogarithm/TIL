# 공식 문서에서 얘기하는 member는 어떤 걸 말하는가?

[API 문서](https://docs.oracle.com/javase/8/docs/api/java/lang/reflect/Member.html#:~:text=Member%20is%20an%20interface%20that,a%20method)에서 member를 찾아봤다:
Member is an interface that reflects identifying information about a single member (a field or a method) or a constructor. Member는 필드 또는 메서드라고 하고 있다. 그런데 API 문서의 member라서 그냥 member라는 이름을 가진 클래스에 대한 설명인 것 같다. 조금 더 명확한 설명이 있는지 찾아봤다.

[java specification 문서](https://docs.oracle.com/javase/specs/jls/se17/html/jls-8.html#jls-8)에서 member에 대해 간단히 정의하고 있다:
The body of a class declares members (fields, methods, classes, and interfaces), ...

클래스 몸체에서 member를 선언한다. member에는 field, methods, classes, interfaces가 있다.
- fields: class variable, instance variable을 class field, instance field라고도 한다.
- classes: nested classes, inner classes를 의미한다.
- interfaces: nested interfaces를 의미한다.
- constructor, static initializer, instance initializer는 method가 아니다.
