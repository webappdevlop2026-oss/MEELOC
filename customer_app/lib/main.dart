import 'package:flutter/material.dart';
void main() => runApp(const MeelocApp());
class MeelocApp extends StatelessWidget {
 const MeelocApp({super.key});
 @override Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner:false,theme:ThemeData(colorSchemeSeed:Colors.green,useMaterial3:true),home:const MeelocHome());
}
class MeelocHome extends StatelessWidget {
 const MeelocHome({super.key});
 @override Widget build(BuildContext context) => Scaffold(
 appBar:AppBar(title:const Text('MeeLoc'),actions:[IconButton(onPressed:(){},icon:const Icon(Icons.notifications_outlined))]),
 body:ListView(padding:const EdgeInsets.all(20),children:[
 const Text('Welcome to MeeLoc',style:TextStyle(fontSize:28,fontWeight:FontWeight.bold)),
 const Text('Shop local and discover India-wide deals'),
 const SizedBox(height:24),
 for(final item in ['Local Shopping','Online Shopping','Today Offers','Categories','Saved Offers'])
 Card(child:ListTile(title:Text(item),trailing:const Icon(Icons.chevron_right),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>Scaffold(appBar:AppBar(title:Text(item)),body:Center(child:Text('$item - preview'))))))),
 ]),
 bottomNavigationBar:const NavigationBar(selectedIndex:0,destinations:[NavigationDestination(icon:Icon(Icons.home),label:'Home'),NavigationDestination(icon:Icon(Icons.local_offer),label:'Offers'),NavigationDestination(icon:Icon(Icons.person),label:'Account')]),
 );
}