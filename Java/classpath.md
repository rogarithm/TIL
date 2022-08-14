##
###
자바 클래스패스는 JVM이 프로그램을 실행할 때 클래스 파일을 찾는 데 기준이 되는 파일 경로를 말한다.
이 문서는 OSX의 terminal에서 javac와 java 명령을 사용하면서 클래스패스 설정을 어떻게 할지 몰라 알아봤던 내용을 정리한 것이다.

javac, java 명령은 .java 파일 안 프로그램을 실행하기 위한 명령이다.
자바 파일을 실행하려면 먼저 javac 명령으로 자바 파일을 컴파일해 클래스 파일을 만들고, 이렇게 만들어진 클래스 파일을 java 명령으로 실행한다. 

##
###
`/java/export` 디렉토리에 `MyClass.java`라는 자바 파일을 만들었다. 이 파일은 Happy Coding!이라는 문자열을 콘솔에 출력하는 프로그램이다.

```
public class MyClass {
  public static void main(String[] args){
        System.out.println("Happy Coding!");
    }
}
```

###
`MyClass.java` 안 프로그램을 실행하려면 먼저 javac 명령으로 클래스파일을 만든다.
```
$ javac MyClass.java
```
명령 실행 후 같은 디렉토리에 MyClass.class 파일이 생성된다.

###
java 명령으로 MyClass 프로그램을 실행한다. 이때 프로그램 이름은 (.class 확장자를 제외한) 클래스의 이름을 넣는다.
```
$ java MyClass
Happy Coding!
```

###
java 명령을 실행할 때 -classpath 옵션으로 실행하고자 하는 클래스의 위치를 설정해주어야 한다. '방금 위에서는 아무 옵션도 설정하지 않았는데'라는 의문이 들 수 있다.
아무 옵션을 주지 않았을 때는 사용자가 현재 위치한 디렉토리를 클래스패스로 설정한다. 즉 `$ java MyClass`는 다음 명령과 같다.
```
$ java -classpath . MyClass
Happy Coding!
```

###
만약 사용자가 MyClass.class 파일이 있는 곳이 아닌 다른 곳에 있을 때 MyClass를 실행해야 한다면, java 명령 실행 시 MyClass.class 파일의 위치를 명시적으로 적어야 할 것이다.
```
$ java -classpath /java/export MyClass
Happy Coding!
```

##
###
패키지를 사용하면 조금 복잡해진다. MyClass.java 파일 첫 줄에 패키지 선언부를 추가했다.
```
package com.sesoon;
```
이제 `MyClass.java` 파일은 `/java/export`에 위치하고 `com.sesoon` 패키지에 포함된다. 이전과 같이 컴파일하고 실행하면 클래스를 찾을 수 없다는 오류가 나온다.
```
$ javac MyClass.java
$ java -cp /java/export MyClass
Error: Could not find or load main class MyClass
Caused by: java.lang.NoClassDefFoundError: com/sesoon/MyClass (wrong name: MyClass)
```
왜냐하면 MyClass.java를 컴파일한 클래스의 이름은 MyClass가 아니라 com.sesoon.MyClass이기 때문이다. 다시 말해 자바 파일에서 패키지를 선언하면 파일 안에 선언된 클래스 이름 앞에 패키지 이름이 붙은 것이 최종적으로 클래스 이름이 된다.

###
그러면 어떻게 해야 할까? 패키지 하위 디렉토리가 있어야 한다. 지금 예에서 이것은 /com 디렉토리 그리고 이 안에 /sesoon 디렉토리가 만들어져 있는 것을 말한다. 정리하면 /com/sesoon/MyClass.class의 구조로 MyClass 클래스 파일이 위치해야 이 클래스를 실행할 수 있다.
javac로 자바 파일을 컴파일하면 클래스 파일은 기본적으로 자바 파일과 같은 경로에 만들어진다. 그래서 이제까지 만들어낸 클래스 파일은 자바 파일과 동일한 디렉토리에 만들어졌다.
필요할 경우 다른 디렉토리에 클래스 파일을 만들 수도 있다. 이때 `d` 옵션을 사용한다. `javac -d 만든-클래스-파일을-넣을-경로 자바-파일-이름`의 형식으로 사용한다.
```
$ javac -d /java/export/classes MyClass.java
```
명령의 결과로 `/java/export/classes` 디렉토리 안에 `MyClass` 클래스 파일이 만들어진다.

###
그런데 패키지 하위 디렉토리는 어떻게 만드나?
```
> tree
.
├── MyClass.java
└── classes
    └── com
        └── sesoon
            └── MyClass.class
```
명령 실행 후 폴더 구조를 확인해보면(여기서는 `tree` 명령을 사용했다), 패키지 하위 디렉토리가 `classes` 디렉토리 아래에 만들어진 것을 확인할 수 있다.
`javac`의 `-d` 옵션으로 클래스를 만들 위치를 설정하면 클래스 파일뿐 아니라 패키지 하위 디렉토리를 만들어준다(해당 디렉토리가 없을 경우).

