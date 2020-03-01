import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class Man extends StatefulWidget {
  @override
  _ManState createState() => _ManState();
}

class _ManState extends State<Man> {
  final myFormKey = GlobalKey<FormState>();
  final anotherFormKey = GlobalKey<FormState>();
  final decimal = Decimal;

  // * Equation 1 variables
  final subscapularController = TextEditingController();
  final tricipitalController = TextEditingController();
  final bicipitalController = TextEditingController();
  final supraspinalController = TextEditingController();
  final abdominalController = TextEditingController();
  String showEquationOneView = "";

  // * Equation 2 variables
  final thighController = TextEditingController();
  final legController = TextEditingController();
  String showEquationTwoView = "";

  // * Equation 3 variables
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final idealBMIController = TextEditingController();
  final carpController = TextEditingController();
  String showIdealWeight = "";
  String showIdealHeight = "";
  String showEquationThreeViewUnits = "";
  String showEquationThreeViewKilos = "";

  // * Equation 4 variable
  String showEquationFour = "";

  String showImcView = "", suggestedWeigthView = "";

  // * Perimeters
  final perimeterPectoralController = TextEditingController();
  final perimeterArmController = TextEditingController();
  final perimeterTenseArmController = TextEditingController();
  final perimeterWaistController = TextEditingController();
  final perimeterAbdomenController = TextEditingController();
  final perimeterHipController = TextEditingController();
  final perimeterThighController = TextEditingController();

  String showFolds = "";

  void bmi() {
    if (myFormKey.currentState.validate()) {
      // * Equation one
      double subscapular = double.parse(subscapularController.text);
      double tricipital = double.parse(tricipitalController.text);
      double bicipital = double.parse(bicipitalController.text);
      double supraspinal = double.parse(supraspinalController.text);
      double abdominal = double.parse(abdominalController.text);
      double resultEquationOne =
          subscapular + tricipital + bicipital + supraspinal + abdominal;

      setState(() {
        showEquationOneView = "Total: $resultEquationOne";
      });

      // * Equation two

      double thigh = double.parse(thighController.text);
      double leg = double.parse(legController.text);
      double resultEquationTwo = subscapular +
          tricipital +
          bicipital +
          supraspinal +
          abdominal +
          thigh +
          leg;

      setState(() {
        showEquationTwoView = "Total: $resultEquationTwo";
      });

      // * Equation three
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double idealBMI = double.parse(idealBMIController.text);
      double carp = double.parse(carpController.text);
      double idealWeight = idealBMI * pow(height, 2);
      double yuhaszFat = (resultEquationTwo * 0.097) + 3.64;
      double yuhaszFatActiveMan = (resultEquationTwo * 0.1051) + 5.783;
      double faulknerFat = (resultEquationOne * 0.153) + 5.783;
      double physique = height / carp;
      double fatWeight = weight * faulknerFat / 100;
      double leanWeight = weight - fatWeight;

      double weightUnits = weight * 1000;
      double idealWeightUnits = idealWeight * 1000;
      double fatWeightUnits = weight * yuhaszFatActiveMan / 100;
      double leanWeightUnits = weight - fatWeightUnits;

      double bmi = weight / pow(height, 2);

      double aksF = leanWeight * 1000 / (pow(height, 3)) / 1000;
      double aksY = leanWeightUnits * 1000 / (pow(height, 3)) / 1000;

      setState(() {
        showEquationThreeViewKilos = """\nKilos
          \n- Peso: ${roundNumber(2, weight)}
          \n- Peso ideal: ${roundNumber(2, idealWeight)}
          \n- Peso magro: ${roundNumber(2, leanWeight)}
          \n- Peso graso: ${roundNumber(2, fatWeight)}\n""";
      });

      setState(() {
        showEquationThreeViewUnits = """\nUnidades
            \n- Peso: ${roundNumber(2, weightUnits)}
            \n- Peso ideal: ${roundNumber(2, idealWeightUnits)}
            \n- Peso magro: ${roundNumber(2, leanWeightUnits)}
            \n- Peso graso: ${roundNumber(2, fatWeightUnits)}\n""";
      });

      setState(() {
        showEquationFour = """\n- IMC: ${roundNumber(2, bmi)}
        \n- AKS F: ${roundNumber(2, aksF)}
        \n- AKS Y: ${roundNumber(2, aksY)}
        \n- Constitución: ${roundNumber(2, physique)}
        \n- Grasa Faulkner: ${roundNumber(2, faulknerFat)}%
        \n- Grasa Yuhasz: ${roundNumber(2, yuhaszFat)}%
        \n Hombre activo\n- Grasa Yuhasz: ${roundNumber(2, yuhaszFatActiveMan)}%
        """;
      });
      printSnackBar("IMC Calculado");
    }
  }

