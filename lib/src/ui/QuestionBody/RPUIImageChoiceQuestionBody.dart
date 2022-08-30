part of research_package_ui;

class RPUIImageChoiceQuestionBody extends StatefulWidget {
  final RPImageChoiceAnswerFormat answerFormat;
  final String identifier;
  final Function(dynamic) onResultChance;

  RPUIImageChoiceQuestionBody(this.answerFormat, this.identifier, this.onResultChance);

  @override
  _RPUIImageChoiceQuestionBodyState createState() =>
      _RPUIImageChoiceQuestionBodyState();
}

class _RPUIImageChoiceQuestionBodyState
    extends State<RPUIImageChoiceQuestionBody>
    with AutomaticKeepAliveClientMixin<RPUIImageChoiceQuestionBody> {
  RPImageChoice? _selectedItem;

  @override
  void initState() {
    super.initState();
    RPTaskResult? _recentTaskResult = blocTask.lastTaskResult;
    if(_recentTaskResult?.results[widget.identifier] != null) {
      RPStepResult _foundStepResult =
          _recentTaskResult?.results[widget.identifier];
      setState(() {
        _selectedItem =  RPImageChoice.fromJson(_foundStepResult.results['answer']);
        widget.onResultChance(_selectedItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    RPLocalizations? locale = RPLocalizations.of(context);
    String text = (_selectedItem == null)
        ? (locale?.translate('select_image') ?? 'Select an image')
        : (locale?.translate(_selectedItem!.description) ??
            _selectedItem!.description);
    return Container(
        height: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildList(context, widget.answerFormat.choices),
            Text(
              text,
              style: Theme.of(context).textTheme.headline5,
            )
          ],
        ));
  }

  Row _buildList(BuildContext context, List<RPImageChoice> items) {
    List<Widget> list = [];
    items.forEach(
      (item) => list.add(InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          setState(() {
            _selectedItem = item == _selectedItem ? null : item;
          });
          widget.onResultChance(_selectedItem);
        },
        child: Column(children: [
          Text(item.value.toString()),
          Container(
            // Highlighting of chosen answer
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.all(Radius.circular(5 * 25 / items.length)),
              border: Border.all(
                color: _selectedItem?.value == item.value
                    ? Theme.of(context).dividerColor
                    : Colors.transparent,
                width: 3,
              ),
            ),
            // Scaling item size with number of choices
            // Max size is 125
            padding: EdgeInsets.all(10 / items.length),
            width:
                (MediaQuery.of(context).size.width * 0.8) / items.length > 125
                    ? 125
                    : MediaQuery.of(context).size.width * 0.8 / items.length,
            height:
                (MediaQuery.of(context).size.width * 0.8) / items.length > 125
                    ? 125
                    : MediaQuery.of(context).size.width * 0.8 / items.length,
            child: Image.asset(item.imageUrl),
          ),
        ]),
      )),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: list,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
