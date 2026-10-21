import 'package:flutter/material.dart';
void main()=>runApp(const DeliveryApp());
class DeliveryApp extends StatelessWidget {
 const DeliveryApp({super.key});
 @override Widget build(BuildContext context)=>MaterialApp(debugShowCheckedModeBanner:false,title:'MeeLoc Delivery',theme:ThemeData(colorSchemeSeed:Colors.green,useMaterial3:true),home:const DeliveryHome());
}
class DeliveryHome extends StatefulWidget{
 const DeliveryHome({super.key});
 @override State<DeliveryHome> createState()=>_DeliveryHomeState();
}
class _DeliveryHomeState extends State<DeliveryHome>{
 bool available=false;
 @override Widget build(BuildContext context)=>Scaffold(
 appBar:AppBar(title:const Text('MeeLoc Delivery Partner')),
 body:ListView(padding:const EdgeInsets.all(20),children:[
 const Text('Delivery Dashboard',style:TextStyle(fontSize:27,fontWeight:FontWeight.bold)),
 const Text('Your delivery work in one place'),
 const SizedBox(height:20),
 SwitchListTile(title:const Text('Available for Orders'),subtitle:Text(available?'Online — demo mode':'Offline'),value:available,onChanged:(v)=>setState(()=>available=v)),
 for(final label in ['Partner Registration','Verification Status','Available Deliveries','Ongoing Delivery','Delivery History','Earnings'])
 Card(child:ListTile(title:Text(label),trailing:const Icon(Icons.arrow_forward_ios,size:16),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>Scaffold(appBar:AppBar(title:Text(label)),body:Center(child:Text('$label — preview'))))))),
 ]));
}