import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/core/theme/app_palette.dart';

class TermsServicesScreen extends StatelessWidget {
  const TermsServicesScreen({super.key});

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
          'Terms & Services',
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
            'These Terms & Services ("Terms") govern your use of the Bheppo App ("App") operated by BHEPPO LLC.\n\nBy downloading or using the App, you agree to these Terms.',
            style: TextStyle(
              fontSize: 11,
              height: 1.5,
              color: AppPalette.textSecondary,
            ),
          ),
          SizedBox(height: 18),
          _TermsSection(
            title: '1. Eligibility',
            lines: [
              'You must be at least 18 years old to use this App.',
              'By using the App, you confirm that:',
              '- You can legally enter binding agreements',
              '- You comply with applicable laws',
              '- You accept responsibility for your use of the App',
            ],
          ),
          _TermsSection(
            title: '2. Description of Services',
            lines: [
              'The App may provide:',
              '- AI tattoo stencil generation',
              '- Image-to-stencil conversion',
              '- Tattoo artwork enhancement tools',
              '- AI-generated artwork features',
              '- Photo upload and image processing',
              '- Cloud-based project synchronization',
              'Features may be modified, updated, or removed at any time.',
            ],
          ),
          _TermsSection(
            title: '3. Accounts',
            lines: [
              'You may need to create an account to access certain features.',
              'You are responsible for:',
              '- Maintaining account security',
              '- Protecting login credentials',
              '- Providing accurate information',
              '- Activities occurring under your account',
              'We may suspend or terminate accounts that violate these Terms.',
            ],
          ),
          _TermsSection(
            title: '4. Subscription & Billing',
            lines: [
              'The App may offer:',
              '- Free access',
              '- Paid subscriptions',
              '- Auto-renewing subscriptions',
              'Payments may be processed through:',
              '- Apple App Store',
              '- Google Play Store',
              '- Stripe',
              '- Other payment providers',
              'Subscriptions automatically renew unless canceled through your platform settings.',
              'Refunds are handled according to the payment provider\'s policies.',
            ],
          ),
          _TermsSection(
            title: '5. Intellectual Property & User Content',
            lines: [
              'You retain ownership of uploaded artwork and images.',
              'By uploading content, you grant BHEPPO LLC permission to:',
              '- Process uploaded files',
              '- Generate stencil outputs',
              '- Store files temporarily',
              '- Operate App functionality',
              '- Improve AI systems and App performance',
              'You are responsible for ensuring uploaded content does not violate third-party rights.',
            ],
          ),
          _TermsSection(
            title: '6. AI Processing Disclaimer',
            lines: [
              'The App uses AI systems and automated image-processing technologies.',
              'AI-generated results may:',
              '- Contain inaccuracies',
              '- Produce unexpected outputs',
              '- Require manual review before tattoo application',
              'Users are solely responsible for reviewing generated content before use.',
              'BHEPPO LLC is not responsible for tattoo outcomes based on AI-generated outputs.',
            ],
          ),
          _TermsSection(
            title: '7. Prohibited Uses',
            lines: [
              'You may not:',
              '- Upload unlawful content',
              '- Infringe copyrights or trademarks',
              '- Reverse engineer the App',
              '- Upload malicious software',
              '- Abuse or disrupt the service',
              '- Attempt unauthorized access',
              '- Use the App for illegal purposes',
              'Violation of these Terms may result in account suspension or termination.',
            ],
          ),
          _TermsSection(
            title: '8. Limitation of Liability',
            lines: [
              'The App is provided "AS IS" and "AS AVAILABLE."',
              'BHEPPO LLC is not liable for:',
              '- Loss of data',
              '- Tattoo application errors',
              '- AI-generated inaccuracies',
              '- Service interruptions',
              '- Subscription or payment issues',
              '- Indirect or consequential damages',
              'Use of generated tattoo stencils is entirely at your own risk.',
            ],
          ),
          _TermsSection(
            title: '9. Termination',
            lines: [
              'We may suspend or terminate access if:',
              '- These Terms are violated',
              '- Fraudulent activity is detected',
              '- Abuse of the platform occurs',
              'Users may stop using the App at any time.',
            ],
          ),
          _TermsSection(
            title: '10. Governing Law',
            lines: [
              'These Terms are governed by the laws of the State of New Jersey, United States.',
              'Any disputes shall be resolved in courts located in New Jersey.',
            ],
          ),
          _TermsSection(
            title: '11. Changes to Terms',
            lines: [
              'We may update these Terms periodically.',
              'Continued use of the App after updates means you accept the revised Terms.',
            ],
          ),
          _TermsSection(
            title: '12. Contact Information',
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

class _TermsSection extends StatelessWidget {
  final String title;
  final List<String> lines;

  const _TermsSection({required this.title, required this.lines});

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
