# 예외

## 1. 정의
- 예외적인 일(우리가 예상한, 혹은 예상치 못한 일)이 발생하는 것을 미리 예견하고 안전장치를 하는 것
- 예외적인 일이 발생하면, 예외를 던진다


## 2. 종류
- [클래스 상속 구조](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2Frck7c%2FbtrrdmwPijB%2Frl3ZKGr6vz5SwuH96vVnGk%2Fimg.png)
- checked exception(compile-time exception)
- unchecked exception(run-time exception, error)


## 3. unchecked(runtime) vs checked(compiletime)
### checked
- 컴파일할 때 잡아낸다. try-catch로 둘러주거나 throws로 해당 메서드를 호출한 메서드에서 처리하도록 할 수 있다.
- unchecked exception만 나오도록 runtime-exception만 상속하도록 해서 try-catch를 안 써도 괜찮도록 코드를 짜는 경우도 있는데, 이는 자바 디자인 의도를 벗어난다. 일부러 예외가 나오지 않게 하면 안된다는 말이다. 내가 만든 API를 사용하는 클라이언트는 코드에서 어떤 에러가 발생하는지를 알아야만 한다. 그래야 클라이언트가 보고 어떻게 처리할지 선택할 수 있기 때문이다. 이런 면에서 매개변수나 리턴 값만큼이나 예외도 프로그래밍 인터페이스다.
- checked exception의 예: IOException, SQLException, ClassNotFoundException

### unchecked - runtime exception
- 실행할 때 예외가 발생한다. 다시 말하면, unchecked 예외는 컴파일할 때 점검해주지 않는다. 하지만 try-catch를 두를 수 있다. error도 unchecked exception에 포함된다.
- runtime exception의 예: ArrayIndexOutOfBoundsExceptioni, ArithmeticException(ex. 0으로 나누기), NullPointerException

### unchecked - error
- 자바 프로그램 밖에서 발생한 예외
- error는 프로세스에 영향을 주고, exception은 쓰레드에만 영향을 준다
- error의 정의로부터, exception은 프로그램 안에서 발생한 예외로 볼 수 있다

### Q. runtime exception은 왜 점검해주지 않나?
runtime exception의 원인은 프로그래밍에 있다. API 클라이언트 코드에서 해결하거나 조작할 적절한 방법을 예상하기 어렵다. 또한 프로그램 어디서나 발생할 수 있고, 여러군데서 발생할 수 있다. 이걸 점검하기 시작하면 (그래서 try-catch를 넣어야 하면) 프로그램을 읽기 어려워진다.


## 4. 형식
### try-catch
- try 뒤에 예외가 발생하는 문장을 적는다. catch 안에 예외 발생 시 처리를 해준다.
- 예외가 발생한 경우,  try 블록 안 예외가 발생한 줄 이후 문장은 실행되지 않는다
- catch 내 문장은 반드시 실행되고, try-catch 문장 이후의 내용이 실행된다
- finally는 예외 발생과 관계 없이 반드시 실행된다
- catch 블록은 여러 개 만들 수 있다. 이때 더 부모에 해당하는 예외 클래스 catch 블록이 상대적으로 자식에 해당하는 예외 클래스 catch 블록보다 먼저 오면 자식 예외 클래스 catch 블록은 절대 실행될 일이 없기 때문에 컴파일이 되지 않는다.

### 예외 발생시키기
- 예외가 발생할 상황을 개발자가 정할 수 있다.
- try 블록 내에서 throw라고 명시하고 예외 클래스 인스턴스를 생성하면 된다.
- 예외가 발생한 경우, throw 문장 이후 try 블록 내 문장은 실행되지 않고, catch 블록으로 이동한다
- 메서드 선언에 쓰는 throws는 메서드 안에서 발생한 예외를 메서드 안에서 처리할 수 없을 때 그 메서드를 호출한 메서드로 예외를 보내 처리하도록 한다. 이때 throws가 있는 메서드를 호출한 메서드는 try-catch 블록으로 throws가 있는 메서드를 반드시 감싸주어야 한다.

### 내가 예외 만들기
- Throwable이나 그 자식 클래스를 상속해야 한다
- 이러한 예외를 발생시키는 메서드를 호출하는 메서드에서는 내가 만든 예외의 부모 클래스로 catch해도 괜찮다


## 참고 자료
[java tutorial - exception](https://docs.oracle.com/javase/tutorial/essential/exceptions/index.html)
자바의 신 1권 14장(예외)
