import 'package:flutter/material.dart';

class Telas extends ChangeNotifier {
    
    int _indice = 0;

    int get indice => _indice;

    void setTela(int i){
        _indice = i;
        notifyListeners();
    }
}