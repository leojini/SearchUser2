![image](https://github.com/user-attachments/assets/270e24bc-921e-4f96-aa59-76d7035a5930)

# Clean Swift(VIP 아키텍처)
ViewController, Interactor, Presenter 각 요소는 서로에게 입력과 출력이 된다.

아래는 각 요소들이 수행되어지는 순서이다.
  
1. ViewController는 사용자 이벤트를 받아서 Interactor에게 비즈니스 로직을 요청한다.
2. Interactor는 비즈니스 로직(서버 API, 로컬 데이터 검색 등)을 수행 후 결과를 Presenter에 넘겨준다.
3. Presenter는 받은 결과를 UI에 필요한 데이터로 가공 후 ViewController에 넘겨준다.
4. ViewController는 UI 데이터를 UI에 반영한다.
5. 위 1~4번 과정을 한 사이클로 처리되면서 ViewController, Interactor, Presenter 순서의 단방향으로 흐름이
   진행되므로 로직 파악을 쉽게한다.
   그리고 각 요소들이 다른 요소의 입력 및 출력으로 작용될 때 각각의 프로토콜을 정의되어 있으므로
   프로토콜을 따르기만 하면 로직 수정이 쉬워서 테스트가 용이한다.

그렇다면 핵심 요소는 각각의 입력, 출력을 프로토콜로 구현한 부분인데 해당 부분에 대해서 상세히 들여다보자.

APIViewController에서 APIInteractor로 비즈니스 요청을 하기 위한 프로토콜을 APIBusinessLogic로 정의되어 있다.

APIInteractor에서 비즈니스 로직을 수행한 후 APIPresenter에 해당 결과를 넘겨주기 위한 프로토콜을 APIPresenterLogic로 정의되어 있다.

APIPresenter에서 받은 결과를 UI 데이터로 가공한 후 넘겨주기 위한 프로토콜을 APIDisplayLogic로 정의되어 있다.

위의 내용을 종합해보면 아래와 같다.

- APIViewController: APIBusinessLogic 프로토콜로 출력

- APIInteractor: APIPresenterLogic 프로토콜로 출력

- APIPresenter: APIDisplayLogic 프로토콜로 출력

[기타]
- Router: 다른 ViewController로의 전환 및 전환시 넘겨줄 데이터를 처리한다.
- Worker: Interactor의 비즈니스 로직 수행을 위한 인터페이스를 정의한다.
- Service: Interactor의 비즈니스 로직 수행을 위한 인터페이스를 구현한다.


[폴더구조]
- Models: 서버 API, 로컬 데이터(Realm)의 모델 정의
- Resources: Assets, Stroyboard 파일 등 리소스
- Scenes: 각 화면별 Interactor, UI Model, Presenter, ViewController, Router 정의
- Services: 비즈니스 로직 로직 구현
- Workers: 비즈니스 로직 인터페이스




![image](https://github.com/user-attachments/assets/b7e408ff-5866-4ef8-843c-3ba544ffb7f7)

![image](https://github.com/user-attachments/assets/690daa7f-4658-4da1-927e-606a64e620be)






