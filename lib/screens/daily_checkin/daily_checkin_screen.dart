import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/burnout_provider.dart';
import '../../widgets/gradient_button.dart';
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
  
  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
  
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
        notes: _notesController.text.trim().isEmpty 
            ? null 
            : _notesController.text.trim(),
      );
      
      // Recalculate burnout
      await burnoutProvider.calculateBurnout(userProvider.user!.id);
    }
    
    if (!mounted) return;
    setState(() => _isLoading = false);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Daily check-in completed!'),
        backgroundColor: AppTheme.burnoutLowColor,
      ),
    );
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightPink,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Daily Check-In',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
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
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textLight,
                  ),
                ),
                const SizedBox(height: 32),
                // Stress Level
                _buildSection(
                  'Stress Level',
                  'How stressed do you feel today?',
                  _buildStressSlider(),
                ),
                const SizedBox(height: 24),
                // Energy Level
                _buildSection(
                  'Energy Level',
                  'How energetic do you feel?',
                  _buildEnergySelector(),
                ),
                const SizedBox(height: 24),
                // Mood
                _buildSection(
                  'Mood',
                  'How are you feeling?',
                  _buildMoodSelector(),
                ),
                const SizedBox(height: 24),
                // Sleep Hours
                _buildSection(
                  'Sleep',
                  'How many hours did you sleep last night?',
                  _buildSleepSlider(),
                ),
                const SizedBox(height: 24),
                // Activity
                _buildSection(
                  'Physical Activity',
                  'How many minutes of physical activity today?',
                  _buildActivitySelector(),
                ),
                const SizedBox(height: 24),
                // Workload
                _buildSection(
                  'Workload Intensity',
                  'How intense was your workload today?',
                  _buildWorkloadSlider(),
                ),
                const SizedBox(height: 24),
                // Notes (optional)
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    hintText: 'Any additional thoughts...',
                    prefixIcon: Icon(Icons.note_outlined),
                  ),
                ),
                const SizedBox(height: 32),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  GradientButton(
                    text: 'Complete Check-In',
                    onPressed: _submitCheckIn,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildSection(String title, String subtitle, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textLight,
          ),
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }
  
  Widget _buildStressSlider() {
    return Column(
      children: [
        Slider(
          value: _stressLevel,
          min: 0,
          max: 10,
          divisions: 10,
          label: _stressLevel.toStringAsFixed(1),
          activeColor: AppTheme.primaryPurple,
          onChanged: (value) {
            setState(() {
              _stressLevel = value;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Low', style: Theme.of(context).textTheme.bodySmall),
            Text('High', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
  
  Widget _buildEnergySelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppConstants.energyLevels.map((level) {
        final isSelected = _energyLevel == level;
        return ChoiceChip(
          label: Text(level),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _energyLevel = level;
            });
          },
          selectedColor: AppTheme.primaryPurple.withOpacity(0.2),
        );
      }).toList(),
    );
  }
  
  Widget _buildMoodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: AppConstants.moodOptions.map((mood) {
        final isSelected = _mood == mood;
        return GestureDetector(
          onTap: () {
            setState(() {
              _mood = mood;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppTheme.primaryPurple.withOpacity(0.2) 
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppTheme.primaryPurple : AppTheme.mediumGray,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              mood,
              style: const TextStyle(fontSize: 32),
            ),
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildSleepSlider() {
    return Column(
      children: [
        Slider(
          value: _sleepHours,
          min: 0,
          max: 12,
          divisions: 24,
          label: '${_sleepHours.toStringAsFixed(1)} hrs',
          activeColor: AppTheme.primaryPurple,
          onChanged: (value) {
            setState(() {
              _sleepHours = value;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0 hrs', style: Theme.of(context).textTheme.bodySmall),
            Text('12 hrs', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
  
  Widget _buildActivitySelector() {
    return Column(
      children: [
        Slider(
          value: _activityMinutes.toDouble(),
          min: 0,
          max: 120,
          divisions: 24,
          label: '$_activityMinutes mins',
          activeColor: AppTheme.primaryPurple,
          onChanged: (value) {
            setState(() {
              _activityMinutes = value.round();
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0 mins', style: Theme.of(context).textTheme.bodySmall),
            Text('120 mins', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
  
  Widget _buildWorkloadSlider() {
    return Column(
      children: [
        Slider(
          value: _workloadIntensity,
          min: 0,
          max: 10,
          divisions: 10,
          label: _workloadIntensity.toStringAsFixed(1),
          activeColor: AppTheme.primaryPurple,
          onChanged: (value) {
            setState(() {
              _workloadIntensity = value;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Light', style: Theme.of(context).textTheme.bodySmall),
            Text('Heavy', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}
