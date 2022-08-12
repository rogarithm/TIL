##
###
- 자바로 배우는 핵심 자료구조와 알고리즘이라는 책으로 자료구조를 연습하기 시작했다.
- 예제 코드가 ant를 빌드 시스템으로 사용하고 있으나 역자가 gradle을 빌드 시스템으로 하는 소스를 추가했다.
- 결국 잘 안되서 ant로 실습을 진행하기로 했지만 gradle로 테스트 환경을 설정하려고 시도해보면서 해결한 이슈가 있어 기록해둔다.

## build.gradle 파일 생성
###
가장 먼저 `gradle init` 명령으로 build.gradle 파일을 만들어야 한다.
```bash
$ gradle init
Task :init SKIPPED
The build file 'build.gradle' already exists. Skipping build initialization.
```
내 경우 이미 있었다.

## gradlew 실행 권한 설정
###
gradlew 스크립트에 실행 권한이 설정되어 있지 않아 명령 실행이 되지 않았다.
```
$ ./gradlew build
-bash: ./gradlew: Permission denied
```

chmod 명령으로 실행 권한을 바꿨다.

```
$ chmod a+x gradlew
```

## gradlew로 빌드
###
빌드를 시도했을 때 클래스를 찾지 못했다는 에러가 발생했다.
```
$ ./gradlew build
Error: Could not find or load main class org.gradle.wrapper.GradleWrapperMain
Caused by: java.lang.ClassNotFoundException: org.gradle.wrapper.GradleWrapperMain
```

이 디렉토리에서 설정한 버전의 gradle.jar 파일이 없으면 나는 오류였다. 찾아보니 프로젝트 폴더 내 gradle.jar 파일이 없었다.

###
build.gradle 파일을 수정하는 방법이 있어서 시도해봤다.
`$ vim build.gradle`

```
task wrapper(type: Wrapper) {
    gradleVersion = '4.4'
}

...
```

변경한 다음에도 오류가 났다.
```
$ gradle wrapper
FAILURE: Build failed with an exception.

* Where:
Build file '/Users/sehun/study/dast/intellij/code/build.gradle' line: 1

* What went wrong:
A problem occurred evaluating root project 'code'.
> Cannot add task 'wrapper' as a task with that name already exists.

* Try:
> Run with --stacktrace option to get the stack trace.
> Run with --info or --debug option to get more log output.
> Run with --scan to get full insights.

* Get more help at https://help.gradle.org

BUILD FAILED in 1s
```

###
명령 옵션으로 gradle 버전을 명시하는 방법이 있어 시도해봤다.
```
$ gradle wrapper --gradle-version 4.4 --distribution-type all

BUILD SUCCESSFUL in 1s
1 actionable task: 1 executed
```

성공. gradle.jar 파일이 생성되었다.