  void printSnackBar(String text) =>
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));

  double roundNumber(int decimals, double number) {
    int fad = pow(10, decimals);
    return (number * fad).round() / fad;
  }

  void copyToClipBoard() {
    final String perimeterPectoral = perimeterPectoralController.text;
    final String perimeterArm = perimeterArmController.text;
    final String perimeterTenseArm = perimeterTenseArmController.text;
    final String perimeterWaist = perimeterWaistController.text;
    final String perimeterAbdomen = perimeterAbdomenController.text;
    final String perimeterHip = perimeterHipController.text;
    final String perimeterThigh = perimeterThighController.text;

    showFolds = """
    \n- Perímetros:
    \nPectoral: $perimeterPectoral.
    \nBrazo: $perimeterArm.
    \nBrazo tenso: $perimeterTenseArm.
    \nCintura: $perimeterWaist.
    \nAbdomen: $perimeterAbdomen.
    \nCadera: $perimeterHip.
    \nMúslo: $perimeterThigh.""";

    final String finalEquation =
        showEquationThreeViewKilos + '\n' + showEquationFour + '\n' + showFolds;
    final data = ClipboardData(text: finalEquation);
    Clipboard.setData(data);
    printSnackBar('Copiado al portapapeles');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              onPressed: copyToClipBoard,
              child: Icon(Icons.save),
              splashColor: Colors.redAccent,
              backgroundColor: Colors.red,
            ),
            SizedBox(
              height: 3.0,
            ),
            FloatingActionButton(
              onPressed: bmi,
              child: Icon(Icons.check),
              splashColor: Colors.redAccent,
              backgroundColor: Colors.red,
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[900],
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                key: myFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 8.0,
                            ),
                            Container(
                                child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Hombre",
                                  textScaleFactor: 2.5,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                      color: Colors.red,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black,
                                            blurRadius: 1.0)
                                      ],
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.3,
                                    ),
                                  )),
                            )),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text("IMC",
                                textScaleFactor: 1.8,
                                style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ))),
                            SizedBox(
                              height: 10.0,
                            ),
                            ListTile(
                              title: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Peso (kg)",
                                  hintStyle: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                  ),
                                ),
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                                validator: (value) {
                                  if (value.isEmpty) return "Digite el peso";
                                },
                                keyboardType: TextInputType.number,
                                controller: weightController,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            ListTile(
                              title: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Altura (cm)",
                                    hintStyle: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                      ),
                                    )),
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                                validator: (value) {
                                  if (value.isEmpty) return "Digite la altura";
                                },
                                keyboardType: TextInputType.number,
                                controller: heightController,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            ListTile(
                              title: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "IMC ideal",
                                    hintStyle: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                      ),
                                    )),
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return "Digite el IMC ideal";
                                },
                                keyboardType: TextInputType.number,
                                controller: idealBMIController,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            ListTile(
                              title: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Carpo",
                                    hintStyle: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                      ),
                                    )),
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                                validator: (value) {
                                  if (value.isEmpty) return "Digite el carpo";
                                },
                                keyboardType: TextInputType.number,
                                controller: carpController,
                              ),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      width: 160.0,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            Colors.red[600],
                                            Colors.red[700]
                                          ]),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: Center(
                                        child: Text(
                                          showEquationThreeViewKilos,
                                          style: TextStyle(
                                            fontSize: 17.7,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.5,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    VerticalDivider(width: 1.5),
                                    Container(
                                      width: 160.0,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            Colors.red[600],
                                            Colors.red[700]
                                          ]),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: Center(
                                        child: Text(
                                          showEquationThreeViewUnits,
                                          style: TextStyle(
                                            fontSize: 17.7,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.5,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Container(
                                  width: 300.0,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Colors.red[600],
                                        Colors.red[700]
                                      ]),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Center(
                                    child: Text(
                                      showEquationFour,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 35.0,
                            ),
                            Text("Pliegues",
                                textScaleFactor: 1.8,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                )),
                            SizedBox(
                              height: 5.0,
                            ),
                            ListTile(
                              title: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Subescapular",
                                    hintStyle: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                      ),
                                    )),
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return "Digite el tamaño subescapular";
                                },
                                keyboardType: TextInputType.number,
                                controller: subscapularController,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            ListTile(
                              title: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Tricipital",
                                    hintStyle: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                      ),
                                    )),
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return "Digite el tamaño tricipital";
                                },
                                keyboardType: TextInputType.number,
                                controller: tricipitalController,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            ListTile(
                              title: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Bicipital",
                                    hintStyle: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                      ),
                                    )),
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return "Digite el tamaño bicipital";
                                },
                                keyboardType: TextInputType.number,
                                controller: bicipitalController,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            ListTile(
                              title: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Supraespinal",
                                    hintStyle: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                      ),
                                    )),
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return "Digite el tamaño supraespinal";
                                },
                                keyboardType: TextInputType.number,
                                controller: supraspinalController,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            ListTile(
                              title: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Abdominal",
                                    hintStyle: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                      ),
                                    )),
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return "Digite el tamaño abdominal";
                                },
                                keyboardType: TextInputType.number,
                                controller: abdominalController,
                              ),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            Container(
                              height: 50.0,
                              width: 300.0,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.red[600],
                                    Colors.red[700]
                                  ]),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Center(
                                child: Text(
                                  showEquationOneView,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            ListTile(
                              title: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Múslo",
                                  hintStyle: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                  ),
                                ),
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return "Digite el tamaño del múslo";
                                },
                                keyboardType: TextInputType.number,
                                controller: thighController,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            ListTile(
                              title: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Pierna",
                                    hintStyle: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                      ),
                                    )),
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return "Digite el tamaño de la pierna";
                                },
                                keyboardType: TextInputType.number,
                                controller: legController,
                              ),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            Container(
                              height: 50.0,
                              width: 300.0,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.red[600],
                                    Colors.red[700]
                                  ]),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Center(
                                child: Text(
                                  showEquationTwoView,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Form(
                key: anotherFormKey,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Column(children: <Widget>[
                            Container(
                              child: Column(children: <Widget>[
                                SizedBox(
                                  height: 15.0,
                                ),
                                Text("Perímetros",
                                    textScaleFactor: 1.8,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    )),
                                SizedBox(
                                  height: 5.0,
                                ),
                                ListTile(
                                  title: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Pectoral",
                                        hintStyle: GoogleFonts.ubuntu(
                                          textStyle: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white,
                                          ),
                                        )),
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Digite el tamaño del pectoral";
                                    },
                                    keyboardType: TextInputType.number,
                                    controller: perimeterPectoralController,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                ListTile(
                                  title: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Brazo",
                                        hintStyle: GoogleFonts.ubuntu(
                                          textStyle: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white,
                                          ),
                                        )),
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Digite el tamaño del brazo";
                                    },
                                    keyboardType: TextInputType.number,
                                    controller: perimeterArmController,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                ListTile(
                                  title: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Brazo tenso",
                                        hintStyle: GoogleFonts.ubuntu(
                                          textStyle: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white,
                                          ),
                                        )),
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Digite el tamaño del brazo tenso";
                                    },
                                    keyboardType: TextInputType.number,
                                    controller: perimeterTenseArmController,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                ListTile(
                                  title: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Cintura",
                                        hintStyle: GoogleFonts.ubuntu(
                                          textStyle: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white,
                                          ),
                                        )),
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Digite el tamaño de la cintura";
                                    },
                                    keyboardType: TextInputType.number,
                                    controller: perimeterWaistController,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                ListTile(
                                  title: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Abdomen",
                                        hintStyle: GoogleFonts.ubuntu(
                                          textStyle: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white,
                                          ),
                                        )),
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Digite el tamaño del abdomen";
                                    },
                                    keyboardType: TextInputType.number,
                                    controller: perimeterAbdomenController,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                ListTile(
                                  title: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Cadera",
                                        hintStyle: GoogleFonts.ubuntu(
                                          textStyle: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white,
                                          ),
                                        )),
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Digite el tamaño de la cádera";
                                    },
                                    keyboardType: TextInputType.number,
                                    controller: perimeterHipController,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                ListTile(
                                  title: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Múslo",
                                        hintStyle: GoogleFonts.ubuntu(
                                          textStyle: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white,
                                          ),
                                        )),
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Digite el tamaño del múslo";
                                    },
                                    keyboardType: TextInputType.number,
                                    controller: perimeterThighController,
                                  ),
                                ),
                              ]),
                            )
                          ]))
                    ])),
              )
            ],
          ),
        ),
      ),
    );
  }
}
