# protected, package-private access modifiers

## 자료 조사

#### 접근 제어자는 어디에 적용할 수 있나?
- class member, constructor<br>
- class member는 field, method, class, interface를 의미한다<br>

## 테스트
- 공식 문서를 이해하기 어려워서 잘 모르는 조건을 정리해서 테스트해보기로 했다<br>
- 가능한 조건이 이해가 안가는 package-private과 protected 접근 제한자에 대해 테스트한다<br>
- 두 접근 제어자를 갖는 클래스 member는 어떤 상황에서 접근 가능한지를 확인한다<br>
- member 중 field와 method에 대해 테스트한다<br>

### 1. protected
**protected member는 같은 패키지 내에 있는 클래스의 member나 protected member가 속한 클래스를 상속받는 클래스의 member에서 접근할 수 있다**

#### 1-1. 접근 가능한 경우<br>

- 1-1a. 같은 패키지, 상속받지 않은 클래스 member는 protected인 member에 접근할 수 있다<br>
test.accessControl.protected.Parent / test.accessControl.protected.Other<br>

- 1-1b. 같은 패키지, 상속받은 클래스 member는 protected인 member에 접근할 수 있다<br>
test.accessControl.protected.Parent / test.accessControl.protected.Child<br>

- 1-1c. 다른 패키지, 상속받은 클래스 member는 protected인 member에 접근할 수 있다<br>
test.accessControl.protected.Parent / test.accessControl.protected.bastard.Child<br>

#### 1-2. 접근 불가능한 경우<br>

- 1-2a. 다른 패키지 안에 있고 상속받지 않은 클래스 member는 protected인 member에 접근할 수 없다<br>
test.accessControl.protected.Parent / test.accessControl.protected.completely.Other<br>



### 2. package-private
**package-private member는 같은 패키지 내에 있는 클래스의 member에서 접근할 수 있다**

#### 2-1. 접근 가능한 경우 - 상속 여부와 관계 없이 같은 패키지 내 클래스 member<br>

- 2-1a. 같은 패키지, 상속받은 클래스 member는 package-private인 member에 접근할 수 있다<br>
test.accessControl.packagePrivate.Parent / test.accessControl.packagePrivate.Child<br>

- 2-1b. 같은 패키지, 상속받지 않은 클래스 member는 package-private인 member에 접근할 수 있다<br>
test.accessControl.packagePrivate.Parent / test.accessControl.packagePrivate.Other<br>

#### 2-2. 접근 불가능한 경우 - 상속 여부와 관계 없이 다른 패키지 클래스 member<br>

- 2-2a. 다른 패키지, 상속받은 클래스 member는 package-private인 member에 접근할 수 없다<br>
test.accessControl.packagePrivate.Parent / test.accessControl.packagePrivate.bastard.Child<br>

- 2-2b. 다른 패키지, 상속받지 않은 클래스 member는 package-private인 member에 접근할 수 없다<br>
test.accessControl.packagePrivate.Parent / test.accessControl.packagePrivate.completely.Other<br>


## 추가 질문
- top-level vs member-level
- 접근하려는 member의 접근 제한자는 접근 가능한지와 관계가 없나?
- 접근하는/접근 당하는 기준 클래스의 조건이 있나?
- private class member에서 package-private member에 접근할 수 있나?
- private class 안에 public method가 선언될 수 있나?

## 참고 자료
- https://docs.oracle.com/javase/tutorial/java/javaOO/accesscontrol.html
- https://docs.oracle.com/javase/specs/jls/se17/html/jls-6.html#jls-6.6
