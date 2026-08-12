import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/energy_provider.dart';
import 'widgets/time_filter.dart';
import 'widgets/usage_chart.dart';
import 'widgets/breakdown_chart.dart';
import 'widgets/savings_tip_card.dart';
import 'widgets/cost_estimator_card.dart';

/// Energy analytics screen with charts and eco-tips.
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final energyProvider = context.watch<EnergyProvider>();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
              child: Text(
                'Energy Analytics',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 24,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                'Monitor your home\'s energy consumption',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),

          // Time filter
          SliverToBoxAdapter(
            child: TimeFilterWidget(
              selectedFilter: energyProvider.selectedFilter,
              onFilterChanged: energyProvider.setFilter,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Cost Estimator Card
          const SliverToBoxAdapter(
            child: CostEstimatorCard(),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Line chart
          SliverToBoxAdapter(
            child: UsageChart(data: energyProvider.usageData),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Breakdown donut chart
          SliverToBoxAdapter(
            child: BreakdownChart(data: energyProvider.consumptionBreakdown),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Savings tip
          SliverToBoxAdapter(
            child: SavingsTipCard(
              tip: energyProvider.currentTip,
              onNextTip: energyProvider.nextTip,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

