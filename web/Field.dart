import "dart:html";
import "dart:async";
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

  // Map<String, Square> field;
  // Map<String, Square> fieldUpdated;

  Map<int, Map<int, Square>> field2;
  Map<int, Map<int, Square>> field2Updated;

  Field(HtmlElement gameEle, {int width: 100, int height: 100}) {
    this.gameEle = gameEle;
    this.width = width;
    this.height = height;

    CreateField();

    userList = new List<User>();
    InitializeUser();
  }

  CreateField() {
    // field = new Map<String, Square>();
    field2 = new Map<int, Map<int, Square>>();

    for (int x = 0; x < width; x++) {
      List<Square> squareList = new List<Square>();
      DivElement rowDivEle = new DivElement();
      rowDivEle.classes.add("row");
      Map<int, Square> row = new Map<int, Square>();

      for (int y = 0; y < height; y++) {
        Square square = new Square(x, y);
        String key = x.toString() + ";" + y.toString();
        // field[key] = square;
        row[y] = square;
        rowDivEle.append(square.DivEle);
      }

      field2[x] = row;
      gameEle.append(rowDivEle);
    }

    gameEle.onMouseDown.listen((e) => MouseDown(e));
    gameEle.onMouseUp.listen((e) => MouseUp(e));
    gameEle.onMouseOver.listen((e) => MouseOver(e));
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

    //while(isSimulating) {
      SimulateStep();
      //while (document.readyState != "complete") {}
    //}
  }

  SimulateStep() {
    // fieldUpdated = new Map<String, Square>();
    // field.forEach((key, square) => SimulateSquare(square));
    field2Updated = new Map<int, Map<int, Square>>();
    field2.forEach((posX, row) => row.forEach((posY, square) => SimulateSquare(square)));

    UpdateField();
  }

  SimulateSquare(Square square) {
    List<String> userIdAroundList = new List<String>();

    for (int xOffset = -1; xOffset < 2; xOffset++) {
      int posX = square.posX + xOffset;
      Map<int, Square> row = field2[posX];

      for (int yOffset = -1; yOffset < 2; yOffset++) {
        if (!(xOffset == 0 && yOffset == 0)) {
          // String pos = (square.posX + xOffset).toString() + ";" + (square.posY + yOffset).toString();
          int posY = square.posY + yOffset;
          // Square tmpSquare = field[pos];
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

    // String pos = square.posX.toString() + ";" + square.posY.toString();
    // fieldUpdated[pos] = squareUpdated;

    int posX = square.posX;
    int posY = square.posY;

    if (field2Updated[posX] == null) {
      field2Updated[posX] = new Map<int, Square>();
    }

    field2Updated[posX][posY] = squareUpdated;
  }

  UpdateField() {
    // field = fieldUpdated;
    field2 = field2Updated;
    gameEle.innerHtml = "";
    // field.forEach((key, square) => gameEle.append(square.divEle));
    field2.forEach((posX, row) => row.forEach((posY, square) => gameEle.append(square.divEle)));
  }

  MouseDown(MouseEvent e) {
    isMouseDown = true;
    // Square square = field[e.target.id];
    List<String> splitList = e.target.id.split(";");
    int posX = int.parse(splitList.first);
    int posY = int.parse(splitList.last);

    Square square = field2[posX][posY];
    square.SetUser(user);
  }

  MouseUp(MouseEvent e) {
    isMouseDown = false;
  }

  MouseOver(MouseEvent e) {
    if (isMouseDown) {
      // Square square = field[e.target.id];
      List<String> splitList = e.target.id.split(";");
      int posX = int.parse(splitList.first);
      int posY = int.parse(splitList.last);

      Square square = field2[posX][posY];
      square.SetUser(user);
    }
  }
}
