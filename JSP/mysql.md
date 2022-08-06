## 터미널에서 실행하기
- mysql을 dmg 파일로 설치하면 `/usr/local` 아래 설치된다.
- 터미널에서 mysql을 실행하려면 `/usr/local/mysql/bin` 디렉토리로 이동 후 `$ ./mysql -u유저이름 -p` 명령을 실행 후 해당 유저 아이디에 대한 비밀번호를 입력해주면 된다.
  + `$ cd /usr/local/mysql/bin && ./mysql -uroot -p`
  + 처음 만들어지는 root 계정의 경우 `$ ./mysql -uroot -p`

## 더 간단하게 실행하려면?
- `$ cd /usr/local/mysql/bin && ./mysql -uroot -p` 대신 `$ mysql -uroot -p`로 하려면?
- `~/.bash_profile` 파일에 다음 내용을 추가한다. `export PATH=$PATH:/usr/local/mysql/bin`

## No database selected 에러
- 데이터베이스 조작이 안되고 `ERROR 1046 (3D000): No database selected`라는 에러 메시지가 나오는 상황
```
mysql> insert into members (memberid, password, name)
    -> values ('madvius', '1234', '최범균');
ERROR 1046 (3D000): No database selected
mysql> insert into MEMBERS (MEMBERID, PASSWORD, NAME)
    -> values ('madvius', '1234', '최범균');
ERROR 1046 (3D000): No database selected
mysql> select * from MEMBERS;
ERROR 1046 (3D000): No database selected
```
- 이 에러는 database가 선택되지 않아서 발생한다. 
- `$ show databases;` 후 `$ use 데이터베이스명;`으로 데이터베이스를 선택해주면 이후 명령을 실행할 수 있다.
```
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| chap14             |
| information_schema |
+--------------------+
2 rows in set (0.00 sec)

mysql> use chap14;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> select * from members;
+----------+----------+-----------+-----------------------+
| MEMBERID | PASSWORD | NAME      | EMAIL                 |
+----------+----------+-----------+-----------------------+
| eral13   | 5678     | 최범균    | madvirus@madvirus.net |
| madvirus | 1234     | 최범균    | NULL                  |
+----------+----------+-----------+-----------------------+
2 rows in set (0.01 sec)
```

## Could not create connection to database server 에러
- tomcat으로 mysql 데이터베이스에 접근하려고 할 때 이 에러가 발생할 수 있다.
- 이 에러는 DB 버전과 드라이버 버전 차이가 나서 [발생할 수 있다](https://needneo.tistory.com/198).
- mysql가 8.0.17, mysql-connector는 mysql-connector-java-5.1.35인 경우 발생함을 확인했다.
- mysql-connector 버전을 mysql-connector-java-8.0.17로 변경했을 때 에러가 사라졌다.
- 프로젝트에 포함할 mysql-connector 파일 포맷이 .bin.jar이었는데, 최근 버전의 경우 이 포맷이 더 이상 [만들어지지 않는 것 같다](https://community.atlassian.com/t5/Confluence-questions/Can-t-find-mysql-connector-java-8-0-xx-bin-jar/qaq-p/1466268). 대신 .jar 포맷을 넣으면 된다. 

## The server time zone value 'KST' is unrecognized or represents more than one time zone 에러
- MySQL Connector/J  8.0 이후 버전에서는 수동으로 기본 시간대를 설정해주어야 connection 문제가 생기지 않는다.
- mysql 설정 파일에 time zone을 설정해주면 된다.
- mysql 설정 파일 my.cnf는 macOS에서 mysql 설치 시 [만들지 않는다](https://stackoverflow.com/a/10757261).
- mysql 설정 파일 위치로 다양한 선택지가 있는데, 그 중 하나로 `/etc/my.cnf`를 만들 수 있다. 참고로 `/etc` 디렉토리에서는 관리자 권한으로 파일 생성 및 편집할 수 있다.

```
$ cd /etc
$ sudo touch my.cnf
$ vim my.cnf
```

- time zone은 UTC를 기준으로 빠르면 +, 느리면 - 기호 뒤에 시간 차이를 적어준다.
- 한국의 time zone 인 Asia/Seoul 은 UTC 보다 9시간 빠르므로 아래와 같이 적어주면 된다.

```
[mysqld]
default_time_zone = '+09:00'
```

- [참고](https://www.lesstif.com/dbms/mysql-jdbc-the-server-time-zone-value-kst-is-unrecognized-or-represents-more-than-one-time-zone-100204548.html#MySQLJDBC%EC%97%90%EB%9F%AC%ED%95%B4%EA%B2%B0%22Theservertimezonevalue'KST'isunrecognizedorrepresentsmorethanonetimezone.%22-mysql%EC%84%9C%EB%B2%84%EC%97%90timezone%EC%84%A4%EC%A0%95)

## mysql에서 테이블 생성 시 MEMBER를 테이블 이름으로 하면 Error 1064 발생
- mysql 8.0.17 버전에서 [MEMBER는 키워드로 할당](https://dev.mysql.com/doc/refman/8.0/en/keywords.html)되어 있기 때문에 테이블 이름으로 사용할 수 없다.
- 하지만 8.0.19부터 다시 할당되지 않기 때문에 일부 버전에서만 이 문제가 생긴다.
