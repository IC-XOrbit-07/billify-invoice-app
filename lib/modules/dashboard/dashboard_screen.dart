import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:billify/core/themes/app_theme.dart';
import 'package:billify/core/constants/app_constants.dart';
import 'package:billify/modules/dashboard/dashboard_controller.dart';
import 'package:billify/routes/app_routes.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_rounded, color: AppTheme.primaryColor),
            SizedBox(width: 8),
            Text('Billify'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () =>
                Get.toNamed(AppRoutes.settings)?.then((_) => controller.refreshStats()),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => controller.refreshStats(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreeting(),
              const SizedBox(height: 20),
              _buildSummaryCards(),
              const SizedBox(height: 24),
              _buildQuickActions(),
              const SizedBox(height: 24),
              _buildRevenueCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting 👋',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Here\'s your business overview',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: Obx(() => _StatCard(
                icon: Icons.receipt_outlined,
                label: 'Invoices',
                value: '${controller.totalInvoices.value}',
                color: AppTheme.primaryColor,
              )),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Obx(() => _StatCard(
                icon: Icons.people_outline,
                label: 'Clients',
                value: '${controller.totalClients.value}',
                color: AppTheme.secondaryColor,
              )),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Obx(() => _StatCard(
                icon: Icons.check_circle_outline,
                label: 'Paid',
                value: '${controller.paidCount.value}',
                color: AppTheme.successColor,
              )),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.add_circle_outline,
                label: 'New Invoice',
                color: AppTheme.primaryColor,
                onTap: () => Get.toNamed(AppRoutes.createInvoice)
                    ?.then((_) => controller.refreshStats()),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                icon: Icons.person_add_outlined,
                label: 'Add Client',
                color: AppTheme.secondaryColor,
                onTap: () => Get.toNamed(AppRoutes.addClient)
                    ?.then((_) => controller.refreshStats()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.list_alt_outlined,
                label: 'All Invoices',
                color: AppTheme.warningColor,
                onTap: () => Get.toNamed(AppRoutes.invoiceList)
                    ?.then((_) => controller.refreshStats()),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                icon: Icons.people_outlined,
                label: 'All Clients',
                color: AppTheme.successColor,
                onTap: () => Get.toNamed(AppRoutes.clientList)
                    ?.then((_) => controller.refreshStats()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRevenueCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revenue Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => _RevenueRow(
                  label: 'Total Revenue',
                  amount: controller.totalRevenue.value,
                  color: AppTheme.primaryColor,
                )),
            const Divider(height: 24),
            Obx(() => _RevenueRow(
                  label: 'Paid',
                  amount: controller.paidRevenue.value,
                  color: AppTheme.successColor,
                )),
            const SizedBox(height: 8),
            Obx(() => _RevenueRow(
                  label: 'Unpaid',
                  amount: controller.unpaidRevenue.value,
                  color: AppTheme.errorColor,
                )),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  size: 14, color: AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _RevenueRow extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _RevenueRow({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          '${AppConstants.currency}${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
