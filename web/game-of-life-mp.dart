import "dart:html";
import "dart:async";
import "Field.dart";

void main() {
  MainApplication mainApp = new MainApplication();
  mainApp.initialize();
}

class MainApplication {
  HtmlElement gameEle;
  Field field;
  bool loading = true;
  int loadStatus = 0;

  initialize() {
    print("Dart initialized.");
    gameEle = document.getElementById("game");

    load();
  }

  load() {
    // showLoadingAnimation();
    loadGame();

    document.getElementsByClassName("playBt")[0].onClick.listen((e) => field.ToggleSimulation());
  }

  showLoadingAnimation() {
    if (loadStatus == 0) {
      gameEle.innerHtml = "Loading.";
    } else if (loadStatus == 1) {
      gameEle.innerHtml = "Loading..";
    } else if (loadStatus == 2) {
      gameEle.innerHtml = "Loading...";
    }

    if (loadStatus < 2) {
      loadStatus++;
    } else {
      loadStatus = 0;
    }

    new Timer(new Duration(milliseconds: 0), () => showLoadingAnimation());
  }

  loadGame() {
    initializeField();
    connectToServer();
  }

  initializeField() {
    gameEle.style.maxWidth = (window.innerHeight * 0.85).round().toString() + "px";
    window.onResize.listen((e) => OnWindowResize());
    field = new Field(gameEle, width: 100, height: 100);
  }

  OnWindowResize() {
    gameEle.style.maxWidth = (window.innerHeight * 0.85).round().toString() + "px";
  }

  connectToServer() {

  }
}
