import 'package:flutter/material.dart';
import 'package:decibel_meter/database/database_helper.dart';
import 'package:decibel_meter/database/measurement_record.dart';
import 'package:decibel_meter/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart' as intl;

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final ScrollController _scrollController = ScrollController();

  List<MeasurementRecord> _records = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  static const int _pageSize = 20;
  intl.DateFormat? _dateFormat;
  final ValueNotifier<bool> _loadingMore = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _loadRecords();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dateFormat ??= intl.DateFormat('yyyy-MM-dd HH:mm:ss');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _loadingMore.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_hasMore || _isLoading || _loadingMore.value) return;
    if (_scrollController.position.extentAfter < 480) {
      _loadMoreRecords();
    }
  }

  Future<void> _loadRecords() async {
    setState(() {
      _isLoading = true;
      _currentPage = 0;
    });

    try {
      final records = await _dbHelper.getRecords(limit: _pageSize, offset: 0);
      final totalCount = await _dbHelper.getRecordCount();

      if (!mounted) return;
      setState(() {
        _records = records;
        _hasMore = records.length < totalCount;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('加载失败: $e')));
    }
  }

  Future<void> _loadMoreRecords() async {
    if (_isLoading || _loadingMore.value || !_hasMore) return;
    _loadingMore.value = true;

    try {
      final nextPage = _currentPage + 1;
      final records = await _dbHelper.getRecords(
        limit: _pageSize,
        offset: nextPage * _pageSize,
      );
      final totalCount = await _dbHelper.getRecordCount();

      if (!mounted) return;
      setState(() {
        _records = [..._records, ...records];
        _hasMore = _records.length < totalCount;
        _currentPage = nextPage;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('加载更多失败: $e')));
    } finally {
      _loadingMore.value = false;
    }
  }

  Future<void> _deleteRecord(MeasurementRecord record) async {
    if (record.id == null) return;

    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteRecord),
        content: Text(l10n.deleteRecordConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _dbHelper.deleteRecord(record.id!);
        if (!mounted) return;
        setState(() {
          _records.removeWhere((r) => r.id == record.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.recordDeleted)),
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('删除失败: $e')));
        }
      }
    }
  }

  Future<void> _deleteAllRecords() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAllRecords),
        content: Text(l10n.deleteAllRecordsConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _dbHelper.deleteAllRecords();
        if (!mounted) return;
        setState(() {
          _records.clear();
          _hasMore = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.allRecordsDeleted),
          ),
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('删除失败: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = _dateFormat ?? intl.DateFormat('yyyy-MM-dd HH:mm:ss');
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.history),
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
        actions: [
          if (_records.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleteAllRecords,
              tooltip: l10n.deleteAllRecords,
            ),
        ],
      ),
      body: _isLoading && _records.isEmpty
          ? const _HistoryLoadingIndicator(expanded: true)
          : _records.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noHistoryRecords,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              color: colorScheme.primary,
              backgroundColor: colorScheme.surface,
              onRefresh: _loadRecords,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 8, 12, 24),
                    addAutomaticKeepAlives: false,
                    itemCount: _records.length + (_hasMore ? 1 : 0),
                    separatorBuilder: (context, index) {
                      if (index >= _records.length - 1) {
                        return const SizedBox.shrink();
                      }
                      return Divider(
                        height: 1,
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.4,
                        ),
                      );
                    },
                    itemBuilder: (context, index) {
                      if (index >= _records.length) {
                        return ValueListenableBuilder<bool>(
                          valueListenable: _loadingMore,
                          builder: (context, loading, _) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: loading
                                  ? const _HistoryLoadingIndicator()
                                  : const SizedBox(height: 28),
                            );
                          },
                        );
                      }

                      final record = _records[index];
                      return _HistoryRecordTile(
                        key: ValueKey(record.id ?? index),
                        record: record,
                        dateText: dateFormat.format(record.dateTime),
                        durationText: _formatDuration(record.duration),
                        deleteTooltip: l10n.delete,
                        onDelete: () => _deleteRecord(record),
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }

  static String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '${seconds}s';
    }
    if (seconds < 3600) {
      final minutes = seconds ~/ 60;
      final secs = seconds % 60;
      return '${minutes}m ${secs}s';
    }
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    return '${hours}h ${minutes}m';
  }
}

class _HistoryRecordTile extends StatelessWidget {
  const _HistoryRecordTile({
    super.key,
    required this.record,
    required this.dateText,
    required this.durationText,
    required this.deleteTooltip,
    required this.onDelete,
  });

  final MeasurementRecord record;
  final String dateText;
  final String durationText;
  final String deleteTooltip;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dateText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      Text(
                        durationText,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 4,
                    children: [
                      _StatChip(label: 'Min', value: record.minDb),
                      _StatChip(label: 'Avg', value: record.avgDb),
                      _StatChip(label: 'Peak', value: record.maxDb),
                      _StatChip(label: 'P50', value: record.p50Db),
                      _StatChip(label: 'P90', value: record.p90Db),
                      _StatChip(label: 'P95', value: record.p95Db),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
              tooltip: deleteTooltip,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final double value;

  static Color _colorForDb(double db) {
    if (db < 40) return const Color(0xFF2E7D32);
    if (db < 70) return const Color(0xFFFFB300);
    if (db < 90) return const Color(0xFFFF7043);
    return const Color(0xFFC62828);
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorForDb(value);
    return Text(
      '$label ${value.toStringAsFixed(1)}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color),
    );
  }
}

class _HistoryLoadingIndicator extends StatelessWidget {
  const _HistoryLoadingIndicator({this.expanded = false});

  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: SizedBox(
        width: expanded ? 28 : 22,
        height: expanded ? 28 : 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.4,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}