###
이제 `MyClass`를 실행할 수 있다. 이때 클래스패스는 기본적으로 패키지 하위 디렉토리가 있는 루트 디렉토리를 지정해야 한다. 즉 패키지(`com.sesoon.MyClass`) 가장 앞 요소(여기서는 `com`)를 품는 디렉토리를 말한다. 따라서 여기서는 `/java/export/classes` 디렉토리가 루트 디렉토리가 된다. 또한 클래스 이름은 패키지 이름을 모두 포함해야 한다.
```
$ java -cp /java/export/classes com.sesoon.MyClass
Happy Coding!
```

##
###
만든 자바 파일이 외부 파일(`.class` 파일, `.jar` 파일 등)에 의존하는 경우가 있다. 그럴 경우, `javac` 명령으로 클래스 파일을 생성할 때 (자바 파일을 클래스 패스에 명시하는 것에 더해) 클래스 패스에 의존하는 외부 파일의 경로를 추가해줘야 한다. 예를 들어 `MySQLDriverLoader.java`이라는 자바 파일은 `jdbc` 패키지에 포함되고, `servlet-api.jar` 안의 클래스를 사용하고 있다면(의존하고 있다면), 이 자바 파일을 컴파일할 때는 `-d` 옵션으로 패키지 하위 디렉토리를 만들어야 하고, `-cp` 옵션으로 (자바 파일이 위치한 디렉토리 경로와) 의존하고 있는 `.jar` 파일의 경로를 명시해 주어야 한다.

이때 주의할 것은 의존하고 있는 요소의 경로를 클래스 패스의 앞쪽에 명시해 주어야 한다는 것이다. 그렇지 않으면 에러가 난다.
```
> javac -d /usr/local/tomcat8/webapps/chap14/WEB-INF/classes -cp /usr/local/tomcat8/lib/servlet-api.jar:/usr/local/tomcat8/webapps/chap14/WEB-INF/src/ /usr/local/tomcat8/webapps/WEB-INF/src/jdbc/MySQLDriverLoader.java 
> tree /usr/local/tomcat8/webapps/chap14/WEB-INF/classes/
classes/
└── jdbc
    └── MySQLDriverLoader.class
```



javac 명령의 -d 옵션은 .java 파일에 패키지가 선언되어 있고, 루트 디렉토리로부터 패키지 경로에 해당하는 중간 디렉토리가 없을 경우, 중간 디렉토리를 만들 기준 경로를 지정한다.
/export/java라는 루트 디렉토리가 있고, com.example.MyClass로 MyClass.java 소스가 정의되어 있다고 하자. 여기서 루트 디렉토리로부터 .java 소스까지의 중간 경로는 com.example이다.
$ cd /export/java
$ javac -d . com.example.MyClass
위와 같이 실행하면 

<MyClass.java>
package com.mine;
...

javac MyClass.java 명령의 결과는 /export/java/test 디렉토리 아래 MyClass.class 파일을 생성한다.
java 파일에 패키지를 명시하면 그 파일을 컴파일한 결과로 얻은 클래스는 패키지 이름도 붙은 이름을 실제 이름으로 갖는다

javac -d . MyClass.java 명령의 결과는 MyClass.java의 패키지 하위 디렉토리를 생성하고 그 안에 MyClass.class 파일을 생성한다.
/export/java/test
 /com
  /MyClass.class
여기서 -d 옵션의 역할은 무엇인가? -d 옵션을 주지 않으면 왜 패키지 경로에 대해 디렉토리를 만들지 않지?
-d 옵션은 패키지 디렉토리를 만들 기준 경로를 결정한다. (패키지 디렉토리가 없을 경우)

클래스패스에 jar 경로를 명시한 다음 java 명령으로 jar 경로의 클래스를 실행하면 jar 경로의 클래스가 없어도 실행되나? 즉 실행되는 건 실제로 jar인가? -> jar


java 명령과 javac 명령에서 -cp 옵션은 이렇게 다른 뜻을 갖는다:

.class 파일 실행 시 영향을 주는 것
 실행하려는 .class 파일의 위치와 터미널에서 현재 내 위치
  같으면 별 문제 없지만, 다르면 .class 파일 위치를 명시해야 한다.
 실행 .class 파일과 연관되는 또는 종속 관계인 .class, .jar 파일의 위치

.java 파일로부터 .class 파일 생성 시 영향 주는 것
 .class 파일로 만들려는 .java 파일의 패키지 포함 여부
 .class 파일을 생성할 위치 = javac -cp 옵션
 javac -d 옵션: 패키지 하위 디렉토리 생성할 위치
 package com.oracle;일 경우 /com/oracle 디렉토리이고, class 파일은 /com/oracle/....class 위치에 온다

주의
 -cp 옵션 값 앞뒤에 쌍따옴표를 붙이지 않는다
 -cp에 들어갈 값이 여러 가지라면, : 문자로 구분한다
