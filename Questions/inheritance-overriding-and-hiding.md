## Q1. 언제 Overriding이라고 하나?

overriding으로 여겨지는 조건이 정확히 어떤 건지 알고싶었다.

oracle의 java tutorial에서 [overriding 문서](https://docs.oracle.com/javase/tutorial/java/IandI/override.html)를 찾아서 읽어봤다.

> An instance method in a subclass with the same signature (name, plus the number and the type of its parameters) and return type as an instance method in the superclass overrides the superclass's method.

sub class의 인스턴스 메서드가 갖는 시그니처(메서드 이름, 매개변수 숫자와 타입)와 리턴 타입이 super class의 인스턴스 메서드와 같을 경우 sub class의 인스턴스 메서드가 super class의 인스턴스 메서드를 override한다고 한다.

> The ability of a subclass to override a method allows a class to inherit from a superclass whose behavior is "close enough" and then to modify behavior as needed. The overriding method has the same name, number and type of parameters, and return type as the method that it overrides. An overriding method can also return a subtype of the type returned by the overridden method. This subtype is called a covariant return type.

> When overriding a method, you might want to use the @Override annotation that instructs the compiler that you intend to override a method in the superclass. If, for some reason, the compiler detects that the method does not exist in one of the superclasses, then it will generate an error. For more information on @Override, see Annotations.

여기 나오지 않은 요소로는 접근 제한자, 매개변수 이름, 매개변수의 순서를 생각할 수 있었다. 이것들은 바뀌어도 overriding에 문제가 없는지 더 알아봐야겠다.
