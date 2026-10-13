# MICRM Sales

마케팅 캠페인 발송 · 고객 관리 시스템.
Salesforce Marketing Cloud(SFMC) Journey Builder 와 연동되어 이메일 · 문자(SMS/LMS/MMS) ·
카카오 알림톡/친구톡 · RCS 채널로 캠페인을 발송하고, 발송 결과와 비용을 리포팅한다.
쿠폰 발급 · 관리 기능을 포함한다.

| 항목 | 값 |
|---|---|
| 저장소 | `https://git.milvusapp.com:8001/dx/developers/micrm_sales.git` |
| Group / Artifact | `com.omnilab` / `micrm` |
| 버전 | `0.0.1-SNAPSHOT` |
| 패키징 | `war` |
| 기준 브랜치 | `feat/readme` (base: `d2bcf7a9`) |

---

## 목차

1. [기술 스택](#1-기술-스택)
2. [시스템 요구사항](#2-시스템-요구사항)
3. [프로젝트 구조](#3-프로젝트-구조)
4. [환경 설정](#4-환경-설정)
5. [데이터베이스](#5-데이터베이스)
6. [설치 및 실행](#6-설치-및-실행)
7. [화면 · 메뉴 구조](#7-화면--메뉴-구조)
8. [주요 설정 클래스](#8-주요-설정-클래스)
9. [개발 가이드](#9-개발-가이드)
10. [알려진 제약](#10-알려진-제약)

---

## 1. 기술 스택

### 1.1 개발 언어

| 언어 | 버전 | 용도 | 규모 |
|---|---|---|---|
| **Kotlin** | 1.8.10 | 주 개발 언어. 컨트롤러 · 서비스 · DAO · 설정 전부 | 227 파일 / 25,733 라인 |
| **Java** | 11 | 공통 유틸리티 (`CommonUtils` 등) | 10 파일 / 3,141 라인 |
| **JSP / JSTL** | 2.3 / 1.2 | 화면 템플릿 | 81 파일 / 44,146 라인 |
| **JavaScript** | ES5+ | 화면 스크립트 (jQuery 기반) | 정적 JS 346 파일 |
| **SQL** | MariaDB 방언 | MyBatis XML 매퍼 | 15 파일 / 약 6,800 라인 |

Kotlin 과 Java 를 같은 모듈에서 혼용한다. `kotlin-maven-plugin` 이 먼저 컴파일하고
`maven-compiler-plugin` 이 뒤따르는 구성이라 Java 에서 Kotlin 클래스를 참조할 수 있다.
두 플러그인 모두 `src/main/java` 와 `src/main/kotlin` 을 소스 루트로 등록한다.

### 1.2 프레임워크 · 라이브러리

| 구분 | 라이브러리 | 버전 |
|---|---|---|
| 애플리케이션 | Spring Boot | 2.7.10 |
| 웹 | Spring Web MVC | 5.3.x (`@EnableWebMvc` 수동 구성) |
| 보안 | Spring Security | 5.7.x |
| 뷰 레이아웃 | Apache Tiles | 3.0.8 |
| 뷰 보조 | SiteMesh | 3.0.1 |
| 영속성 | MyBatis / MyBatis-Spring | 3.5.13 / 2.1.0 |
| DB 드라이버 | MariaDB Java Client | (Boot BOM) |
| 커넥션 풀 | HikariCP | (Boot BOM) |
| SQL 로깅 | log4jdbc-log4j2 | 1.16 |
| 설정 암호화 | Jasypt Spring Boot | 3.0.5 |
| XSS 방어 | naver lucy-xss-servlet | 2.0.1 |
| 페이징 | eGovFrame RTE PTL MVC | 3.5.0 |
| 엑셀 | Apache POI / xlsx-streamer | 4.0.1 / 2.2.0 |
| 파일 업로드 | commons-fileupload | 1.5 |
| 오브젝트 스토리지 | MinIO | 8.4.3 |
| HTTP 클라이언트 | Apache HttpClient / OkHttp | - / 4.10.0 |
| JSON | Gson / Jackson | 2.10.1 / (Boot BOM) |
| JWT | jjwt | 0.9.1 |
| SFMC SDK | fuelsdk | 1.6.0 |
| QR 코드 | zxing core / javase | 3.5.3 |
| 모바일 판별 | spring-mobile-device | 1.1.5.RELEASE |
| 메일 / FTP | spring-boot-starter-mail / spring-integration-ftp | (Boot BOM) |
| 내장 WAS | tomcat-embed-jasper | **9.0.31** (`tomcat.version` 으로 고정) |

### 1.3 프론트엔드

`WEB-INF/layout/base-header.jsp` 에서 전역 로드한다.

```
jquery-3.6.0.min.js      jquery.validate.min.js   jquery-ui.min.js
common.js                popup.js                 moment.min.js
fullcalendar.min.js      Chart.min.js             progressbar.min.js
ckeditor/ckeditor.js     swiper.min.js            timepicki.js
```

화면별로 `imageUpload.js`, `smsCreate.js`, `edmCreate.js`, `mcdonalds_coupon.js`,
`sortable.js`, `html2canvas.js`, `tableau.js` 등을 추가 로드한다.

---

## 2. 시스템 요구사항

| 항목 | 요구 사항 |
|---|---|
| JDK | **11** — `java.version`, `kotlin.compiler.jvmTarget` 모두 11 |
| Maven | 3.6 이상 |
| 네트워크 | **사내 Nexus 접근 필수** (아래 참조) |
| WAS | Apache Tomcat **9.x** (서블릿 4.0 / JSP 2.3) |
| DB | MariaDB 10.x |
| 외부 연동 | MinIO, SMTP, 문자 발송 게이트웨이, SFMC |

### 사내 Nexus 접근이 반드시 필요하다

`egovframework.rte.ptl.mvc:3.5.0` 은 **Maven Central 에 없고** `pom.xml` 에 선언된
사내 저장소에서만 받을 수 있다.

```xml
<repositories>
    <repository>
        <id>omnilab-repo-snapshot</id>
        <url>https://repo.milvusapp.com:8001/repository/Omnilab-repo-snapshot/</url>
    </repository>
    <repository>
        <id>omnilab-repo-release</id>
        <url>https://repo.milvusapp.com:8001/repository/Omnilab-repo-release/</url>
    </repository>
</repositories>
```

사내망(또는 VPN) 연결 없이 빌드하면 다음과 같이 실패한다.

```
[ERROR] Failed to execute goal on project micrm: Could not resolve dependencies
[ERROR] dependency: egovframework:egovframework.rte.ptl.mvc:jar:3.5.0 (compile)
```

---

## 3. 프로젝트 구조

```
micrm_sales/
├── pom.xml                      # 빌드 정의, 프로파일(local/dev/prd), 사내 저장소
├── README.md
├── robots.txt
├── .gitlab-ci.yml               # GitLab CI (10장 참조)
└── src/
    ├── main/
    │   ├── kotlin/com/omnilab/micrm/
    │   │   ├── MicrmApplication.kt      # 부트 진입점
    │   │   ├── common/                  # CommonUtils, UsefulUtils, FileUploadUtils 등
    │   │   ├── config/
    │   │   │   ├── DatabaseConfig.kt        # DataSource, SqlSessionFactory, 트랜잭션
    │   │   │   ├── MvcConfig.kt             # 뷰 리졸버, 컨버터, 필터, 정적 자원
    │   │   │   ├── SecurityConfig.kt        # URL 인가, 로그인/로그아웃
    │   │   │   ├── OtherConfig.kt           # RestTemplate, MinIO 등 외부 연동 빈
    │   │   │   ├── ServletInitializer.kt    # WAR 배포 초기화, 리스너 등록
    │   │   │   ├── adapter/                 # 외부 시스템 어댑터
    │   │   │   ├── error/                   # 에러 처리
    │   │   │   ├── handler/                 # 필터 · 인터셉터 · 예외/인증 핸들러
    │   │   │   ├── listener/                # SessionListener
    │   │   │   └── view/                    # DownloadView, ExcelDownloadView, PrintView
    │   │   ├── controller/              # 컨트롤러 15개
    │   │   ├── service/                 # 서비스 인터페이스
    │   │   │   └── impl/                # 서비스 구현 20개
    │   │   ├── repository/              # DAO 인터페이스
    │   │   │   └── impl/                # SqlSession 기반 DAO 구현
    │   │   ├── mapper/                  # MyBatis 매퍼 인터페이스
    │   │   ├── model/                   # 검색 · 뷰 DTO
    │   │   │   └── table/               # 테이블 1:1 DTO (@Alias 부여)
    │   │   └── task/                    # ThreadPool, ThreadPoolImpl
    │   │
    │   ├── java/com/omnilab/micrm/common/   # Java 공통 유틸
    │   │
    │   ├── resources/                   # 환경 무관 공통 자원
    │   │   ├── application.properties   # 공통 서블릿 / MVC 설정
    │   │   ├── tiles.xml                # Tiles 레이아웃 정의
    │   │   ├── banner.txt
    │   │   ├── log4jdbc.log4j2.properties
    │   │   ├── lucy-xss-sax.xml                  # XSS 필터 규칙(SAX)
    │   │   ├── lucy-xss-servlet-filter-rule.xml  # XSS 필터 URL 규칙
    │   │   ├── locale/                  # 메시지 번들
    │   │   ├── mybatis/
    │   │   │   ├── mybatis-config.xml
    │   │   │   └── mapper/*.xml         # 매퍼 15개
    │   │   └── static/                  # css, js, image, font, html, download, sf
    │   │
    │   ├── resources-local/             # ─┐ 프로파일별 자원 (빌드 시 택일)
    │   ├── resources-dev/               #  ├  application.yml
    │   ├── resources-prd/               # ─┘  logback.xml, static/sf
    │   │
    │   └── webapp/WEB-INF/
    │       ├── web.xml                  # 에러 페이지 정의
    │       ├── layout/                  # Tiles 레이아웃 5개
    │       ├── views/                   # 화면 JSP (도메인별)
    │       │   └── **/ajax/             # ajax 로 주입되는 조각 JSP
    │       └── tlds/                    # 커스텀 태그 (Commonutils.tld)
    │
    └── test/
        ├── java/template_kotlin/
        └── kotlin/com/mablic/template_kotlin/
```

### 3.1 계층 구조

```
Controller  →  Service(interface)  →  ServiceImpl  →  DAO(interface)  →  DaoImpl
                                                                            │
                                            sqlSession.selectOne("statementId", dto)
                                                                            │
                                                          mybatis/mapper/*.xml 의 <select id="...">
```

이 프로젝트는 **MyBatis 매퍼 인터페이스를 쓰지 않는다.** DAO 구현체가 `SqlSession` 에
**statement id 문자열**을 직접 넘긴다. 따라서 매퍼 XML 의 `id` 와 문자열이 어긋나면
컴파일은 통과하고 **런타임에 실패한다.**

```kotlin
@Component("SysUserDaoImpl")
class SysUserDaoImpl : SysUserDao {
    @Autowired private lateinit var sqlSession: SqlSession

    override fun getUserList(dto: Tblmi_usrDto): List<Usr_searchDto> =
        sqlSession.selectList("getUserList", dto)   // ← 매퍼 XML 의 id 와 일치해야 함
}
```

### 3.2 DTO 별칭

`mybatis-config.xml` 이 `com.omnilab.micrm.model` 패키지를 별칭 스캔 대상으로 등록하고,
각 DTO 에 `@Alias` 가 붙어 있어 매퍼에서 패키지 없이 참조한다.

```kotlin
@Alias("Tblmi_usr_authDto")
open class Tblmi_usr_authDto {
    var usr_id: String? = null
    var role_cd: String? = null
    // ...
}
```

```xml
<select id="getUserList" parameterType="Tblmi_usrDto" resultType="Usr_searchDto">
```

> `mapUnderscoreToCamelCase` 는 **비활성**이다. DTO 프로퍼티명을 DB 컬럼명과 동일한
> 스네이크 케이스(`usr_grp_cd`)로 선언해야 매핑된다.

---

## 4. 환경 설정

### 4.1 프로파일

Maven 프로파일 `local` / `dev` / `prd` 가 있고 **`local` 이 기본 활성화**(`activeByDefault`)다.
선택한 프로파일에 따라 `src/main/resources-{env}` 가 클래스패스에 포함된다.

```xml
<resources>
    <resource><directory>${project.basedir}/src/main/resources</directory></resource>
    <resource><directory>${project.basedir}/src/main/resources-${env}</directory></resource>
</resources>
```

```bash
mvn -P local package     # 기본값
mvn -P dev   package
mvn -P prd   package
```

> 프로파일을 지정하지 않으면 **local 설정이 그대로 패키징된다.** 배포 시 `-P` 를 반드시 명시할 것.

### 4.2 설정 파일

| 파일 | 역할 |
|---|---|
| `resources/application.properties` | 세션 타임아웃, 인코딩, MVC 공통 설정 |
| `resources-{env}/application.yml` | DB · 외부 연동 · 경로 등 환경별 설정 |
| `resources-{env}/logback.xml` | 환경별 로깅 |
| `resources-{env}/static/sf/config.json` | SFMC Journey Builder 커스텀 액티비티 정의 |
| `webapp/WEB-INF/web.xml` | 404 → `/html/not.html`, 그 외 → `/error/error.mi` |

**`application.properties` (공통)**

```properties
server.error.whitelabel.enabled=false
server.servlet.session.timeout = 3600
spring.mvc.favicon.enabled = false
spring.mvc.throw-exception-if-no-handler-found=true
server.servlet.encoding.charset=utf-8
server.servlet.encoding.enabled=true
server.servlet.encoding.force=true
```

### 4.3 `application.yml` 설정 키

```yaml
jasypt:
  encryptor:
    password: <마스터 키>                   # ← 4.4 참조
    algorithm: PBEWITHHMACSHA512ANDAES_256
    pool-size: 1
    salt-generator-classname: org.jasypt.salt.RandomSaltGenerator
    iv-generator-classname: org.jasypt.iv.RandomIvGenerator
    string-output-type: base64

server:
  servlet:
    session:
      timeout: 3600                         # 초
    encoding:
      enabled: true
      charset: utf-8
      force: true
    error:
      whitelabel:
        enabled: false

spring:
  mvc:
    favicon:
      enabled: false
    throw-exception-if-no-handler-found: true    # 404 를 예외로 승격

variable:
  db-class:    org.mariadb.jdbc.Driver
  db-url:      jdbc:mariadb://<host>:3306/<database>
  db-username: <계정>
  db-password: ENC(<암호문>)

  mail-username: <SMTP 계정>                # 메일 발송
  mail-password: ENC(<암호문>)

  minio-url:      <MinIO 엔드포인트>         # 이미지 저장소
  minio-bucket:   img
  minio-username: <계정>
  minio-password: ENC(<암호문>)

  share-url:      <공유 스토리지 엔드포인트>
  share-bucket:   <버킷명>
  share-username: <계정>
  share-password: ENC(<암호문>)

  static-path:        <정적 자원 절대 경로>
  tableau-url:        <Tableau 대시보드 URL>
  coupon-image-path:  <쿠폰 이미지 경로 prefix>

  biz-url:     <문자 게이트웨이 URL>
  biz-msg-url: <메시지 전송 URL>
  biz-version: v2
  biz-Auth:    ENC(<인증 토큰 암호문>)
  biz-id:      <발신 계정 ID>

upload:
  src:         <공지 이미지 업로드 경로>
  content:     <컨텐츠 이미지 업로드 경로>
  upd_content: <컨텐츠 이미지 웹 경로>
  temp:        <멀티파트 임시 디렉터리>
```

> `variable.static-path` 와 `upload.*` 는 **절대 경로**다. 저장소에 커밋된 값은 특정
> 개발 PC 기준(`D:/work/micrm_sales/...`)이므로, 클론 후 본인 경로로 수정해야 기동된다.

### 4.4 Jasypt 암호화 값

`ENC(...)` 로 감싼 값은 기동 시 `jasypt.encryptor.password` 로 복호화된다.

**마스터 키는 설정 파일이 아니라 환경변수로 주입할 것을 권장한다.**

```bash
export JASYPT_ENCRYPTOR_PASSWORD='<마스터 키>'
```

```yaml
jasypt:
  encryptor:
    algorithm: PBEWITHHMACSHA512ANDAES_256
    # password 항목은 두지 않는다 — 환경변수로만 주입
```

---

## 5. 데이터베이스

### 5.1 접속

| 항목 | 값 |
|---|---|
| DBMS | MariaDB 10.x |
| 드라이버 | `org.mariadb.jdbc.Driver` |
| JDBC URL | `jdbc:mariadb://<host>:3306/<database>` |
| 커넥션 풀 | HikariCP |

`DatabaseConfig.kt` 의 풀 설정:

```
minimumIdle          = 1
maximumPoolSize      = 50
connectionTestQuery  = select 1
connectionTimeout    = 15,000 ms
validationTimeout    = 60,000 ms
```

실제 `DataSource` 는 log4jdbc 의 `DataSourceSpy` 로 감싸여 SQL 로그를 남긴다.
Spring Boot 의 DataSource 자동 구성은 제외되어 있고 이 클래스가 직접 빈을 만든다.

### 5.2 MyBatis 설정

`resources/mybatis/mybatis-config.xml`

| 설정 | 값 | 의미 |
|---|---|---|
| `cacheEnabled` | `false` | 매퍼 2차 캐시 전역 비활성화 |
| `useGeneratedKeys` | `false` | 생성키 자동 조회 안 함 |
| `mapUnderscoreToCamelCase` | (주석) | **비활성** — 스네이크 케이스 그대로 매핑 |
| `lazyLoadingEnabled` | `false` | 즉시 로딩 |
| `multipleResultSetsEnabled` | `true` | |
| `useColumnLabel` | `true` | |
| `defaultExecutorType` | `SIMPLE` | |
| `defaultStatementTimeout` | `10000` | **초 단위** — 약 2.8시간 |
| `typeAliases` | `com.omnilab.micrm.model` | DTO 별칭 스캔 |

매퍼 XML 위치는 `DatabaseConfig` 에서 `classpath:mybatis/mapper/*.xml` 로 지정한다.

### 5.3 매퍼

| 매퍼 | 담당 |
|---|---|
| `CommonMapper.xml` | 공통 코드, 범용 조회 |
| `SysUserMapper.xml` | 사용자 · 권한 · 접속 이력 |
| `SysSettingMapper.xml` | 팀 · 매핑 · 문자 · 카카오 · 수신거부 설정 |
| `SysSecurityMapper.xml` | 인증 |
| `MfaMapper.xml` | 2차 인증 |
| `MemberMapper.xml` | 회원 · 수신거부 |
| `ContentMapper.xml` | 이메일 / 모바일 컨텐츠 |
| `KkoAtTmplMapper.xml` | 카카오 알림톡 템플릿 |
| `CampaignMapper.xml` | 캠페인 |
| `CampaignSendMapper.xml` | 발송 큐 · 이력 |
| `ReportMapper.xml` | 리포트 집계 |
| `CostReportMapper.xml` | 발송 비용 |
| `CouponMapper.xml` | 쿠폰 |
| `SalesforceMapper.xml` | SFMC 연동 |
| `WorkHistoryMapper.xml` | 작업 이력 |

### 5.4 테이블 (41개)

접두어로 도메인을 구분한다.

**`tblmi_` — 공통 · 사용자 · 컨텐츠 (22)**

| 테이블 | 설명 |
|---|---|
| `tblmi_usr` | 사용자 |
| `tblmi_usr_auth` | 사용자 권한 |
| `tblmi_usr_hst` | 사용자 작업 이력(감사 로그) |
| `tblmi_usr_log_hst` | 로그인 이력 |
| `tblmi_comm_cd` | 공통 코드 |
| `tblmi_set_lst` | 환경 설정 항목 |
| `tblmi_mfa` | 2차 인증 코드 |
| `tblmi_cont_mst` | 컨텐츠 마스터 |
| `tblmi_cont_lst` | 컨텐츠 상세 |
| `tblmi_cont_img` | 컨텐츠 이미지 |
| `tblmi_cont_url_lst` | 컨텐츠 URL |
| `tblmi_kko_at_tmpl` | 카카오 알림톡 템플릿 |
| `tblmi_sup` | 수신거부 |
| `tblmi_block_lst` | 차단 목록 |
| `tblmi_ban_word_hst` | 금칙어 차단 이력 |
| `tblmi_target_grp` | 타겟 그룹 |
| `tblmi_target_lst` | 타겟 대상 |
| `tblmi_tbl_mst` | 업로드 테이블 마스터 |
| `tblmi_tbl_info` | 업로드 테이블 컬럼 정보 |
| `tblmi_tbl_sum` | 업로드 테이블 집계 |
| `tblmi_noti_file` | 공지 첨부 |
| `tblmi_work_hst` | 작업 이력 |

**`tblmicp_` — 캠페인 · 발송 (10)**

| 테이블 | 설명 |
|---|---|
| `tblmicp_campaign` | 캠페인 |
| `tblmicp_program` | 프로그램 |
| `tblmicp_cont_mst` / `tblmicp_cont_lst` / `tblmicp_cont_url_lst` | 캠페인 컨텐츠 |
| `tblmicp_send_hst` | 발송 이력 |
| `tblmicp_send_callback_msg` | 발송 결과 콜백 |
| `tblmicp_track_open` / `tblmicp_track_url` | 오픈 · 클릭 트래킹 |
| `tblmicp_sales_execute` | SFMC 실행 이력 |

**`tblmicou_` — 쿠폰 (5)**

`tblmicou_coupon`, `tblmicou_category`, `tblmicou_coupon_issue`,
`tblmicou_coupon_issued_log`, `tblmicou_img_file`

**`tblmire_` · `tblmite_` — 리포트 · 타겟 (4)**

`tblmire_camp_mst`, `tblmire_send_hst`, `tblmire_open_timing`, `tblmite_target_grp`

### 5.5 스키마 관리

**마이그레이션 도구(Flyway · Liquibase)가 없다.** DDL 이력을 저장소에서 관리하지 않으므로
스키마는 DBA 또는 기존 환경에서 직접 확보해야 한다. 애플리케이션은 기동 시 스키마를
생성하거나 검증하지 않는다.

---

## 6. 설치 및 실행

### 6.1 소스 받기

```bash
git clone https://git.milvusapp.com:8001/dx/developers/micrm_sales.git
cd micrm_sales
```

### 6.2 사전 준비

1. **JDK 11** 설치 및 `JAVA_HOME` 설정
2. **사내망 또는 VPN 연결** — Nexus 접근 불가 시 빌드가 실패한다 (2장 참조)
3. MariaDB 접속 정보 확보 및 스키마 준비
4. `src/main/resources-local/application.yml` 수정
   - `variable.db-*` — 로컬/개발 DB 접속 정보
   - `variable.static-path`, `upload.*` — **본인 작업 디렉터리 절대 경로로 변경**
5. Jasypt 마스터 키 설정

```bash
export JASYPT_ENCRYPTOR_PASSWORD='<마스터 키>'
```

### 6.3 빌드

```bash
mvn -P local clean package              # target/micrm-0.0.1-SNAPSHOT.war
mvn -P dev   clean package -DskipTests
mvn -P prd   clean package -DskipTests
```

컴파일만 확인:

```bash
mvn -P local clean compile
```

### 6.4 로컬 실행

**IDE** — `com.omnilab.micrm.MicrmApplication` 의 `main()` 실행.
Run Configuration 에 환경변수 `JASYPT_ENCRYPTOR_PASSWORD` 등록, 프로파일 `local`.

**Maven**

```bash
mvn -P local spring-boot:run
```

접속: `http://localhost:8080`

### 6.5 WAS 배포

`packaging=war` 이며 `ServletInitializer` 가 외부 톰캣 기동을 지원한다.

```bash
mvn -P prd clean package -DskipTests
cp target/micrm-0.0.1-SNAPSHOT.war $CATALINA_HOME/webapps/ROOT.war
```

`ServletInitializer.onStartup()` 에서 `RequestContextListener`,
`HttpSessionEventPublisher`, `SessionListener` 를 등록한다.

### 6.6 테스트

```bash
mvn test
```

> `src/test` 에는 JUnit 테스트가 사실상 없다. 파일 13개 대부분이 `main()` 기반 스크래치
> 코드이고 `@Test` 는 1개뿐이다. **빌드 성공은 컴파일 가능 여부만 의미한다.**
> 일부 테스트 파일은 실행 시 외부 운영 API 를 직접 호출하므로 주의할 것.

---

## 7. 화면 · 메뉴 구조

### 7.1 메뉴 ↔ URL

| 대메뉴 | 소메뉴 | URL |
|---|---|---|
| 회원 관리 | 업로드 회원 | `/mbr/campmbr.mi` |
| 메시지 | 이메일 | `/cont/edmLst.mi` |
| | 모바일 | `/cont/mdmLst.mi` |
| | 알림톡 템플릿 | `/cont/atTemplate.mi` |
| | 이미지 파일 | `/cont/imgLst.mi` |
| 쿠폰 | 리스트 | `/coupon/couponList.mi` |
| | 쿠폰등록 | `/coupon/couponRegister.mi` |
| | 쿠폰발급내역 | `/coupon/couponIssuedLog.mi` |
| 리포트 | 리포트 | `/report/main.mi` |
| | 발송 현황 | `/camp/st/sendStatus.mi` |
| | 발송 비용 | `/cost/costDetail.mi` |
| | 캠페인 통합 | `/report/all.mi` |
| | 차단 이력 | `/report/banWordHst.mi` |
| 시스템 관리 | 사용자 | `/sys/user/userManagement.mi` |
| | 환경 | `/sys/setting/teamSetting.mi` |
| | 내 정보 | `/sys/user/myInfo.mi` |
| | 시스템 정보 | `/sys/info/main.mi` |

### 7.2 URL 접미사 규칙

| 접미사 | 의미 | 반환 |
|---|---|---|
| `.mi` | 화면 요청 | Tiles 레이아웃이 적용된 전체 페이지 |
| `.ajax` | 비동기 요청 | JSP 조각 또는 JSON |
| `.service` | 비동기 처리 요청 | 처리 결과 |

### 7.3 컨트롤러

| 컨트롤러 | 기준 경로 | 매핑 수 | 담당 |
|---|---|---|---|
| `ContentController` | `/cont` | 48 | 이메일 · 모바일 컨텐츠, 알림톡 템플릿, 이미지 |
| `SysSettingController` | `/sys/setting` | 41 | 팀 · 매핑 · 문자 · 카카오 · 수신거부 설정 |
| `SalesforceController` | `/sf` | 36 | SFMC Journey Builder 연동 |
| `CouponController` | `/coupon` | 15 | 쿠폰 등록 · 발급 · 내역 |
| `ReportController` | (없음) | 10 | 리포트 |
| `SysUserController` | `/sys/user` | 8 | 사용자 관리 |
| `CampaignController` | `/camp` | 6 | 캠페인 발송 현황 |
| `CostController` | `/cost` | 5 | 발송 비용 |
| `CommonController` | `/error/error.mi` | 5 | 에러 · 공통 |
| `MicrmUserController` | `/mcr` | 5 | 아이디 · 비밀번호 찾기 |
| `SysInfoController` | `/sys/info` | 4 | 시스템 정보 |
| `MfaController` | (없음) | 3 | 2차 인증 |
| `SalesSysSettingController` | `/sf/{usr_cd}/sys/setting` | 3 | SFMC 전용 설정 |
| `CheckController` | (없음) | 2 | 헬스 체크 |
| `MemberController` | `/mbr` | 2 | 회원 |

### 7.4 뷰 조합 (Tiles)

`resources/tiles.xml`

```xml
<definition name="main-layout" template="/WEB-INF/layout/decorator-index.jsp">
    <put-attribute name="head"   value="/WEB-INF/layout/base-header.jsp"/>
    <put-attribute name="header" value="/WEB-INF/layout/base-body-header.jsp"/>
    <put-attribute name="menu"   value="/WEB-INF/layout/base-menu.jsp"/>
    <put-attribute name="body"   value=""/>
</definition>

<definition name="*/*"   extends="main-layout">
    <put-attribute name="body" value="/WEB-INF/views/{1}/{2}.jsp"/>
</definition>
<definition name="*/*/*" extends="main-layout">
    <put-attribute name="body" value="/WEB-INF/views/{1}/{2}/{3}.jsp"/>
</definition>
```

전용 정의가 있는 화면: `index`, `login/mfa`, `home`, `cont/salesforce`
(SFMC 화면은 메뉴 없는 `decorator-salesforce.jsp` 레이아웃을 쓴다).

컨트롤러가 `ModelAndView("sys/user/userManagement")` 를 반환하면 `*/*/*` 패턴으로
`/WEB-INF/views/sys/user/userManagement.jsp` 가 `body` 에 들어간다.

---

## 8. 주요 설정 클래스

### `MicrmApplication.kt`

```kotlin
@EnableWebSecurity
@SpringBootApplication(exclude = [
    DataSourceTransactionManagerAutoConfiguration::class,
    DataSourceAutoConfiguration::class
])
@ComponentScan(basePackages = ["com.omnilab.micrm.*"])
class MicrmApplication
```

DataSource 자동 구성을 제외하고 `DatabaseConfig` 가 직접 빈을 만든다.

### `DatabaseConfig.kt`

`HikariDataSource` → `DataSourceSpy`(log4jdbc) → `SqlSessionFactoryBean` → `SqlSessionTemplate`,
`DataSourceTransactionManager` 구성. `@EnableTransactionManagement` 적용.

### `MvcConfig.kt`

`@EnableWebMvc` 기반 수동 구성.

- **뷰 리졸버 순서** — `TilesViewResolver`(1) → `BeanNameViewResolver`(2) → `InternalResourceViewResolver`(3, `/WEB-INF/views/*.jsp`)
- **메시지 컨버터** — String(text/html, xml, jwt) · Jackson(application/json) · ByteArray(image/*) · Resource
- **필터** — `XssEscapeServletFilter`(order 1), `DeviceResolverRequestFilter`(order 2), `CharacterEncodingFilter`
- **정적 자원** — `/css/**`, `/js/**`, `/image/**`, `/font/**`, `/media/**`, `/inc/**`, `/html/**`, `/download/**`, `/favicon.ico` → `classpath:/static/...` (캐시 7일)
- **DispatcherServlet** — `throwExceptionIfNoHandlerFound = true`
- **Multipart** — `CommonsMultipartResolver`, 최대 100MB, 임시 경로 `upload.temp`
- **메시지 번들** — `classpath:/locale/messages`, 기본 로케일 `ko_KR`, 60초 캐시

### `SecurityConfig.kt`

폼 로그인(`loginProcessingUrl = /login.service`), 커스텀 `AuthenticationProvider`,
URL 단위 인가 규칙.

### `config/handler/`

| 클래스 | 역할 |
|---|---|
| `LogFilter.kt` | 요청 단위 MDC 설정(추적 ID) |
| `InterceptorHandler.kt` | 인코딩, 응답 Content-Type, MFA 리다이렉트, 감사 로그 적재 |
| `CommonExceptionHandler.kt` | `@ControllerAdvice` 전역 예외 처리 |
| `AuthenticationHandler.kt` | 인증 진입점 |
| `LoginSuccessHandler` · `LoginFailHandler` · `LogOutSuccessHandler` | 로그인 흐름 |
| `RestTemplateErrorHandler.kt` | 외부 API 오류 처리 |
| `RestInterceptorHandler.kt` | 외부 API 호출 로깅 |

---

## 9. 개발 가이드

### 9.1 화면 추가

1. `src/main/webapp/WEB-INF/views/<도메인>/<이름>.jsp` 생성
2. 컨트롤러에서 `ModelAndView("<도메인>/<이름>")` 반환 — Tiles 와일드카드가 자동 매칭
3. **뷰 이름 앞에 `/` 를 붙이지 않는다** (프로젝트 관례)
4. 메뉴 노출이 필요하면 `WEB-INF/layout/base-menu.jsp` 에 항목 추가

### 9.2 쿼리 추가

1. `mybatis/mapper/<도메인>Mapper.xml` 에 statement 추가
2. DAO 인터페이스에 메서드 선언, 구현체에서 `sqlSession.selectOne("<id>", dto)` 호출
3. DTO 는 `model` 또는 `model/table` 에 두고 `@Alias` 부여, 프로퍼티는 **스네이크 케이스**

> `selectOne` 은 결과가 없으면 `null` 을 반환한다. **DAO 반환 타입을 nullable 로 선언할 것.**
> non-null 로 선언하면 데이터가 없을 때 NPE 로 화면 전체가 실패한다.

### 9.3 ajax 조각 화면

`.ajax` 엔드포인트가 JSP 조각을 반환하면 부모 페이지의 컨테이너에 주입된다.
**조각 안의 `onclick` 등이 호출하는 함수는 부모 페이지에 정의되어 있어야 한다.**

```
/cont/senderList.ajax  →  ModelAndView("cont/mobile/ajax/senderListAjax")
                       →  부모 화면의 <div> 에 주입 (함수는 부모 스코프)
```

### 9.4 정적 자원

- 소스 위치 — `src/main/resources/static/{css,js,image,font,html,download}`
- 웹 경로 — `/css/...`, `/js/...` (`MvcConfig.addResourceHandlers`)
- 캐시 7일이 걸려 있어 수정 후 쿼리스트링 버전(`?v=0.21`)을 올려야 반영된다

### 9.5 업로드 파일

`upload.temp` 에 임시 저장 후 `upload.src` / `upload.content` 로 이동한다.
이미지는 MinIO 에도 저장된다(`variable.minio-*`).

---

## 10. 알려진 제약

이 브랜치(`feat/readme`) 기준으로 확인한 사항이다.

### 빌드 · CI

- `.gitlab-ci.yml` 이 **GitLab 기본 템플릿 그대로**다. 빌드 이미지가 `maven:3-openjdk-8` 인데
  프로젝트는 JDK 11 이므로 **CI 가 구조적으로 통과할 수 없다.**
- CI 잡이 `-P` 프로파일 없이 실행되어 `local` 설정이 패키징된다.
- 배포 잡이 참조하는 `ci_settings.xml` 이 저장소에 없다.
- `pom.xml` 파싱 시 `com.sun:tools:jar` 의 `systemPath` 미해석 오류가 출력된다.
- `tomcat.version` 을 `9.0.31` 로 고정해 Spring Boot 관리 버전보다 낮다.

### 테스트

- `src/test` 에 JUnit 테스트가 사실상 없다(`@Test` 1개). 자동화된 회귀 검증 수단이 없다.
- 일부 테스트 파일이 실행 시 **외부 운영 API 를 직접 호출**한다.

### 보안 · 설정

| 항목 | 현재 상태 |
|---|---|
| 메서드 레벨 권한(`@PreAuthorize`/`@Secured`) | **0건** — 인가는 `SecurityConfig` 의 URL 규칙에만 의존 |
| 서버측 입력 검증(`@Valid`/`@Validated`) | **0건** — 검증이 클라이언트 JS 에만 존재 |
| JSP 출력 이스케이프(`c:out`/`escapeXml`) | JSP 81개 중 **2개 파일**에서만 사용 |
| 매퍼의 `${}` 문자열 치환 | **27곳** — SQL 인젝션 표면 |
| Jasypt 마스터 키 | `application.yml` 에 평문 — 환경변수 이관 권장 |

### 데이터 정합성

- `@Transactional` 이 **6건**뿐이다. 다건 쓰기 서비스 대부분에 트랜잭션 경계가 없다.
- `DataSourceTransactionManager` 의 `isGlobalRollbackOnParticipationFailure` 가 `false` 로
  설정되어 있다. 트랜잭션을 새로 추가할 때는 이 설정을 먼저 검토할 것.
- MyBatis `defaultStatementTimeout` 이 `10000`(초)로 사실상 무제한이다.
- Kotlin 강제 언랩(`!!`)이 **447회** 사용된다.

### 운영 환경 의존

- 빌드에 사내 Nexus 접근이 필요하다(2장).
- `application.yml` 의 경로가 특정 개발 PC 기준 절대 경로다.
- DB 스키마 이력이 저장소에 없다(5.5).

---

## 라이선스

사내 프로젝트. 외부 배포 금지.
