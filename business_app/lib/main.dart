import 'package:flutter/material.dart';
void main()=>runApp(const BusinessApp());
class BusinessApp extends StatelessWidget {
 const BusinessApp({super.key});
 @override Widget build(BuildContext context)=>MaterialApp(debugShowCheckedModeBanner:false,title:'MeeLoc Business',theme:ThemeData(colorSchemeSeed:Colors.green,useMaterial3:true),home:const BusinessHome());
}
class BusinessHome extends StatelessWidget{
 const BusinessHome({super.key});
 @override Widget build(BuildContext context)=>Scaffold(
 appBar:AppBar(title:const Text('MeeLoc Business')),
 body:ListView(padding:const EdgeInsets.all(20),children:[
 const Text('Grow Your Business',style:TextStyle(fontSize:27,fontWeight:FontWeight.bold)),
 const Text('Manage your local store and offers'),
 const SizedBox(height:24),
 for(final label in ['Register Your Business','My Store','Products & Stock','Create Offer','Manage Orders','Sponsored Promotions','Earnings'])
 Card(child:ListTile(title:Text(label),trailing:const Icon(Icons.arrow_forward_ios,size:16),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>Scaffold(appBar:AppBar(title:Text(label)),body:Center(child:Text('$label — preview'))))))),
 ]));
}