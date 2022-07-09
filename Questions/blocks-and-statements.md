## Q1. `try-catch-finally` 실행 시 `catch` 블록 안에 `return` 문이 있다면 `finally` 가 실행이 되나?

### 질문의 의도
질문은 다음 코드와 같은 상황에서 finally 안 문장이 실행될 것인가?를 묻는 것이다.
```
try {
} catch () {
..
return;
} finally {
}
```

### 테스트
확인을 위해 테스트용 코드를 짰다.
```java
public class FinallySample {
	public static void main(String[] args) {
		FinallySample sample = new FinallySample();
		sample.finallySample();
	}

	public void finallySample() {
		int[] intArray = new int[5];
		try {
			System.out.println(intArray[5]);
		} catch (Exception e) {
			System.out.println(intArray.length);
			return;
		} finally {
			System.out.println("Here is finally");
		}
		System.out.println("This code must run.");
	}
}
```
결과는 다음과 같았다.
```bash
5
Here is finally
```

### 왜 `return`이 `catch`문 안에 있음에도 불구하고 `finally` 안 문장이 실행되었나?

[jls 14.17. The return Statement](https://docs.oracle.com/javase/specs/jls/se8/html/jls-14.html#jls-14.17) 끝에 다음과 같은 설명이 있었다:
> The preceding descriptions say "attempts to transfer control" rather than just "transfers control" because **if there are any try statements (§14.20) within the method or constructor whose try blocks or catch clauses contain the return statement, then any finally clauses of those try statements will be executed, in order, innermost to outermost, before control is transferred to the invoker of the method or constructor**. Abrupt completion of a finally clause can disrupt the transfer of control initiated by a return statement.

`return`이 바로 제어권을 넘기지 않는 경우도 있다. 메서드나 생성자 내에 `try` 블록이나 `catch` 문장이 있고, 이 안에 `return` 문장이 있을 경우, 그 `try` 블록의 `finally` 문장은 메서드나 생성자를 부른 곳으로 제어권이 넘어가기 전에 실행된다.

### Q. `return`이 `catch`문 안에 있을 때 `System.out.println("This code must run.")`은 실행되지 않았다. 왜 그런가?

예상하기로는 return이 finally 안 문장 실행 후 실행되어 `System.out.println("This code must run.")`이 실행되지 않은 것 같다.
