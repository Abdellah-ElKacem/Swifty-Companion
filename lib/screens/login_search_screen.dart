import 'package:flutter/material.dart';
import '../api/oauth_service.dart';
import 'student_profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleSearch() async {
    final String login = _searchController.text.trim().toLowerCase();

    final validLogin = RegExp(r'^[a-zA-Z0-9_-]+$');
    



    if (login.isEmpty || !validLogin.hasMatch(login)) {
      setState(() {
        _errorMessage = "Please enter a valid 42 login";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // API call to fetch student profile
      final userProfile = await _apiService.fetchUserProfile(login);

      if (!mounted) return;

      // Navigate to View 2 if login exists, passing the fetched profile data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(userProfile: userProfile),
        ),
      );
    } catch (e) {
      // Gracefully catch and display API/network errors
      setState(() {
        _errorMessage = e.toString().replaceFirst("Exception: ", "");
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensuring a modern and flexible layout utilizing constraints
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E24), // Sleek, dark theme background
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                  ), // Keeps layout focused on tablets/web
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo or Title Icon
                      const Icon(
                        Icons.blur_on_rounded,
                        size: 100,
                        color: Color(0xFF00BABC), // Traditional 42 Teal color
                      ),
                      const SizedBox(height: 16),

                      // App Title
                      const Text(
                        "Swifty Companion",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Search and explore 42 profiles",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                      ),
                      const SizedBox(height: 40),

                      // Input Search Field
                      TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        cursorColor: const Color(0xFF00BABC),
                        decoration: InputDecoration(
                          hintText: "Enter intra login (e.g., login42)",
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Color(0xFF00BABC),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF2D2D34),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF00BABC),
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[800]!),
                          ),
                        ),
                        onSubmitted: (_) => _isLoading ? null : _handleSearch(),
                      ),
                      const SizedBox(height: 16),

                      // Error message container if one exists
                      if (_errorMessage != null) ...[
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Search Action Button
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSearch,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00BABC),
                            disabledBackgroundColor: const Color(
                              0xFF00BABC,
                            ).withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  "Search",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
