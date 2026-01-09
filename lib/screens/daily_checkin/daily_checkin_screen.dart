import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/user_provider.dart';
import '../../providers/burnout_provider.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/app_logo.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../dashboard/dashboard_screen.dart';

class DailyCheckInScreen extends StatefulWidget {
  const DailyCheckInScreen({super.key});
  
  @override
  State<DailyCheckInScreen> createState() => _DailyCheckInScreenState();
}

class _DailyCheckInScreenState extends State<DailyCheckInScreen> {
  final _formKey = GlobalKey<FormState>();
  double _stressLevel = 5.0;
  String _energyLevel = 'Moderate';
  String _mood = '😐';
  double _sleepHours = 7.0;
  int _activityMinutes = 30;
  double _workloadIntensity = 5.0;
  final _notesController = TextEditingController();
  bool _isLoading = false;
  
  bool _showSnapshot = false;

  Future<void> _submitCheckIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final burnoutProvider = Provider.of<BurnoutProvider>(context, listen: false);
    if (userProvider.user != null) {
      await burnoutProvider.createDailyCheckIn(
        userId: userProvider.user!.id,
        stressLevel: _stressLevel,
        energyLevel: _energyLevel,
        mood: _mood,
        sleepHours: _sleepHours,
        activityMinutes: _activityMinutes,
        workloadIntensity: _workloadIntensity,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );
      await burnoutProvider.calculateBurnout(userProvider.user!.id);
    }
    setState(() {
      _isLoading = false;
      _showSnapshot = true;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (_showSnapshot) return _buildSnapshotView();

    return Scaffold(
      backgroundColor: AppTheme.softRose,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Daily Check-In',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Take a moment to check in with yourself',
                  style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.9), fontSize: 16),
                ),
                const SizedBox(height: 32),
                _buildFormCard('Stress Level', _buildStressSlider()),
                const SizedBox(height: 16),
                _buildFormCard('Energy Level', _buildEnergySelector()),
                const SizedBox(height: 16),
                _buildFormCard('Sleep', _buildSleepSlider()),
                const SizedBox(height: 16),
                _buildFormCard('Activity', _buildActivitySelector()),
                const SizedBox(height: 32),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator(color: Colors.white))
                else
                  ElevatedButton(
                    onPressed: _submitCheckIn,
                    child: const Text('Complete Check-In'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(String title, Widget content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppTheme.deepBlue)),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildSnapshotView() {
    return Scaffold(
      backgroundColor: AppTheme.darkDashboardGreen,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppLogo(size: 40),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Wellness Score Circle
            _buildWellnessScoreCircle(92),
            const SizedBox(height: 40),
            
            // Metrics (Sleep/Activity)
            Row(
              children: [
                Expanded(child: _buildMetricTile(Icons.bedtime_outlined, 'Sleep: 7.8 hrs', 0.7)),
                const SizedBox(width: 16),
                Expanded(child: _buildMetricTile(Icons.fitness_center, 'Activity: 60 mins', 0.5)),
              ],
            ),
            const SizedBox(height: 48),
            
            // Snapshot Grid
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Today\'s Snapshot',
                style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildSnapshotGridItem(Icons.sentiment_very_satisfied, 'Joyful', const Color(0xFFC8E6C9)),
                _buildSnapshotGridItem(Icons.battery_5_bar, 'Energy: High', const Color(0xFFDCEDC8)),
                _buildSnapshotGridItem(Icons.waves, 'Stress: Low', const Color(0xFFB2DFDB)),
                _buildSnapshotGridItem(Icons.grid_view_rounded, 'Workload: Mod.', const Color(0xFFD1C4E9)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWellnessScoreCircle(int score) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: CircularProgressIndicator(
              value: score / 100,
              strokeWidth: 12,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF81C784)),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$score',
                style: GoogleFonts.outfit(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold),
              ),
              Text(
                'Wellness Score',
                style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.7), fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(IconData icon, String label, double progress) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(label, style: GoogleFonts.outfit(color: Colors.white, fontSize: 12))),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFDCEDC8)),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  Widget _buildSnapshotGridItem(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(color: color, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildStressSlider() {
    return Slider(
      value: _stressLevel,
      min: 0, max: 10, divisions: 10,
      activeColor: AppTheme.accentBlue,
      onChanged: (val) => setState(() => _stressLevel = val),
    );
  }

  Widget _buildEnergySelector() {
    return Wrap(
      spacing: 8,
      children: ['Low', 'Moderate', 'High'].map((l) => ChoiceChip(
        label: Text(l),
        selected: _energyLevel == l,
        onSelected: (s) => setState(() => _energyLevel = l),
      )).toList(),
    );
  }

  Widget _buildSleepSlider() {
    return Slider(
      value: _sleepHours,
      min: 0, max: 12, divisions: 12,
      activeColor: AppTheme.accentBlue,
      onChanged: (val) => setState(() => _sleepHours = val),
    );
  }

  Widget _buildActivitySelector() {
    return Slider(
      value: _activityMinutes.toDouble(),
      min: 0, max: 120, divisions: 12,
      activeColor: AppTheme.accentBlue,
      onChanged: (val) => setState(() => _activityMinutes = val.toInt()),
    );
  }
}
