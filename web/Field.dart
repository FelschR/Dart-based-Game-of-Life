import "dart:html";
import "dart:async";
import "dart:isolate";
import "Square.dart";
import "User.dart";

class Field {
  HtmlElement gameEle;
  bool isMouseDown;
  bool isSimulating;
  int width;
  int height;
  List<User> userList;
  User user;

  String colorRed = "#FF0000";
  String colorBlue = "#0066FF";
  String colorGreen = "#009900";
  String colorPurple = "#9900CC";

  Map<int, Map<int, Square>> field;
  Map<int, Map<int, Square>> fieldUpdated;

  Field(HtmlElement gameEle, {int width: 100, int height: 100}) {
    this.gameEle = gameEle;
    this.width = width;
    this.height = height;

    CreateField();

    userList = new List<User>();
    InitializeUser();
  }

  CreateField() {
    gameEle.hidden = true;
    field = new Map<int, Map<int, Square>>();

    for (int x = 0; x < width; x++) {
      List<Square> squareList = new List<Square>();
      DivElement rowDivEle = new DivElement();
      rowDivEle.classes.add("row");
      Map<int, Square> row = new Map<int, Square>();

      for (int y = 0; y < height; y++) {
        Square square = new Square(x, y);
        String key = x.toString() + ";" + y.toString();
        row[y] = square;
        rowDivEle.append(square.DivEle);
      }

      field[x] = row;
      gameEle.append(rowDivEle);
    }

    gameEle.onMouseDown.listen((e) => MouseDown(e));
    gameEle.onMouseUp.listen((e) => MouseUp(e));
    gameEle.onMouseOver.listen((e) => MouseOver(e));

    gameEle.hidden = false;
  }

  InitializeUser() {
    String color = colorRed;

    for (User user in userList) {
      if (user.Color == color) {
        color = colorBlue;
      }
    }

    for (User user in userList) {
      if (user.Color == color) {
        color = colorGreen;
      }
    }

    for (User user in userList) {
      if (user.Color == color) {
        color = colorPurple;
      }
    }

    user = new User(color);
  }

  ToggleSimulation() {
    isSimulating = !isSimulating;

    if (isSimulating) {
      document.getElementsByClassName("playBt")[0].text = "Stop";
    } else {
      document.getElementsByClassName("playBt")[0].text = "Play";
    }
    Simulate();
  }

  Simulate() {
    if(isSimulating) {
      SimulateStep();
      new Timer(new Duration(milliseconds: 0), () => Simulate());
    }
  }

  SimulateStep() {
    fieldUpdated = new Map<int, Map<int, Square>>();
    field.forEach((posX, row) => row.forEach((posY, square) => SimulateSquare(square)));
    UpdateField();
  }

  SimulateSquare(Square square) {
    List<String> userIdAroundList = new List<String>();

    for (int xOffset = -1; xOffset < 2; xOffset++) {
      int posX = square.posX + xOffset;
      Map<int, Square> row = field[posX];

      for (int yOffset = -1; yOffset < 2; yOffset++) {
        if (!(xOffset == 0 && yOffset == 0)) {
          int posY = square.posY + yOffset;
          if (row != null) {
            Square tmpSquare = row[posY];
            if (tmpSquare != null && tmpSquare.user != null) {
              userIdAroundList.add(tmpSquare.user.id);
            }
          }
        }
      }
    }

    Square squareUpdated = new Square(square.posX, square.posY);
    squareUpdated.SetUser(square.user);

    int userAroundLength = userIdAroundList.length;

    if ((userAroundLength == 2 && squareUpdated.user != null) || userAroundLength == 3) {
      if (squareUpdated.user == null) {
        // TODO select color / user
        squareUpdated.SetUser(user);
      }
    }
    else {
      if (squareUpdated.user != null) {
        squareUpdated.SetUser(null);
      }
    }

    int posX = square.posX;
    int posY = square.posY;

    if (fieldUpdated[posX] == null) {
      fieldUpdated[posX] = new Map<int, Square>();
    }

    fieldUpdated[posX][posY] = squareUpdated;
  }

  UpdateField() {
    gameEle.hidden = true;
    field.forEach((posX, row) => row.forEach((posY, square) => UpdateSquare(posX, posY, square)));
    gameEle.hidden = false;
  }

  UpdateSquare(int posX, int posY, Square square) {
    User newUser = fieldUpdated[posX][posY].user;
    if (square.user != newUser) {
      square.SetUser(newUser);
    }
  }

  MouseDown(MouseEvent e) {
    e.preventDefault();
    isMouseDown = true;
    List<String> splitList = e.target.id.split(";");
    int posX = int.parse(splitList.first);
    int posY = int.parse(splitList.last);

    Square square = field[posX][posY];
    square.SetUser(user);
  }

  MouseUp(MouseEvent e) {
    isMouseDown = false;
  }

  MouseOver(MouseEvent e) {
    if (isMouseDown) {
      List<String> splitList = e.target.id.split(";");
      int posX = int.parse(splitList.first);
      int posY = int.parse(splitList.last);

      Square square = field[posX][posY];
      square.SetUser(user);
    }
  }
}
