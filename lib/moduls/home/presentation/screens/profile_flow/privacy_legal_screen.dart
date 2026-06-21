import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/core/theme/app_palette.dart';

class PrivacyLegalScreen extends StatelessWidget {
  const PrivacyLegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: BackButton(
          color: AppPalette.textPrimary,
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0,
        title: const Text(
          'Privacy & Legal',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppPalette.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: const [
          Text(
            'Last Updated: May 2026',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppPalette.textSecondary,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'This Privacy Policy explains how BHEPPO LLC collects, uses, stores, and protects your information when using the Bheppo App (“App”).\n\nBy downloading or using the App, you agree to this Privacy Policy.',
            style: TextStyle(
              fontSize: 11,
              height: 1.5,
              color: AppPalette.textSecondary,
            ),
          ),
          SizedBox(height: 18),
          _PolicySection(
            title: '1. Company Information',
            lines: [
              'BHEPPO LLC',
              '971 US HIGHWAY 202N 6084',
              'BRANCHBURG, NEW JERSEY 08876',
              'United States of America',
              'Contact: support@bheppousa.com',
            ],
          ),
          _PolicySection(
            title: '2. Information We Collect',
            lines: [
              'We may collect the following information:',
              'A. Personal Information',
              '- Email address',
              '- Username or display name',
              '- Contact information',
              '- Account registration details',
              '- Uploaded tattoo designs, sketches, images, and artwork',
              'B. Payment Information',
              'Payments may be securely processed through:',
              '- Apple App Store',
              '- Google Play Store',
              '- Stripe (if applicable)',
              'We do not store full payment card information.',
              'C. Usage & Device Information',
              'We may automatically collect:',
              '- Device type',
              '- Operating system',
              '- App version',
              '- IP address',
              '- Approximate location',
              '- Usage behavior',
              '- Crash reports',
              '- Analytics information',
              'D. User Content',
              'If you upload images or tattoo artwork, we may temporarily store and process those files to provide App functionality.',
            ],
          ),
          _PolicySection(
            title: '3. How We Use Your Information',
            lines: [
              'We use information to:',
              '- Create and manage accounts',
              '- Provide stencil-generation services',
              '- Process AI-assisted image conversion',
              '- Improve App functionality',
              '- Restore saved projects and stencil history',
              '- Process subscriptions and payments',
              '- Improve AI and machine learning systems',
              '- Detect fraud, abuse, or unlawful activity',
              '- Send legal or service-related updates',
            ],
          ),
          _PolicySection(
            title: '4. AI Processing Disclosure',
            lines: [
              'The App uses artificial intelligence and automated image-processing technologies.',
              'Uploaded images and user interactions may be processed by AI systems to:',
              '- Generate tattoo stencils',
              '- Improve App performance',
              '- Train and optimize internal AI systems',
              '- Develop new features',
              '- Improve user experience',
              'We do not claim ownership of uploaded artwork.',
            ],
          ),
          _PolicySection(
            title: '5. Artwork Ownership',
            lines: [
              'You retain ownership of all artwork, images, and tattoo designs uploaded to the App.',
              'By using the App, you grant BHEPPO LLC a limited license to process, store, and display uploaded content solely for:',
              '- Providing App functionality',
              '- Generating stencil outputs',
              '- Improving App systems and AI performance',
              'We do not sell uploaded artwork.',
              'Users are responsible for ensuring they have the legal right to upload submitted content.',
            ],
          ),
          _PolicySection(
            title: '6. Third-Party Services',
            lines: [
              'We may use third-party providers including:',
              '- Cloud hosting services',
              '- Analytics providers',
              '- Payment processors',
              '- AI infrastructure providers',
              '- App store infrastructure',
              'These services may process information on our behalf.',
            ],
          ),
          _PolicySection(
            title: '7. International Data Transfers',
            lines: [
              'If you access the App outside the United States, your information may be transferred to and processed in countries where our servers or service providers operate.',
            ],
          ),
          _PolicySection(
            title: '8. Data Retention',
            lines: [
              'We retain information:',
              '- While your account is active',
              '- As required by law',
              '- For security and fraud prevention',
              '- To improve service quality',
              'You may request deletion of your account and data by contacting:',
              'support@bheppousa.com',
            ],
          ),
          _PolicySection(
            title: '9. Your Rights',
            lines: [
              'Depending on your jurisdiction, you may have the right to:',
              '- Access your data',
              '- Correct inaccurate data',
              '- Request deletion',
              '- Restrict processing',
              '- Object to profiling',
              '- Request a copy of your data',
              'EU Users (GDPR)',
              'If you are located in the European Union, you may have rights under GDPR.',
              'California Residents (CCPA/CPRA)',
              'California residents may request access to or deletion of personal information.',
              'We do not sell personal information.',
            ],
          ),
          _PolicySection(
            title: '10. Children’s Privacy',
            lines: [
              'The App is not intended for users under 16 years old.',
              'We do not knowingly collect information from children under 13.',
              'If we discover such data has been collected, it will be deleted.',
            ],
          ),
          _PolicySection(
            title: '11. Data Security',
            lines: [
              'We use reasonable technical and organizational safeguards to protect user information.',
              'However, no system can guarantee complete security.',
              'Use of the App is at your own risk.',
            ],
          ),
          _PolicySection(
            title: '12. Changes to This Policy',
            lines: [
              'We may update this Privacy Policy periodically.',
              'Changes become effective once posted in the App or on our website.',
            ],
          ),
          _PolicySection(
            title: '13. Contact',
            lines: [
              'BHEPPO LLC',
              '971 US HIGHWAY 202N 6084',
              'BRANCHBURG, NEW JERSEY 08876',
              'United States of America',
              'support@bheppousa.com',
            ],
          ),
        ],
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final List<String> lines;

  const _PolicySection({required this.title, required this.lines});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppPalette.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                line,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.45,
                  color: AppPalette.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
