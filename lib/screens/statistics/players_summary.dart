import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

import '../../api/football_api.dart';
import '../../constants.dart';
import '../../models/match.dart';
import '../../models/players_statistics.dart';

class PlayersSummary extends StatefulWidget {
  final SoccerMatch match;
  const PlayersSummary({Key key, this.match}) : super(key: key);

  @override
  _PlayersSummaryState createState() => _PlayersSummaryState();
}

class _PlayersSummaryState extends State<PlayersSummary> {
  List<PlayersStatistics> playersStatistics;
  var _isLoading = false;
  var _statLength = 0;
  @override
  void initState() {
    super.initState();
    getStatistics();
  }

  void getStatistics() async {
    isLoading = true;
    playersStatistics = await FootballApi.getPlayersStatistics(
        widget.match.fixture.id);
    log(playersStatistics.length.toString());
    isLoading = false;
    _statLength = playersStatistics.length;
    graphView(_statLength);
  }

  set isLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_isLoading)
          Center(child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ))
        else
          _statLength >0 ? Expanded(
            child: InteractiveViewer(
                constrained: false,
                // boundaryMargin: EdgeInsets.all(100),
                minScale: 0.01,
                maxScale: 5.6,
                child: Center(
                  child: GraphView(
                    animated: true,
                    graph: graph,
                    algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
                    paint: Paint()
                      ..color = Colors.green
                      ..strokeWidth = 1
                      ..style = PaintingStyle.stroke,
                    builder: (Node node) {
                      // I can decide what widget should be shown here based on the id
                      var a = node.key.value as int;
                      if (a < _statLength) {
                        return rectangleWidget(a);
                      } else {
                        // return a different widget or null
                        return SizedBox();
                      }
                      // return rectangleWidget(a);
                    },
                  ),
                )),
          ): Center(child: Text("No summary available right now"),)
      ],
    );
  }


  math.Random r = math.Random();

  Widget rectangleWidget(int index) {
    var size = MediaQuery.of(context).size;
    return Row(
      children: [
        SizedBox(width: 100,),
        InkWell(
          onTap: () {
            print('clicked');
          },
          child: Row(
            children: [
              if(playersStatistics[index].cardsYellow != 0)
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: COLOR_GREY_LIGHT),
                      shape: BoxShape.circle
                  ),
                  child: Image(image: AssetImage("assets/images/yellow_card.png"), width: 30),
                )
              else if(playersStatistics[index].cardsRed != 0)
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: COLOR_GREY_LIGHT),
                    shape: BoxShape.circle,
                  ),
                  child: Image(image: AssetImage("assets/images/yellow_red.png"), width: 30),
                )
              else
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: COLOR_GREY_LIGHT),
                    shape: BoxShape.circle,
                  ),
                  child: Image(image: AssetImage("assets/images/ball2.png"), width: 30),
                ),
              SizedBox(width: 5,),
              Column(
                children: [
                  Text(playersStatistics[index].player.name.toString()),
                  if(playersStatistics[index].cardsYellow != 0)
                    Text(
                      "Yellow Card",
                      style: TextStyle(
                        color: COLOR_GREY_LIGHT,
                      ),
                    )
                  else if(playersStatistics[index].cardsRed != 0)
                    Text(
                      "Yellow Red",
                      style: TextStyle(
                        color: COLOR_GREY_LIGHT,
                      ),
                    )
                  else
                    Text(
                      "Goal",
                      style: TextStyle(
                        color: COLOR_GREY_LIGHT,
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  final Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  void graphView(int length) {

    for(int i = 1; i<= length; i++) {
      final node1 = Node.Id(i);
      final node2 = Node.Id(i+1);
      graph.addEdge(node1, node2, paint: Paint()..color = COLOR_GREY_LIGHT);
      // graph.addEdge(node2, node3, paint: Paint()..color = COLOR_GREY_LIGHT);

    }

    builder
      ..levelSeparation = (100)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
  }

}
