import 'package:flutter/material.dart';
import 'package:movies/core/theme.dart';
import 'package:movies/presentation/widgets/movie_card.dart';
import 'package:movies/utils/background_painter.dart';
import 'package:movies/domain/movie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int selectedDay = 1;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _floatingAnimation;

  final List<Map<String, String>> days = [
    {'day': 'Jue', 'date': '15'},
    {'day': 'Vie', 'date': '16'},
    {'day': 'Sáb', 'date': '17'},
    {'day': 'Dom', 'date': '18'},
    {'day': 'Lun', 'date': '19'},
  ];

  final List<Movie> featuredMovies = [
    Movie(
      id: 'tt1798709',
      title: 'Her',
      posterUrl:
          'https://m.media-amazon.com/images/M/MV5BMjA1Nzk0OTM2OF5BMl5BanBnXkFtZTgwNjU2NjEwMDE@._V1_SX300.jpg',
      year: '2013',
      genre: 'Drama, Romance, Sci-Fi',
      rating: '8.0',
      plot:
          'In a near future, a lonely writer develops an unlikely relationship with an operating system designed to meet his every need.',
      director: 'Spike Jonze',
      duration: '2h 6min',
      cast: ['Joaquin Phoenix', 'Scarlett Johansson', 'Amy Adams'],
    ),
    Movie(
      id: 'tt0468569',
      title: 'The Dark Knight',
      posterUrl:
          'https://m.media-amazon.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_SX300.jpg',
      year: '2008',
      genre: 'Action, Crime, Drama',
      rating: '9.0',
      plot:
          'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham.',
      director: 'Christopher Nolan',
      duration: '2h 32min',
      cast: ['Christian Bale', 'Heath Ledger', 'Aaron Eckhart'],
    ),
    Movie(
      id: 'tt0816692',
      title: 'Interstellar',
      posterUrl:
          'https://m.media-amazon.com/images/M/MV5BZjdkOTU3MDktN2IxOS00OGEyLWFmMjktY2FiMmZkNWIyODZiXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SX300.jpg',
      year: '2014',
      genre: 'Adventure, Drama, Sci-Fi',
      rating: '8.6',
      plot:
          'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.',
      director: 'Christopher Nolan',
      duration: '2h 49min',
      cast: ['Matthew McConaughey', 'Anne Hathaway', 'Jessica Chastain'],
    ),
  ];

  // Trailers para la sección inferior
  final List<Map<String, String>> trailers = [
    {
      'id': 'tt1798709',
      'thumbnail':
          'https://m.media-amazon.com/images/M/MV5BMjA1Nzk0OTM2OF5BMl5BanBnXkFtZTgwNjU2NjEwMDE@._V1_SX300.jpg',
    },
    {
      'id': 'tt0468569',
      'thumbnail':
          'https://m.media-amazon.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_SX300.jpg',
    },
    {
      'id': 'tt0816692',
      'thumbnail':
          'https://m.media-amazon.com/images/M/MV5BZjdkOTU3MDktN2IxOS00OGEyLWFmMjktY2FiMmZkNWIyODZiXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SX300.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _floatingAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access FavoritesManager via Consumer or Provider when needed in widgets

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(),
                    SizedBox(height: 24),
                    _buildHeader(),
                    SizedBox(height: 20),
                    _buildDateSelector(),
                    SizedBox(height: 24),
                    _buildFeaturedMovies(),
                    SizedBox(height: 28),
                    _buildTrailersSection(),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.background,
                AppColors.background.withAlpha((0.8 * 255).round()),
                Color(0xFFFFD6EC),
              ],
            ),
          ),
          child: CustomPaint(
            painter: BackgroundPatternPainter(_floatingAnimation.value),
            child: Container(),
          ),
        );
      },
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/search'),
            child: Hero(
              tag: 'search_bar',
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.08 * 255).round()),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: AppColors.primary),
                      SizedBox(width: 12),
                      Text(
                        'Buscar películas...',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        _buildIconButton(Icons.notifications_outlined, () {}),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).round()),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Icon(icon, color: AppColors.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
            ).createShader(bounds),
            child: Text(
              'Explore',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Top Movies',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: days.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedDay == index;
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            margin: EdgeInsets.only(right: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() => selectedDay = index);
                  _slideController.reset();
                  _slideController.forward();
                },
                borderRadius: BorderRadius.circular(18),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              AppColors.gradientStart,
                              AppColors.gradientEnd,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? AppColors.primary.withAlpha((0.35 * 255).round())
                            : Colors.black.withAlpha((0.06 * 255).round()),
                        blurRadius: isSelected ? 14 : 6,
                        offset: Offset(0, isSelected ? 5 : 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        days[index]['day']!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        days[index]['date']!,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedMovies() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          height: 480,
          child: PageView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: featuredMovies.length,
            padEnds: false,
            controller: PageController(viewportFraction: 0.85),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: MovieCard(movie: featuredMovies[index]),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTrailersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trailers',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: trailers.length,
            itemBuilder: (context, index) {
              return Container(
                width: 140,
                margin: EdgeInsets.only(right: 12),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        trailers[index]['thumbnail']!,
                        width: 140,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.movie, color: Colors.grey[400]),
                          );
                        },
                      ),
                    ),
                    // Overlay oscuro sutil
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withAlpha((0.3 * 255).round()),
                          ],
                        ),
                      ),
                    ),
                    // Play button
                    Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha((0.9 * 255).round()),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(
                                (0.2 * 255).round(),
                              ),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).round()),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Inicio', true),
            _buildNavItem(Icons.explore_outlined, 'Explorar', false),
            SizedBox(width: 60),
            _buildNavItem(Icons.favorite_outline, 'Favoritos', false),
            _buildNavItem(Icons.person_outline, 'Perfil', false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return InkWell(
      onTap: () {
        if (label == 'Favoritos') {
          Navigator.pushNamed(context, '/favorites');
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primary : Colors.grey,
            size: 26,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.primary : Colors.grey,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha((0.4 * 255).round()),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, '/search'),
          customBorder: CircleBorder(),
          child: Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
    );
  }
}
