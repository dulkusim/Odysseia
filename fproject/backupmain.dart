/*
class CityPageInfo extends StatelessWidget {
  final String cityName;

  const CityPageInfo({required this.cityName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Text(
          cityName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: TextButton.icon(
              onPressed: () {
                print('Begin button pressed for $cityName');
              },
              label: Text(
                'Begin',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              icon: Icon(
                HugeIcons.strokeRoundedSword03,
                color: Colors.white,
                size: 30,
              ),
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF11366D), // Dark blue
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(thickness: 1.0, height: 1.0, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CityImageSection(),
          ],
        ),
      ),
    );
  }
}

class CityImageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: CityPlaceholder(),
                );
              }),
            ),
          ),
        ),
        SizedBox(height: 20),
        CityPageDescription()
      ],
    );
  }
}

class CityPageDescription extends StatefulWidget {
  @override
  CityPageDescState createState() => CityPageDescState();
}

class CityPageDescState extends State<CityPageDescription> {
  bool isExpanded = false; // Tracks if the description is expanded

  final String defaultDescription =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
      "Phasellus volutpat turpis nec tortor auctor, id bibendum est "
      "congue. Aenean accumsan tellus eget lectus pretium, in facilisis "
      "leo tincidunt. Ut vitae bibendum nunc. Nulla facilisi. "
      "Suspendisse potenti. Mauris ut aliquam augue.";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isExpanded
                ? defaultDescription
                : "${defaultDescription.substring(0, 130)}...", // Shortened description
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded; // Toggle expansion state
              });
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
              isExpanded ? "Read Less" : "Read More",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              ),
            ),
          ),
          SizedBox(height: 20),
          DisplayChallengeCards(),
      ],
      ),
    );
  }
}

*/