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
            'These Terms of Service ("Terms") govern your use of the Bheppo Stencil AI mobile application ("App") operated by BHEPPO LLC ("we," "our," or "us"). By downloading or using the App, you agree to these Terms.',
            style: TextStyle(
              fontSize: 11,
              height: 1.5,
              color: AppPalette.textSecondary,
            ),
          ),
          SizedBox(height: 18),
          _TermsSection(
            title: '1. Company Information',
            lines: [
              'BHEPPO LLC',
              '971 US HIGHWAY 202N 6084',
              'BRANCHBURG, NEW JERSEY 08876',
              'United States of America',
              'Contact: support@bheppousa.com',
            ],
          ),
          _TermsSection(
            title: '2. Eligibility',
            lines: [
              'You must be at least 18 years old to use this App.',
              'By using the App, you confirm you are legally capable of entering into a binding agreement.',
              'The App is not intended for individuals under 16 years of age.',
            ],
          ),
          _TermsSection(
            title: '3. Description of Service',
            lines: [
              'Bheppo Stencil AI provides:',
              '• AI-powered image-to-stencil conversion tools',
              '• Tattoo stencil styles: Outline, Realism, PrintHatch, Overlay Realism',
              '• Photo upload and processing via camera or gallery',
              '• Brightness and contrast adjustment tools',
              '• Stencil save, download, and share features',
              '• Account-based sync of saved results',
            ],
          ),
          _TermsSection(
            title: '4. Account Registration',
            lines: [
              'You may need to create an account to access certain features.',
              'You are responsible for:',
              '• Maintaining your login credentials',
              '• Keeping your password secure',
              '• Providing accurate and valid information',
              'You must notify us immediately of any unauthorized use of your account.',
            ],
          ),
          _TermsSection(
            title: '5. Subscription & Billing',
            lines: [
              'The App offers:',
              '• Monthly plan: \$9.99/month',
              '• Yearly plan: \$99/year',
              '• 3-day free trial for new subscribers',
              'Subscriptions renew automatically unless canceled before the renewal date.',
              'Your account may be charged via:',
              '• Apple App Store',
              '• Google Play Store',
              '• Stripe (if applicable)',
              'You must cancel through your Apple App Store or Google Play Store account to stop billing.',
              'No refunds are guaranteed unless required by applicable law.',
            ],
          ),
          _TermsSection(
            title: '6. Intellectual Property & Artwork Ownership',
            lines: [
              'You retain full ownership of any artwork, designs, or images you upload.',
              'BHEPPO LLC does not claim ownership of your original content.',
              'However, by using the App, you grant BHEPPO LLC a limited, non-exclusive license to process your images solely to provide the App\'s services.',
              'BHEPPO LLC may use aggregated, anonymized usage data to improve the App and AI models.',
              'The App\'s software, design, branding, and generated stencil technology are owned by BHEPPO LLC.',
            ],
          ),
          _TermsSection(
            title: '7. AI Processing Disclosure',
            lines: [
              'The App uses AI-assisted image processing technology powered by Google Gemini.',
              'AI-generated stencil results may vary and are provided as-is.',
              'BHEPPO LLC does not guarantee specific results from AI processing.',
              'The App is intended for use by tattoo artists and design professionals.',
            ],
          ),
          _TermsSection(
            title: '8. Prohibited Use',
            lines: [
              'You may not:',
              '• Upload illegal, harmful, or offensive content',
              '• Infringe copyrights or trademarks of others',
              '• Reverse engineer or decompile the App',
              '• Abuse the service or attempt to exploit vulnerabilities',
              '• Use the App for any unlawful or fraudulent purpose',
              '• Share your account credentials with others',
            ],
          ),
          _TermsSection(
            title: '9. Refund Policy',
            lines: [
              'Subscriptions are processed through Apple App Store, Google Play, or Stripe.',
              'Refund decisions are governed by those platforms\' policies.',
              'You may cancel during the 3-day free trial with no charge.',
              'Contact us at support@bheppousa.com for billing inquiries.',
            ],
          ),
          _TermsSection(
            title: '10. Limitation of Liability',
            lines: [
              'The App is provided "as is" without warranties of any kind.',
              'BHEPPO LLC is not liable for:',
              '• Loss of data or stencil results',
              '• Errors in tattoo application based on App output',
              '• Payment or billing issues from third-party processors',
              '• Harm caused by AI failures, bugs, or inaccuracies',
              '• Indirect, incidental, or consequential damages',
            ],
          ),
          _TermsSection(
            title: '11. Termination',
            lines: [
              'We may suspend or terminate accounts that violate these Terms.',
              'You may delete your account at any time through the App settings.',
              'Upon termination, your access to the service and saved data may be removed.',
            ],
          ),
          _TermsSection(
            title: '12. Governing Law',
            lines: [
              'These Terms are governed by the laws of the State of New Jersey, United States.',
              'Any disputes shall be resolved in the courts of New Jersey.',
              'If any provision of these Terms is found invalid, the remaining provisions shall remain in full force.',
            ],
          ),
          _TermsSection(
            title: '13. Contact',
            lines: [
              'For questions regarding these Terms of Service:',
              'BHEPPO LLC',
              '971 US HIGHWAY 202N 6084',
              'BRANCHBURG, NEW JERSEY 08876',
              'Email: support@bheppousa.com',
            ],
          ),
          SizedBox(height: 12),
          Text(
            'BHEPPO LLC © 2026. All rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: AppPalette.textSecondary,
            ),
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
