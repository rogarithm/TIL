# java의 member

### [API 문서](https://docs.oracle.com/javase/8/docs/api/java/lang/reflect/Member.html#:~:text=Member%20is%20an%20interface%20that,a%20method)에서 설명하는 member
> Member is an interface that reflects identifying information about a single member (a field or a method) or a constructor.<br>

member는 **필드 또는 메서드라**고 써있다. 하지만 좀 더 생각해보니 설명이 너무 짧고, member에 대한 설명이라기보단 Member라는 이름을 가진 클래스에 대한 설명 중에 member에 대해 간단하게 나온 것 같았다. 조금 더 명확한 설명이 있는지 다른 문서를 찾아봤다.<br>

### [java specification 문서](https://docs.oracle.com/javase/specs/jls/se17/html/jls-8.html#jls-8)에서 설명하는 member
java specification 문서에서는 각 장의 처음에서 그 장에 나오는 개념들에 대해 간단히 소개한다. 이 중 member에 대해 이렇게 설명하고 있다.<br>
> The body of a class declares members (fields, methods, classes, and interfaces), ...<br>

member는 **클래스 몸체에서 선언**되며, **field, methods, classes, interfaces가 member로 분류**된다.<br>

member로 분류되는 요소 중 method를 제외하고는 의미를 명확히 알 수 없어 찾아봤다.<br>
- fields: class variable이나 instance variable을 field라고 한다.<br>
- classes: nested classes나 inner classes 같이 클래스 안에 선언된 클래스를 의미한다.<br>
- interfaces: nested interfaces를 의미한다.<br>

\* 추가로 constructor, static initializer, instance initializer는 member가 아니다.<br>

아직 member로 분류되는 class와 interface에 대해서는 잘 모르겠다. member라고 나오면 field와 method를 생각하고, 더 알아야 할 필요가 있을 때 추가로 조사하는 것이 좋을 것 같다.<br>
(member에 대한 자세한 설명은 이 문서의 8장에 나오며, 추후 더 상세한 정보가 필요할 경우 문서를 다시 보면 될 것 같다.)
