import 'package:flutter/material.dart';
import 'home_page.dart';
import 'resumo_page.dart';
import 'perfil_page.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomePage(),
    ResumoPage(),
    PerfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.home, 0),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.bar_chart, 1),
            label: 'Resumo',
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.person, 2),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  // Função para adicionar animação aos ícones
  Widget _buildAnimatedIcon(IconData icon, int index) {
    bool isSelected = _currentIndex == index;
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: Icon(
        icon,
        size: isSelected ? 30.0 : 24.0, // Tamanho do ícone animado
        color: isSelected ? Colors.blueAccent : Colors.grey,
      ).animate().scale(
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      )
    );
  }
}
