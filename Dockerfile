# 1. 빌드 단계
FROM eclipse-temurin:17-jdk-alpine AS builder
WORKDIR /app

# Gradle 의존성 캐싱을 위해 설정 파일만 먼저 복사
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
# 라이브러리 목록만 미리 다운로드
RUN chmod +x gradlew && ./gradlew dependencies --no-daemon

# 소스 복사 및 실제 빌드
COPY src src
# plain.jar 생성 방지 및 빌드 최적화
RUN ./gradlew bootJar -x test --no-daemon

# 2. 실행 단계
FROM eclipse-temurin:17-jre-alpine
# 한글 깨짐 방지 및 로케일 설정
ENV LANG=ko_KR.UTF-8
RUN apk add --no-cache fontconfig ttf-dejavu

WORKDIR /app
# 빌드된 bootJar 파일만 특정하여 복사
COPY --from=builder /app/build/libs/*-SNAPSHOT.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-Dspring.profiles.active=prod", "-Dfile.encoding=UTF-8", "-jar", "app.jar"]
