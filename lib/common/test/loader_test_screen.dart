import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/buttons/app_button.dart';
import 'package:tasklink/common/widgets/loaders/empty_state_widget.dart';
import 'package:tasklink/common/widgets/loaders/full_screen_loader.dart';
import 'package:tasklink/common/widgets/loaders/full_screen_loader_with_button.dart';
import 'package:tasklink/common/widgets/loaders/loading_overlay.dart';
import 'package:tasklink/common/widgets/loaders/task_status_banner.dart';
import 'package:tasklink/utils/constants/animation_strings.dart';
import 'package:tasklink/utils/constants/colors.dart';

/// Test screen for all loader widgets
class LoaderTestScreen extends StatefulWidget {
  const LoaderTestScreen({super.key});

  @override
  State<LoaderTestScreen> createState() => _LoaderTestScreenState();
}

class _LoaderTestScreenState extends State<LoaderTestScreen> {
  bool _isLoadingOverlay = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Loader Test Gallery',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: TColors.primary,
        foregroundColor: TColors.white,
      ),
      body: LoadingOverlay(
        isLoading: _isLoadingOverlay,
        message: 'Loading with overlay...',
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Full Screen Loaders Section
            _buildSectionHeader('Full Screen Loaders', Icons.fullscreen),
            _buildInfoText(
              'Non-dismissible loaders that cover the entire screen. User cannot go back.',
            ),
            const SizedBox(height: 12),

            AppButton(
              text: 'Show Full Screen Loader (Default)',
              type: ButtonType.primary,
              onPressed: () {
                FullScreenLoaderWithButton.show(
                  text: 'Processing your request...',
                  animation: TAnimations.greenTickAnimation2,
                  buttonText: 'OK',
                  onButtonPressed: () {
                    FullScreenLoaderWithButton.hide();
                  },
                );
                // Auto hide after 3 seconds for demo
                Future.delayed(const Duration(seconds: 10), () {
                  FullScreenLoaderWithButton.hide();
                });
              },
            ),
            const SizedBox(height: 12),

            AppButton(
              text: 'Show with Custom Animation (Loader)',
              type: ButtonType.primary,
              onPressed: () {
                FullScreenLoader.show(
                  text: 'Loading data...',
                  animation: TAnimations.loader,
                );
                // Auto hide after 3 seconds for demo
                Future.delayed(const Duration(seconds: 3), () {
                  FullScreenLoader.hide();
                });
              },
            ),
            const SizedBox(height: 12),

            AppButton(
              text: 'Show with Uploading Animation',
              type: ButtonType.primary,
              onPressed: () {
                FullScreenLoader.show(
                  text: 'Uploading files...',
                  animation: TAnimations.cloudUploading,
                );
                // Auto hide after 3 seconds for demo
                Future.delayed(const Duration(seconds: 3), () {
                  FullScreenLoader.hide();
                });
              },
            ),
            const SizedBox(height: 12),

            AppButton(
              text: 'Show with Searching Animation',
              type: ButtonType.primary,
              onPressed: () {
                FullScreenLoader.show(
                  text: 'Searching for tasks...',
                  animation: TAnimations.searching,
                );
                // Auto hide after 3 seconds for demo
                Future.delayed(const Duration(seconds: 3), () {
                  FullScreenLoader.hide();
                });
              },
            ),
            const SizedBox(height: 12),

            AppButton(
              text: 'Show with Packaging Animation',
              type: ButtonType.primary,
              onPressed: () {
                FullScreenLoader.show(
                  text: 'Preparing your order...',
                  animation: TAnimations.packagingInProgress,
                );
                // Auto hide after 4 seconds for demo
                Future.delayed(const Duration(seconds: 4), () {
                  FullScreenLoader.hide();
                });
              },
            ),

            const SizedBox(height: 32),

            // Loading Overlay Section
            _buildSectionHeader('Loading Overlay', Icons.layers),
            _buildInfoText(
              'Displays a loading indicator over the current content.',
            ),
            const SizedBox(height: 12),

            AppButton(
              text: _isLoadingOverlay ? 'Hide Overlay' : 'Show Overlay',
              type: ButtonType.secondary,
              onPressed: () {
                setState(() {
                  _isLoadingOverlay = !_isLoadingOverlay;
                });
                if (_isLoadingOverlay) {
                  // Auto hide after 3 seconds
                  Future.delayed(const Duration(seconds: 3), () {
                    if (mounted) {
                      setState(() {
                        _isLoadingOverlay = false;
                      });
                    }
                  });
                }
              },
            ),

            const SizedBox(height: 32),

            // Task Status Banners Section
            _buildSectionHeader('Task Status Banners', Icons.notifications),
            _buildInfoText(
              'Informational banners to display task status.',
            ),
            const SizedBox(height: 12),

            const TaskStatusBanner(
              title: 'Task in Progress',
              subtitle: 'Your task is being processed',
              icon: Icons.hourglass_empty,
              backgroundColor: TColors.info,
            ),
            const SizedBox(height: 12),

            const TaskStatusBanner(
              title: 'Task Completed',
              subtitle: 'Successfully completed the task',
              icon: Icons.check_circle,
              backgroundColor: TColors.success,
            ),
            const SizedBox(height: 12),

            const TaskStatusBanner(
              title: 'Action Required',
              subtitle: 'Please review and approve',
              icon: Icons.warning,
              backgroundColor: TColors.warning,
            ),
            const SizedBox(height: 12),

            const TaskStatusBanner(
              title: 'Task Failed',
              subtitle: 'An error occurred while processing',
              icon: Icons.error,
              backgroundColor: TColors.error,
            ),

            const SizedBox(height: 32),

            // Empty State Section
            _buildSectionHeader('Empty State Widgets', Icons.inbox),
            _buildInfoText(
              'Display when there\'s no content to show.',
            ),
            const SizedBox(height: 12),

            Container(
              height: 300,
              decoration: BoxDecoration(
                color: isDark ? TColors.darkContainer : TColors.lightContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: TColors.borderPrimary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: const EmptyStateWidget(
                icon: Icons.inbox_outlined,
                title: 'No Tasks Found',
                subtitle: 'You don\'t have any tasks yet. Create one to get started!',
                actionLabel: 'Create Task',
              ),
            ),
            const SizedBox(height: 16),

            const EmptyStateWidget(
              icon: Icons.search_off,
              title: 'No Results',
              subtitle: 'Try adjusting your search criteria',
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: TColors.primary, size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: TColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoText(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        color: TColors.textSecondary,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
