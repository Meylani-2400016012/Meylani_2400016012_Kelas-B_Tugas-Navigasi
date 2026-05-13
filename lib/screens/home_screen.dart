import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/aurora_background.dart';
import 'add_task_screen.dart';
import 'detail_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterStatus { semua, belumSelesai, selesai }

class _HomeScreenState extends State<HomeScreen> {
  FilterStatus selectedFilter = FilterStatus.semua;

  final List<Task> tasks = [
    Task(
      title: 'Tugas Pemrograman Flutter',
      description: 'Membuat aplikasi Reminder Tugas',
      deadline: '25 Mei 2024 23:59',
      priority: 'Tinggi',
      isDone: false,
    ),
    Task(
      title: 'Tugas Basis Data',
      description: 'Membuat ERD dan normalisasi',
      deadline: '20 Mei 2024 23:59',
      priority: 'Sedang',
      isDone: true,
    ),
    Task(
      title: 'Tugas Jaringan Komputer',
      description: 'Membuat laporan topologi jaringan',
      deadline: '30 Mei 2024 23:59',
      priority: 'Rendah',
      isDone: false,
    ),
  ];

  List<Task> get filteredTasks {
    if (selectedFilter == FilterStatus.belumSelesai) {
      return tasks.where((task) => !task.isDone).toList();
    } else if (selectedFilter == FilterStatus.selesai) {
      return tasks.where((task) => task.isDone).toList();
    }
    return tasks;
  }

  int get completedCount => tasks.where((task) => task.isDone).length;

  int get unfinishedCount => tasks.where((task) => !task.isDone).length;

  double get progress {
    if (tasks.isEmpty) return 0;
    return completedCount / tasks.length;
  }

  Future<void> _goToAddTask() async {
    final newTask = await Navigator.push<Task>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const AddTaskScreen();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).chain(
            CurveTween(curve: Curves.easeOutCubic),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );

    if (newTask != null) {
      setState(() {
        tasks.add(newTask);
      });
    }
  }

  Future<void> _goToDetail(Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailTaskScreen(task: task),
      ),
    );

    setState(() {});
  }

  Color _priorityColor(String priority) {
    if (priority == 'Tinggi') return const Color(0xFFEF4444);
    if (priority == 'Sedang') return const Color(0xFFF59E0B);
    return const Color(0xFF16A34A);
  }

  Widget _glassStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.45),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.75),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: const Color(0xFF2563EB),
              size: 22,
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF111827),
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterButton(String label, FilterStatus filter) {
    final bool isSelected = selectedFilter == filter;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = filter;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF2563EB)
                : Colors.white.withOpacity(0.65),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF2563EB)
                  : Colors.white.withOpacity(0.85),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF374151),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _priorityBadge(Task task) {
    final color = _priorityColor(task.priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        task.priority,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _statusBadge(Task task) {
    final color =
        task.isDone ? const Color(0xFF16A34A) : const Color(0xFFF59E0B);
    final bgColor =
        task.isDone ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Text(
          task.isDone ? 'Selesai' : 'Belum',
          key: ValueKey(task.isDone),
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _taskCard(Task task, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 350 + (index * 90)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - value)),
            child: Transform.scale(
              scale: 0.97 + (0.03 * value),
              child: child,
            ),
          ),
        );
      },
      child: Hero(
        tag: task,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => _goToDetail(task),
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.72),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.85),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: task.isDone
                            ? [
                                const Color(0xFF16A34A),
                                const Color(0xFF22C55E),
                              ]
                            : [
                                const Color(0xFF2563EB),
                                const Color(0xFF7C3AED),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      task.isDone
                          ? Icons.check_circle_outline
                          : Icons.assignment_outlined,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            color: const Color(0xFF111827),
                            fontSize: 15.5,
                            fontWeight: FontWeight.w900,
                            decoration:
                                task.isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          task.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 11),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 14,
                              color: Color(0xFF6B7280),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                task.deadline,
                                style: const TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _priorityBadge(task),
                            const SizedBox(width: 8),
                            _statusBadge(task),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF9CA3AF),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedTasks = filteredTasks;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToAddTask,
        backgroundColor: const Color(0xFF2563EB),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tambah',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: AuroraBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Column(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value.clamp(0, 1),
                      child: Transform.translate(
                        offset: Offset(0, -30 * (1 - value)),
                        child: Transform.scale(
                          scale: 0.95 + (0.05 * value),
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.60),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.85),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withOpacity(0.18),
                          blurRadius: 28,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Halo, Mahasiswa 👋',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Hari ini waktu yang tepat untuk menyelesaikan tugasmu.',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 18),

                        Row(
                          children: [
                            _glassStatCard(
                              title: 'Total',
                              value: tasks.length.toString(),
                              icon: Icons.folder_copy_outlined,
                            ),
                            const SizedBox(width: 10),
                            _glassStatCard(
                              title: 'Selesai',
                              value: completedCount.toString(),
                              icon: Icons.check_circle_outline,
                            ),
                            const SizedBox(width: 10),
                            _glassStatCard(
                              title: 'Belum',
                              value: unfinishedCount.toString(),
                              icon: Icons.schedule_outlined,
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Progress Tugas',
                              style: TextStyle(
                                color: Color(0xFF111827),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '${(progress * 100).round()}%',
                              style: const TextStyle(
                                color: Color(0xFF2563EB),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 9),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: progress),
                            duration: const Duration(milliseconds: 700),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              return LinearProgressIndicator(
                                value: value,
                                minHeight: 10,
                                backgroundColor: Colors.white.withOpacity(0.65),
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF2563EB),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    _filterButton('Semua', FilterStatus.semua),
                    const SizedBox(width: 8),
                    _filterButton('Belum', FilterStatus.belumSelesai),
                    const SizedBox(width: 8),
                    _filterButton('Selesai', FilterStatus.selesai),
                  ],
                ),

                const SizedBox(height: 18),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Daftar Tugas',
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: displayedTasks.isEmpty
                      ? const Center(
                          child: Text(
                            'Belum ada tugas.',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: displayedTasks.length,
                          itemBuilder: (context, index) {
                            return _taskCard(displayedTasks[index], index);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}