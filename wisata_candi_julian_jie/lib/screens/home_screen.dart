import 'package:flutter/material.dart';
import 'package:wisata_candi_julian_jie/data/candi_data.dart';
import 'package:wisata_candi_julian_jie/models/candi.dart';
import 'package:wisata_candi_julian_jie/widgets/item_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO: 1. Buat appbar dengan judul wisata candi
      appBar: AppBar(title: Text('Wisata Candi'),),
      //TODO: 2. buat body dengan gridview builder
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        padding: EdgeInsets.all(8),
        itemCount: candiList.length,
        itemBuilder :(context, index){
          Candi candi = candiList[index];
          return ItemCard(candi: candi);
        }
      ),
      //TODO: 3. buat Itemcard sebagai return value dari gridview 
    );
  }
}