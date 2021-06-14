# 오늘의 날씨 앱
간단한 날씨를 확인할 수 있는 앱.

## 사용된 라이브러리
1. [Alamofire](https://github.com/Alamofire/Alamofire)
2. [SkeletonView](https://github.com/Juanpe/SkeletonView)

## 앱 설명
### 오늘의 날씨 탭
사용자의 현재 위치를 가져와 해당 지역의 날씨 정보를 보여주는 View
  * 시간별 날씨
  * 주간별 날씨
  * 상단의 아이콘 클릭으로 정보 Reload
  
<img src="https://github.com/Oreonhard/trainingWeatherApp/blob/master/README/mainView.gif?raw=true" width="30%" height="10%"></img>
***
### 지역별 날씨 탭
사용자의 등록한 지역별 날씨정보를 확인할 수 있는 View
  * 지역 목록별 현재 온도 확인
  * 지역 목록 클릭 시 해당 지역 상세 정보 확인
  * 상세 정보 화면에서 상단 아이콘 클릭 시 정보 Reload
  * 지역 목록 우측으로 드래그 시 삭제 가능
  
<img src="https://github.com/Oreonhard/trainingWeatherApp/blob/master/README/regionView.gif?raw=true" width="30%" height="10%"></img>
***
### 설정 탭
앱의 전반적이 정보 및 온도 단위를 설정하는 View
  * 온도 단위 설정 가능 ℃(섭씨) / ℉(화씨)
  * 현재 앱에 적용되어 있는 언어 확인 (GIF 내에선 시뮬레이터 오류로 US로 표기됨.)
  * 현재 앱의 버전정보 확인
  
<img src="https://github.com/Oreonhard/trainingWeatherApp/blob/master/README/settingView.gif?raw=true" width="30%" height="10%"></img>
