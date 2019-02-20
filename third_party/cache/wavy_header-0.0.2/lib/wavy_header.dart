library wavy_header;

import 'package:flutter/material.dart';

/// A Calculator.
class WavyHeader {
  Widget child=Wrap();
  double height=250.0;
  String date="";
  String image="";
  String title="";
  String userImage="";
  String userName="";
  String description="";
  bool showmenu=true;
  Function menuTap=(){};

  WavyHeader({
    Key key,
    @required  this.title,
    @required this.image,
    @required this.height,
    @required  this.child,
    this.userImage="",
    this.userName="",
    this.description="",
    this.showmenu=true,
    this.menuTap,
    this.date=""
  });
  Widget create(){
    return Stack(
        children: <Widget>[
          _buildImage(),
          _buildHeader(),
          _buildProfileRow(),
          _buildBottomPart()
        ],
      );
  }
  _buildImage(){
    return new ClipPath(
      clipper: LogoClipper(),
      child: new Image.asset(
        image,
        fit:BoxFit.fill,
        height: height,
      )
    );
  }
  _buildHeader(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0,horizontal:8.0),
      child: new Row(
        children: <Widget>[
          (showmenu)?IconButton(
            icon: Icon(Icons.menu,size:32.0,color:Colors.white),
            onPressed: menuTap,
          ):Wrap(),
          Expanded(
            child:  Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                title,
                style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
            ),
          )
        ],
      ),
    );
  }
  _buildProfileRow(){
    return new Padding(
    padding: new EdgeInsets.only(left: 16.0, top: height/ 2.5),
    child: new Row(
      children: <Widget>[
        (userImage.isNotEmpty)?new CircleAvatar(
          minRadius: 28.0,
          maxRadius: 28.0,
          backgroundImage: new AssetImage(userImage),
        ):Wrap(),new Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              (userName.isNotEmpty)?new Text(
                userName,
                style: new TextStyle(
                    fontSize: 26.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ):Wrap(),
              (description.isNotEmpty)?new Text(
                description,
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ):Wrap(),
            ],
          ),
        ),
      ],
    ),
  );
  }
  _buildBottomPart() {
    return new Padding(
      padding: new EdgeInsets.only(top:height),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMyTasksHeader(),
          _buildTasksList(),
        ],
      ),
    );
  }
  _buildTasksList() {
    return child;
  }
  _buildMyTasksHeader() {
  return new Padding(
    padding: new EdgeInsets.only(left: 64.0),
    child: new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(
          title,
          style: new TextStyle(fontSize: 34.0),
        ),
        new Text(
          date,
          style: new TextStyle(color: Colors.grey, fontSize: 12.0),
        ),
      ],
    ),
  );
}

}




class LogoClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = new Path()
      ..lineTo(0.0, size.height-20.0);
    Offset fcp = new Offset(size.width / 4, size.height);
    Offset scp = Offset(size.width - (size.width / 3.25), size.height - 65);
    Offset fep = new Offset(size.width / 2.25, size.height - 30.0);
    Offset sep = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(fcp.dx, fcp.dy,fep.dx, fep.dy);
    path.quadraticBezierTo(scp.dx, scp.dy,sep.dx, sep.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper oldClipper)=>false;
}