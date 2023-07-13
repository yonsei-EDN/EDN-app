# firstapp
lib폴더에 있는 파일 설명
main.dart : 메인화면 로드, 4가지 기능버튼 표시

기능
1. 그날그날 신장 체중 기록 --> 형식에 맞으면 로컬 txt 파일에 저장
2. 로컬에 저장된 txt 파일을 불러와 신장, 체중 기록 text()를 list로 표시
3. 성장곡선 그래프 그리기 : assets폴더의 temp.json에서 불러온 데이터 기반
4. 태어난 날 등의 user 기본 정보 수정(아직 구현하지 않음)

api 폴더 : EDN-app-dhakim의 코드와 동일, api.dart는 ChildRecord 클래스 정의, service.dart는 서버 통신 통한 CRUD기능 구현

chart 폴더 : 그래프 화면(show_health_chart.dart)과 부수적으로 필요한 파일들

information_input 폴더 : 신장/체중 기록 화면(profile_record.dart), 태어난 날 수정 화면(birth_modify.dart)

local_txt 폴더 : txt 파일 저장과 로드에 관련된 코드

modify_api 폴더 : 제가 개인적으로 만든 assets폴더의 temp.json 을 읽는 파일과 부수 클래스 Child, Record등등
https://app.quicktype.io/ 여기 페이지에서 클래스, 함수 dart 언어로 만들어줍니다.

extra_prac 폴더 : 제가 공부하면서 따라해본 연습 코드들입니다.

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
